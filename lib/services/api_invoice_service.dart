import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../model/invoice_model.dart';
import 'api_service.dart';

class ApiInvoiceService {
  static Future<InvoiceModel?> fetchInvoice(int shipmentId) async {
    final url = Uri.parse('${ApiService.baseUrl}/api/invoice/show/$shipmentId');
    final headers = ApiService.headersWithToken();

    try {
      final response = await http.get(url, headers: headers);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['status'] == 1) {
          final invoiceData = body['data']['invoice'];
          return InvoiceModel.fromJson(invoiceData);
        } else {
          Get.snackbar("خطأ", body['message'] ?? 'حدث خطأ في تحميل الفاتورة');
          return null;
        }
      } else {
        Get.snackbar("خطأ", "فشل الاتصال بالخادم: حالة ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception in fetchInvoice: $e");
      Get.snackbar("خطأ", "فشل في جلب الفاتورة: $e");
      return null;
    }
  }

  static Future<void> downloadInvoiceFile(int invoiceId) async {
    final url = Uri.parse('${ApiService.baseUrl}/api/invoice/$invoiceId/download');
    final headers = ApiService.headersWithToken();

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/invoice_$invoiceId.pdf');
        await file.writeAsBytes(bytes);

        Get.snackbar("نجاح", "تم تحميل الفاتورة بنجاح\nالمسار: ${file.path}");


        await OpenFile.open(file.path);
      } else {
        Get.snackbar("خطأ", "فشل تحميل الملف: حالة ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in downloadInvoiceFile: $e");
      Get.snackbar("خطأ", "فشل في تحميل الملف: $e");
    }
  }
}
