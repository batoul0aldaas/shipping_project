import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/UserModel.dart';
import '../services/auth_api_service.dart';
import '../view/login_view.dart';

class ResetPasswordController extends GetxController {
  final UserModel user;

  ResetPasswordController({required this.user});

  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final error = RxnString();
  final isLoading = false.obs;

  void resetPassword() async {
    final password = passwordController.text;
    final confirm = confirmController.text;

    if (password != confirm) {
      error.value = "كلمتا المرور غير متطابقتين";
      return;
    }

    if (password.length < 6) {
      error.value = "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
      return;
    }

    error.value = null;
    isLoading.value = true;

    try {
      final response = await AuthApiService.resetPassword(
        userId: user.id,
        password: password,
        confirmPassword: confirm,
      );

      isLoading.value = false;

      if (response['status'] == 1) {
        Get.snackbar(
          "تم التحديث",
          "تم تغيير كلمة المرور بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black87,
          duration: const Duration(seconds: 2),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => const LoginView());
        });
      } else {
        Get.snackbar(
          "خطأ",
          response['message'] ?? "فشل في تغيير كلمة المرور",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "خطأ",
        "حدث خطأ في الاتصال بالسيرفر",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmController.dispose();
    super.onClose();
  }
}
