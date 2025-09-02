import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../model/invoice_order_model.dart';
import 'api_service.dart';

class ApiInvoiceService {
  static const String baseUrl = "${ApiService.baseUrl}/api";

  static Future<InvoiceOrderModel?> fetchOrderInvoice(int orderId) async {
    final url = Uri.parse("$baseUrl/invoice/order/show/$orderId");

    final response = await http.get(
      url,
      headers: ApiService.headersWithToken(),
    );

    if (response.statusCode == 200) {

      final data = json.decode(response.body);
      return InvoiceOrderModel.fromJson(data['data']['invoice']);
    } else {
      print("فشل جلب الفاتورة: ${response.statusCode}");
      return null;
    }
  }

  static Future<void> downloadOrderInvoice(int orderId) async {
    final url = Uri.parse("$baseUrl/invoice/order/$orderId/download");

    final headers = ApiService.headersWithToken()
      ..remove('Accept')
      ..['Accept'] = 'application/pdf';

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/order_invoice_$orderId.pdf";
      final file = File(filePath);

      await file.writeAsBytes(response.bodyBytes);
      await OpenFile.open(filePath);
    } else {
      throw Exception("فشل تحميل الفاتورة: ${response.statusCode}");
    }
  }
}
