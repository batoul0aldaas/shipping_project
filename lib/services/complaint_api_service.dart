import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ComplaintApiService {
  static String get _baseUrl => "${ApiService.baseUrl}/api/customer/complaints";
  static Future<Map<String, dynamic>> addComplaint({
    required String subject,
    required String message,
  }) async {
    final url = Uri.parse("$_baseUrl/store");

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(ApiService.headersWithToken());
      request.fields['subject'] = subject;
      request.fields['message'] = message;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['status'] == 1) {
        return data;
      } else {
        throw Exception(data['message'] ?? "فشل إرسال الشكوى");
      }
    } catch (e) {
      throw Exception("حدث خطأ أثناء إرسال الشكوى: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> getComplaints() async {
    final url = Uri.parse("$_baseUrl/show");

    try {
      final response = await http.get(
        url,
        headers: ApiService.headersWithToken(),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 1) {
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception(data['message'] ?? "فشل جلب الشكاوى");
      }
    } catch (e) {
      throw Exception("حدث خطأ أثناء جلب الشكاوى: $e");
    }
  }

  static Future<Map<String, dynamic>> getComplaintInfo(int id) async {
    final url = Uri.parse("$_baseUrl/$id");

    try {
      final response = await http.get(
        url,
        headers: ApiService.headersWithToken(),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 1) {
        return Map<String, dynamic>.from(data['data']);
      } else {
        throw Exception(data['message'] ?? "فشل جلب تفاصيل الشكوى");
      }
    } catch (e) {
      throw Exception("حدث خطأ أثناء جلب تفاصيل الشكوى: $e");
    }
  }
}
