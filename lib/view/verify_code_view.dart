import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/verify_code_controller.dart';
import '../model/UserModel.dart';
import '../services/auth_api_service.dart';

class VerifyCodeView extends StatelessWidget {
  final String source;
  final UserModel user;

  const VerifyCodeView({super.key, required this.source, required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyCodeController(source: source, user: user));

    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Card(
                elevation: 10,
                color: const Color(0xFFF9FCFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                shadowColor: Colors.black45,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "رمز التحقق",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF334EAC)),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "أدخل رمز التحقق المرسل إلى",
                        style: TextStyle(fontSize: 16, color: Color(0xFF081F5C)),
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF081F5C)),
                      ),
                      const SizedBox(height: 24),

                      Obx(() => controller.error.value != null
                          ? Text(
                        controller.error.value!,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                      )
                          : const SizedBox.shrink()),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Flexible(
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 70),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 60,
                              child: TextField(
                                controller: controller.controllers[index],
                                focusNode: controller.focusNodes[index],
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF334EAC)),
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: const Color(0xFFE7F1FF),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFF334EAC), width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFF081F5C), width: 3),
                                  ),
                                ),
                                onChanged: (value) => controller.handleInput(index, value),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.verifyCode(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF334EAC),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 6,
                          ),
                          child: const Text("تحقق", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () async {
                          final response = await AuthApiService.refreshCode(user.id);
                          if (response['status'] == 1) {
                            Get.snackbar(
                              "إعادة إرسال",
                              "تم إرسال رمز تحقق جديد إلى ${user.email}",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.shade100,
                              colorText: Colors.black,
                            );
                          } else {
                            Get.snackbar(
                              "فشل الإرسال",
                              response['message'] ?? "حدث خطأ أثناء إرسال الرمز",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red.shade100,
                              colorText: Colors.black,
                            );
                          }
                        }
                        ,
                        child: const Text(
                          "إعادة إرسال الرمز؟",
                          style: TextStyle(color: Color(0xFF334EAC), fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
