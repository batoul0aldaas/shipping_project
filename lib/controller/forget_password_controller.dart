import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/UserModel.dart';
import '../services/auth_api_service.dart';
import '../view/verify_code_view.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final error = RxnString();
  final isLoading = false.obs;

  void sendResetCode() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      error.value = "يرجى إدخال البريد الإلكتروني";
      return;
    }

    error.value = null;
    isLoading.value = true;

    try {
      final response = await AuthApiService.forgetPassword(email);
      isLoading.value = false;

      if (response['status'] == 1 && response['data']['user'] != null) {
        final user = UserModel.fromJson(response['data']['user']);
        Get.snackbar("نجاح", "تم إرسال رمز التحقق إلى $email", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green.shade100, colorText: Colors.black);
        Get.to(() => VerifyCodeView(source: 'reset', user: user));
      } else {
        Get.snackbar("خطأ", response['message'] ?? "فشل في إرسال رمز التحقق", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade100, colorText: Colors.black);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("خطأ", "حدث خطأ في الاتصال بالسيرفر", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade100, colorText: Colors.black);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
