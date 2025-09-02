import 'dart:convert';
import 'package:ba11/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../model/shipment_tracking_model.dart';

class ShipmentTrackingService {
  static Future<ShipmentTrackingModel> fetchTracking(int shipmentId) async {
    final url = Uri.parse("${ApiService.baseUrl}/api/order-routes/$shipmentId");
    final response = await http.get(url,headers:ApiService.headersWithToken());

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['status'] == 1) {
        return ShipmentTrackingModel.fromJson(body);
      } else {
        throw Exception(body['message'] ?? "فشل في جلب البيانات");
      }
    } else {
      throw Exception("خطأ في الاتصال: ${response.statusCode}");
    }
  }
}
