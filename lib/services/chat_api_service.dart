import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ChatApiService {
  static Future<Map<String, dynamic>> getOrderMessages(int orderId) async {
    final uri = Uri.parse('${ApiService.baseUrl}/api/orders/chat/$orderId/messages');

    try {
      final response = await http.get(
        uri,
        headers: ApiService.headersWithToken(),
      );

      print(" GET CHAT - STATUS: ${response.statusCode}");
      print(" GET CHAT - BODY: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(" فشل في تحميل المحادثة: ${response.statusCode}");
      }
    } catch (e) {
      print(" ERROR in getOrderMessages: $e");
      rethrow;
    }
  }


  static Future<Map<String, dynamic>> sendOrderMessage(int orderId, String message) async {
    final uri = Uri.parse('${ApiService.baseUrl}/api/orders/chat/$orderId/send');

    try {
      final response = await http.post(
        uri,
        headers: ApiService.headersWithToken(),
        body: {'message': message},
      );

      print(" SEND MESSAGE - STATUS: ${response.statusCode}");
      print(" SEND MESSAGE - BODY: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(" فشل إرسال الرسالة: ${response.statusCode}");
      }
    } catch (e) {
      print(" ERROR in sendOrderMessage: $e");
      rethrow;
    }
  }
}
