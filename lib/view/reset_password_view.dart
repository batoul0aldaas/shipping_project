import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/reset_password_controller.dart';

class ResetPasswordView extends StatelessWidget {
  final ResetPasswordController controller;

  const ResetPasswordView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFF),
      appBar: AppBar(
        title: const Text("تعيين كلمة مرور جديدة"),
        backgroundColor: const Color(0xFF334EAC),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "أدخل كلمة مرور جديدة",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'كلمة المرور الجديدة',
                    filled: true,
                    fillColor: Color(0xFFE7F1FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                Obx(() => TextField(
                  controller: controller.confirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'تأكيد كلمة المرور',
                    errorText: controller.error.value,
                    filled: true,
                    fillColor: const Color(0xFFE7F1FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )),
                const SizedBox(height: 50),

                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF334EAC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: controller.resetPassword,
                  child: const Text("تحديث كلمة المرور"),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
