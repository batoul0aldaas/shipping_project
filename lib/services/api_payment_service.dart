import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ApiPaymentService {
  static const String _baseUrl = "${ApiService.baseUrl}/api/payments";
  static const int maxRetries = 10;
  static const int retryDelaySeconds = 10;

  static Future<Map<String, dynamic>> payInvoice(int orderId, String currency) async {
    final url = Uri.parse("$_baseUrl/pay");

    print("=== PAY INVOICE ===");
    print("Order ID: $orderId, Currency: ${currency.toUpperCase()}");
    print("POST URL: $url");

    final response = await http.post(
      url,
      headers: ApiService.headersWithToken(),
      body: {
        "order_id": orderId.toString(),
        "currency": currency.toUpperCase(),
      },
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    final data = jsonDecode(response.body);

    print("Parsed Status: ${data['status']}");
    print("Parsed Message: ${data['message']}");

    if (response.statusCode == 200 && data["status"] == 1) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Payment failed");
    }
  }

  static Future<Map<String, dynamic>> verifyPayment(int orderId, String mfInvoiceId) async {
    int attempt = 0;

    while (attempt < maxRetries) {
      attempt++;
      final url = Uri.parse("$_baseUrl/verify");

      print("=== VERIFY PAYMENT (Attempt $attempt) ===");
      print("Order ID: $orderId, MF Invoice ID: $mfInvoiceId");
      print("POST URL: $url");

      try {
        final response = await http.post(
          url,
          headers: ApiService.headersWithToken(),
          body: {
            "order_id": orderId.toString(),
            "mf_invoice_id": mfInvoiceId,
          },
        );

        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        final data = jsonDecode(response.body);

        print("Parsed Status: ${data['status']}");
        print("Parsed Message: ${data['message']}");

        if (response.statusCode == 200 && data["status"] == 1) {
          final paymentStatus = data['data']?['status'] ?? 'unknown';
          print("Payment Status: $paymentStatus");

          if (paymentStatus == 'pending' && attempt < maxRetries) {
            print("Payment is pending. Retrying after $retryDelaySeconds seconds...");
            await Future.delayed(Duration(seconds: retryDelaySeconds));
            continue;
          } else {
            return data;
          }
        } else {
          throw Exception(data["message"] ?? "Verification failed");
        }
      } catch (e) {
        print("Exception occurred: $e");
        if (attempt < maxRetries) {
          print("Retrying after $retryDelaySeconds seconds...");
          await Future.delayed(Duration(seconds: retryDelaySeconds));
        } else {
          rethrow;
        }
      }
    }

    throw Exception("Payment verification failed after $maxRetries attempts");
  }

  static Future<Map<String, dynamic>> getPaymentInfo(int orderId) async {
    final url = Uri.parse("$_baseUrl/info/$orderId");

    print("=== GET PAYMENT INFO ===");
    print("Order ID: $orderId");
    print("POST URL: $url");

    final response = await http.post(url, headers: ApiService.headersWithToken());

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    final data = jsonDecode(response.body);

    print("Parsed Status: ${data['status']}");
    print("Parsed Message: ${data['message']}");

    if (response.statusCode == 200 && data["status"] == 1) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Failed to fetch payment info");
    }
  }
}
