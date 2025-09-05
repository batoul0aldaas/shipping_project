import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/complaint_api_service.dart';

class ComplaintController extends GetxController {
  var complaints = <dynamic>[].obs;
  var isLoading = false.obs;

  Future<void> fetchComplaints() async {
    try {
      isLoading.value = true;
      final data = await ComplaintApiService.getComplaints();
      complaints.assignAll(data);
    } catch (e) {
      Get.snackbar("خطأ", e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.2),
          colorText: Colors.red[800]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendComplaint({required String subject, required String message}) async {
    if(subject.isEmpty || message.isEmpty){
      Get.snackbar("خطأ", "الرجاء إدخال عنوان ووصف الشكوى");
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

      Get.back(); // اغلاق الـ Dialog
      Get.snackbar("نجاح", response['message'] ?? "تم إرسال الشكوى بنجاح",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.2),
          colorText: Colors.green[800]);
    } catch (e) {
      Get.back();
      Get.snackbar("خطأ", e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.2),
          colorText: Colors.red[800]);
    }
  }
  Future<Map<String,dynamic>> getComplaintInfo(int id) async {
    try {
      final data = await ComplaintApiService.getComplaintInfo(id);
      return data;
    } catch (e) {
      Get.snackbar("خطأ", e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.2),
          colorText: Colors.red[800]);
      return {};
    }
  }
}
