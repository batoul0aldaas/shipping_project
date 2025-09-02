import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/forget_password_controller.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFF),
      appBar: AppBar(
        title: const Text("نسيت كلمة المرور"),
        centerTitle: true,
        backgroundColor: const Color(0xFF334EAC),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  " أدخل بريدك الإلكتروني لإرسال رمز التحقق",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF081F5C),
                  ),
                ),
                const SizedBox(height: 40),

                Obx(() => TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    hintText: 'البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.email),
                    errorText: controller.error.value,
                    filled: true,
                    fillColor: const Color(0xFFE7F1FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )),
                const SizedBox(height: 40),

                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF334EAC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: controller.sendResetCode,
                  child: const Text("إرسال رمز التحقق"),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
