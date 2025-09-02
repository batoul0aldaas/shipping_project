import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/UserModel.dart';
import '../services/auth_api_service.dart';
import '../view/verify_code_view.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final fNameController = TextEditingController();
  final nNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final Rx<File?> selectedImage = Rx<File?>(null);

  final RxString nameError = ''.obs;
  final RxString fNameError = ''.obs;
  final RxString nNameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString phoneError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString imageError = ''.obs;

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
      imageError.value = '';
    }
  }

  bool validateFields() {
    nameError.value = '';
    fNameError.value = '';
    nNameError.value = '';
    emailError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    imageError.value = '';

    bool isValid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'الرجاء إدخال الاسم';
      isValid = false;
    }
    if (fNameController.text.trim().isEmpty) {
      fNameError.value = 'الرجاء إدخال اسم الأب';
      isValid = false;
    }
    if (nNameController.text.trim().isEmpty) {
      nNameError.value = 'الرجاء إدخال النسب';
      isValid = false;
    }
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'الرجاء إدخال البريد الإلكتروني';
      isValid = false;
    }
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'الرجاء إدخال رقم الهاتف';
      isValid = false;
    }
    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'الرجاء إدخال كلمة المرور';
      isValid = false;
    }
    if (selectedImage.value == null) {
      imageError.value = 'يرجى اختيار صورة السجل التجاري';
      isValid = false;
    }

    return isValid;
  }

  Future<void> register() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!validateFields()) return;

    final user = UserModel(
      firstName: nameController.text.trim(),
      secondName: fNameController.text.trim(),
      thirdName: nNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
      isVerified: false,
    );

    try {
      final response = await AuthApiService.register(
        user.toRegisterMap(),
        filePath: selectedImage.value!.path,
      );

      if (response['status'] == 1 && response['data']?['user'] != null) {
        final registeredUser = UserModel.fromJson(response['data']['user']);
        Get.to(() => VerifyCodeView(source: 'register', user: registeredUser));
      } else {
        final message = _extractErrorMessage(response['message']);
        Get.snackbar("خطأ", message ?? "فشل التسجيل");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء الاتصال بالخادم");
    }
  }

  String? _extractErrorMessage(dynamic message) {
    if (message is String) return message;

    if (message is Map<String, dynamic>) {
      for (var value in message.values) {
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        } else if (value is String) {
          return value;
        }
      }
    }

    return null;
  }

  @override
  void onClose() {
    nameController.dispose();
    fNameController.dispose();
    nNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
