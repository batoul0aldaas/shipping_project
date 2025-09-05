import 'dart:convert';
import 'package:ba11/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../model/shipment_tracking_model.dart';

class ShipmentTrackingService {
  static Future<ShipmentTrackingModel> fetchTracking(int shipmentId) async {
    final url = Uri.parse("${ApiService.baseUrl}/api/order-routes/$shipmentId");
    print("📡 طلب بيانات التتبع من: $url");

    final response = await http.get(
      url,
      headers: ApiService.headersWithToken(),
    );

    print("📥 استجابة السيرفر (statusCode): ${response.statusCode}");
    print("📥 الاستجابة (raw body): ${response.body}");

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      print("✅ Body بعد التحويل: $body");

      if (body['status'] == 1) {
        print("📊 تم جلب البيانات بنجاح ✅");
        return ShipmentTrackingModel.fromJson(body);
      } else {
        print("⚠️ خطأ من السيرفر: ${body['message']}");
        throw Exception(body['message'] ?? "فشل في جلب البيانات");
      }
    } else {
      print("❌ خطأ في الاتصال بالسيرفر (كود: ${response.statusCode})");
      throw Exception("خطأ في الاتصال: ${response.statusCode}");
    }
  }
}
