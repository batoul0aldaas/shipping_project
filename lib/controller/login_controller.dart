
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/UserModel.dart';
import '../services/auth_api_service.dart';
import '../services/api_service.dart';
import '../view/home_page.dart';
import '../view/verify_code_view.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  final emailError = RxnString();
  final passwordError = RxnString();
  final isLoading = false.obs;

  final box = GetStorage();

  void login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    emailError.value = null;
    passwordError.value = null;

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      emailError.value = email.isEmpty ? "البريد الإلكتروني مطلوب" : null;
      passwordError.value = password.isEmpty ? "كلمة المرور مطلوبة" : null;
      return;
    }

    isLoading.value = true;

    try {
      final response = await AuthApiService.login(email: email, password: password);
      isLoading.value = false;

      if (response['status'] == 1 && response['data']['user'] != null) {
        final user = UserModel.fromJson(response['data']['user']);

        if (response['data']['code'] != null) {
          Get.to(() => VerifyCodeView(source: 'login', user: user));
        } else {
          final token = response['data']['token'];
          user.setTOKEN(token);
          user.setIsVerified(true);

          ApiService.token = token;
          await GetStorage().write('token', token);

          Get.offAll(() => const HomePage());
        }
      } else {
        final message = _extractErrorMessage(response['message']);
        Get.snackbar("خطأ", message ?? "فشل تسجيل الدخول");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("خطأ", "فشل الاتصال بالخادم");
    }
  }




  String? _extractErrorMessage(dynamic message) {
    if (message is String) {
      if (message == "auth.incorrect_credentials") {
        return "البريد الإلكتروني أو كلمة المرور غير صحيحة.";
      }
      return message;
    }

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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
