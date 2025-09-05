import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/complaint_api_service.dart';
import 'complaints_list_view.dart';

class ComplaintView extends StatelessWidget {
  ComplaintView({super.key});

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  void _sendComplaint(BuildContext context) async {
    final subject = _titleController.text.trim();
    final message = _descController.text.trim();

    if (subject.isEmpty || message.isEmpty) {
      Get.snackbar(
        "خطأ",
        "الرجاء إدخال عنوان ووصف الشكوى",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.2),
        colorText: Colors.red[800],
      );
      return;
    }
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Color(0xFF334EAC))),
      barrierDismissible: false,
    );

    try {
      final response = await ComplaintApiService.addComplaint(
        subject: subject,
        message: message,
      );

      Get.back();

      Get.snackbar(
        "نجاح",
        response['message'] ?? "تم إرسال الشكوى بنجاح",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.2),
        colorText: Colors.green[800],
      );
      Get.off(() => ComplaintsListView());

    } catch (e) {
      Get.back();
      Get.snackbar(
        "خطأ",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.2),
        colorText: Colors.red[800],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Gradient appBarGradient = const LinearGradient(
      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "إرسال شكوى",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: appBarGradient),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: appBarGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.report_problem_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 40),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 12,
                shadowColor: Colors.black12,
                color: const Color(0xFFF0F4FF),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: "عنوان الشكوى",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.title_rounded, color: Color(0xFF667EEA)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _descController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: "وصف الشكوى",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.description_rounded, color: Color(0xFF667EEA)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: appBarGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () => _sendComplaint(context),
                          icon: const Icon(Icons.send_rounded, color: Colors.white),
                          label: const Text(
                            "إرسال الشكوى",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "يمكنك إرسال شكوى وسنقوم بالرد عليها في أقرب وقت ممكن.",
                style: TextStyle(color: Colors.black54, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
