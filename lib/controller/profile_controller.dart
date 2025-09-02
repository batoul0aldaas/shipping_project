import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/ProfileModel.dart';
import '../services/profile_api_service.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var isUploadingImage = false.obs;
  var user = Rxn<ProfileModel>();
  var errorMessage = ''.obs;

  // Controllers for editing
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final thirdNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  var isEditing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    secondNameController.dispose();
    thirdNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void fillControllers() {
    if (user.value != null) {
      firstNameController.text = user.value!.firstName;
      secondNameController.text = user.value!.secondName;
      thirdNameController.text = user.value!.thirdName;
      emailController.text = user.value!.email;
      phoneController.text = user.value!.phone ?? '';
    }
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      user.value = await ProfileApiService.fetchProfile();
      fillControllers();
    } catch (e) {
      errorMessage.value = e.toString();
      user.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isUpdating.value = true;
      user.value = await ProfileApiService.updateProfile({
        'first_name': firstNameController.text,
        'second_name': secondNameController.text,
        'third_name': thirdNameController.text,
        'email': emailController.text,
        'phone': phoneController.text.isEmpty ? null : phoneController.text,
      });
      isEditing.value = false;
      _showSuccessSnackbar('تم التحديث!', 'تم تحديث المعلومات بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في التحديث', e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        await uploadProfileImage(File(image.path));
      }
    } catch (e) {
      _showErrorSnackbar('خطأ', e.toString());
    }
  }

  Future<void> uploadProfileImage(File imageFile) async {
    try {
      isUploadingImage.value = true;
      user.value = await ProfileApiService.uploadImage(imageFile);
      _showSuccessSnackbar('تم الرفع!', 'تم رفع صورة الملف الشخصي');
    } catch (e) {
      _showErrorSnackbar('خطأ في الرفع', e.toString());
    } finally {
      isUploadingImage.value = false;
    }
  }

  Future<void> deleteProfileImage() async {
    try {
      isUploadingImage.value = true;
      user.value = await ProfileApiService.deleteImage();
      _showSuccessSnackbar('تم الحذف!', 'تم حذف صورة الملف الشخصي');
    } catch (e) {
      _showErrorSnackbar('خطأ في الحذف', e.toString());
    } finally {
      isUploadingImage.value = false;
    }
  }

  void toggleEdit() {
    if (isEditing.value) {
      fillControllers();
    }
    isEditing.value = !isEditing.value;
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFF10B981).withOpacity(0.1),
      colorText: const Color(0xFF10B981),
      icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
      snackPosition: SnackPosition.TOP,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
    );
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFFEF4444).withOpacity(0.1),
      colorText: const Color(0xFFEF4444),
      icon: const Icon(Icons.error_rounded, color: Color(0xFFEF4444)),
      snackPosition: SnackPosition.TOP,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
    );
  }
}
