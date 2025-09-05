import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../model/contract_model.dart';
import 'api_service.dart';

class ContractService {
  static Future<List<Contract>> fetchContracts(int shipmentId) async {
    final url = Uri.parse("${ApiService.baseUrl}/api/contracts/shipment/$shipmentId");
    try {
      final response = await http.get(url, headers: ApiService.headersWithToken());
      print("Fetch Contracts Status Code: ${response.statusCode}");
      print("Fetch Contracts Response Body: ${response.body}");
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 1) {
        return (data['data'] as List).map((json) => Contract.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching contracts: $e");
      return [];
    }
  }

  static Future<void> downloadContract(Contract contract) async {
    String typeEndpoint = '';
    switch (contract.type) {
      case 'goods_description':
        typeEndpoint = 'goods';
        break;
      case 'service':
        typeEndpoint = 'service';
        break;
      case 'bill_of_lading':
        typeEndpoint = 'bol';
        break;
      default:
        print("Unknown contract type: ${contract.type}");
        return;
    }

    final url = "${ApiService.baseUrl}/api/contracts/$typeEndpoint/${contract.shipmentId}/download";
    print("Downloading from URL: $url");

    try {
      final res = await http.get(Uri.parse(url), headers: ApiService.headersWithToken());
      print("Download Status Code: ${res.statusCode}");
      print("Download Response Headers: ${res.headers}");
      print("Download Response Body length: ${res.bodyBytes.length}");

      if (res.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final fileName = contract.unsignedFileUrl.split('/').last;
        final file = File("${dir.path}/$fileName");
        await file.writeAsBytes(res.bodyBytes);
        await OpenFile.open(file.path);
        print("Contract downloaded: $fileName");
      } else {
        print("Failed to download contract: ${res.statusCode}");
        Get.snackbar("خطأ", "فشل تحميل العقد: ${res.statusCode}");
      }
    } catch (e) {
      print("Error downloading contract: $e");
      Get.snackbar("خطأ", "حدث خطأ أثناء تحميل العقد");
    }
  }


  static Future<void> uploadSignedContract(int shipmentId, File file) async {
    final url = Uri.parse("${ApiService.baseUrl}/api/contracts/shipment/$shipmentId/service/signed");
    print("Uploading file to URL: $url");

    try {
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll(ApiService.headersWithToken())
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Upload Status Code: ${response.statusCode}");
      print("Upload Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'];
        final message = data['message'] ?? 'تم رفع العقد';
        print("Upload Status: $status, Message: $message");
        Get.snackbar("نجاح", message);
      } else {
        print("Failed to upload signed contract");
        Get.snackbar("خطأ", "فشل رفع العقد: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading signed contract: $e");
      Get.snackbar("خطأ", "حدث خطأ أثناء رفع العقد");
    }
  }
}
