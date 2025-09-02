import 'dart:convert';
import 'package:ba11/services/api_service.dart';
import 'package:http/http.dart' as http;

class ApiRateService {
  static Future<bool> rateOrder(int orderId, int employeeRate, int serviceRate) async {
    try {
      final url = Uri.parse("${ApiService.baseUrl}/api/orders/$orderId/rate");

      final response = await http.post(
        url,
        headers: {
          ...ApiService.headersWithToken(),
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "employee_rate": employeeRate,
          "service_rate": serviceRate,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 1;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
