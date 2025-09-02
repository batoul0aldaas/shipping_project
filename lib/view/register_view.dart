import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/register_controller.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    const double imageHeight = 150;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf0f4ff), Color(0xFFe6ecff)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.person_add_alt_1_rounded, size: 90, color: Color(0xFF334EAC)),
                  const SizedBox(height: 12),
                  const Text(
                    "مرحبًا بك!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF081F5C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "يرجى إدخال معلوماتك لإنشاء حساب جديد",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  _sectionTitle("المعلومات الشخصية"),
                  _buildInput("الاسم", Icons.person, controller.nameController, controller.nameError),
                  _buildInput("اسم الأب", Icons.person_outline, controller.fNameController, controller.fNameError),
                  _buildInput("النسب", Icons.person_2_outlined, controller.nNameController, controller.nNameError),

                  _sectionTitle("بيانات التواصل"),
                  _buildInput("البريد الإلكتروني", Icons.email, controller.emailController, controller.emailError, keyboard: TextInputType.emailAddress),
                  _buildInput("رقم الهاتف", Icons.phone, controller.phoneController, controller.phoneError, keyboard: TextInputType.phone),
                  _buildInput("كلمة المرور", Icons.lock, controller.passwordController, controller.passwordError, obscure: true),

                  _sectionTitle("السجل التجاري"),
                  Obx(() {
                    final file = controller.selectedImage.value;
                    final error = controller.imageError.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF334EAC), width: 1),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                          child: Row(
                            children: [
                              const Icon(Icons.attach_file, color: Color(0xFF334EAC)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextButton(
                                  onPressed: controller.pickImage,
                                  child: const Text("إرفاق صورة السجل التجاري"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (error.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 8),
                            child: Text(
                              error,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 6),
                        if (file != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              file,
                              height: imageHeight,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    );
                  }),

                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF334EAC),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text("تسجيل", style: TextStyle(fontSize: 15)),
                    onPressed: () {
                      final isValid = controller.validateFields();
                      if (isValid) controller.register();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String hint, IconData icon, TextEditingController controller, RxString error,
      {bool obscure = false, TextInputType keyboard = TextInputType.text}) {
    return Obx(() => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboard,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: const Color(0xFF334EAC)),
              filled: true,
              fillColor: const Color(0xFFE7F1FF),
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFB0B8D9), width: 0.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF334EAC), width: 0.5),
              ),
            ),
          ),
          if (error.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8),
              child: Text(
                error.value,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    ));
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF081F5C),
        ),
      ),
    );
  }
}
