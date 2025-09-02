import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';
import '../view/register_view.dart';
import 'forget_password_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.6;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Obx(() => Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/6.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: imageHeight - 206),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "مرحبًا بعودتك!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF081F5C),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            hintText: 'البريد الإلكتروني',
                            prefixIcon: const Icon(Icons.email),
                            filled: true,
                            fillColor: const Color(0xFFE7F1FF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          decoration: InputDecoration(
                            hintText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0xFF334EAC),
                              ),
                              onPressed: () {
                                controller.isPasswordVisible.toggle();
                              },
                            ),
                            filled: true,
                            fillColor: const Color(0xFFE7F1FF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => const ForgetPasswordView());
                            },
                            child: const Text(
                              "نسيت كلمة المرور؟",
                              style: TextStyle(
                                color: Color(0xFF334EAC),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        controller.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF334EAC),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: controller.login,
                          child: const Text("تسجيل الدخول", style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text("أو"),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {
                            Get.to(() => const RegisterView());
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF334EAC),
                            side: const BorderSide(color: Color(0xFF334EAC)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text("إنشاء حساب", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
