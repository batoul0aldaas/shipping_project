import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/CategoryModel.dart';
import '../model/OrderModel.dart';
import '../model/QuestionModel.dart';
import '../model/ShipmentModel.dart';
import 'api_service.dart';

class ApiShipmentService {
  static Future<List<CategoryModel>> getCategories() async {
    final uri = Uri.parse("${ApiService.baseUrl}/api/categories/");
    print(" [getCategories] بدء طلب الكاتيجوري من: $uri");

    try {
      final response = await http.get(
          uri, headers: ApiService.headersWithToken());
      print(" [getCategories] رمز الاستجابة: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print("[getCategories] البيانات المُستلمة: $decoded");

        if (decoded['status'] == 1) {
          final categoriesJson = decoded['data']['categories'] as List;
          print(" [getCategories] عدد الكاتيجوري المستلمة: ${categoriesJson
              .length}");

          final categories = categoriesJson.map((json) {
            try {
              return CategoryModel.fromJson(json);
            } catch (e) {
              print(" [getCategories] خطأ عند تحويل عنصر: $e");
              return null;
            }
          }).whereType<CategoryModel>().toList();

          print(
              " [getCategories] تم تحويل ${categories.length} كاتيجوري بنجاح");
          return categories;
        } else {
          print(
              " [getCategories] الحالة ليست 1، الرسالة: ${decoded['message']}");
        }
      } else {
        print(" [getCategories] رمز استجابة غير متوقع: ${response.statusCode}");
      }
    } catch (e) {
      print(" [getCategories] استثناء أثناء الطلب: $e");
    }

    return [];
  }

  static Future<Map<String, dynamic>> postShipmentWithSupplier({
    required ShipmentModel shipment,
    PlatformFile? platformFile,
  }) async {
    final uri = Uri.parse("${ApiService.baseUrl}/api/shipment");
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(ApiService.headersWithToken());

    print(" إرسال طلب POST إلى: $uri");
    print(" Headers: ${request.headers}");

    final fields = shipment.toJson();
    fields.forEach((key, value) {
      if (value != null) {
        if (value is bool) {
          request.fields[key] = value ? '1' : '0';
        } else {
          request.fields[key] = value.toString().trim();
        }
      }
    });

    print("البيانات المُرسلة (Fields):");
    fields.forEach((key, value) => print("   $key: $value"));
    if (platformFile != null && platformFile.path != null) {
      print("📎 إرفاق ملف: ${platformFile.name} (${platformFile.path})");
      request.files.add(await http.MultipartFile.fromPath(
        'sup_invoice',
        platformFile.path!,
        filename: platformFile.name,
      ));
    } else {
      print("️ لم يتم اختيار أي ملف لإرفاقه");
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print(" Status Code: ${response.statusCode}");
      print(" Response Body: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 422) {
        return jsonDecode(responseBody);
      } else {
        throw Exception("فشل الاتصال بالسيرفر: ${response.statusCode}");
      }
    } catch (e) {
      print(" حدث خطأ أثناء إرسال الشحنة: $e");
      rethrow;
    }
  }


  static Future<List<QuestionModel>> getQuestionsByCategory(
      int categoryId) async {
    final uri = Uri.parse('${ApiService.baseUrl}/api/questions/$categoryId');
    final response = await http.get(
        uri, headers: ApiService.headersWithToken());
    print(" Endpoint: $uri");
    print(" Status Code: ${response.statusCode}");
    print("Body: ${response.body}");
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == 1) {
        final questionsJson = decoded['data']['question'] as List;
        return questionsJson.map((e) => QuestionModel.fromJson(e)).toList();
      }
    }
    return [];
  }


  static Future<void> postShipmentAnswers({
    required int shipmentId,
    required List<Map<String, dynamic>> answers,
  }) async {
    final uri = Uri.parse('${ApiService.baseUrl}/api/shipment-answers');
    final request = http.MultipartRequest('POST', uri);

    final headers = ApiService.headersWithToken();
    request.headers.addAll(headers);


    request.fields['shipment_id'] = shipmentId.toString();


    for (int i = 0; i < answers.length; i++) {
      request.fields['answers[$i][shipment_question_id]'] =
          answers[i]['question_id'].toString();
      request.fields['answers[$i][answer]'] = answers[i]['answer'].toString();
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print(" [postShipmentAnswers] Sent Fields: ${request.fields}");
      print(" Status Code: ${response.statusCode}");
      print(" Body: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (decoded['status'] == 1) {
        Get.snackbar("نجاح", "تم إرسال الإجابات بنجاح");
      } else {
        Get.snackbar("فشل", decoded['message'].toString());
      }
    } catch (e) {
      print(" [postShipmentAnswers] Error: $e");
      Get.snackbar("خطأ", "فشل الاتصال بالخادم");
    }
  }

  /*static Future<List<Shipment>> fetchCartShipments() async {
    final uri = Uri.parse('${ApiService.baseUrl}/api/carts/cartshipments');
    final response = await http.get(
        uri, headers: ApiService.headersWithToken());

    print("استجابة الكارت: ${response.body}");

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final shipmentsList = jsonBody['data']?['shipments'] as List?;

      if (shipmentsList == null) return [];

      return shipmentsList.map((e) => Shipment.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load shipments");
    }
  }*/


 /* Future<List<OrderModel>> getOrders({required bool confirmed}) async {
    final endpoint = confirmed
        ? '/api/show/order/confirmed-customer'
        : '/api/show/order/unconfirmed-customer';

    final url = '${ApiService.baseUrl}$endpoint';

    try {
      final response = await http.get(
          Uri.parse(url), headers: ApiService.headersWithToken());
      print(' Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body['status'] == 1) {
          final List ordersJson = body['data']['order'];
           print(' Orders JSON: $ordersJson');

          final orders = ordersJson.map((json) => OrderModel.fromJson(json))
              .toList();
          print(' Parsed ${orders.length} orders');
          return orders;
        } else {
          print(' API returned status 0: ${body['message']}');
          throw Exception('API returned status 0: ${body['message']}');
        }
      } else {
        print('Failed to load orders. Status code: ${response.statusCode}');
        throw Exception('Failed to load orders (${response.statusCode})');
      }
    } catch (e) {
      print(' Exception occurred while fetching orders: $e');
      rethrow;
    }
  }*/
  Future<List<OrderModel>> getOrdersByType({required String type}) async {
    String endpoint;
    if (type == "confirmed") {
      endpoint = '/api/show/order/confirmed-customer';
    } else if (type == "unconfirmed") {
      endpoint = '/api/show/order/unconfirmed-customer';
    } else {
      endpoint = '/api/show/order/delivered';
    }

    final url = '${ApiService.baseUrl}$endpoint';

    try {
      final response = await http.get(Uri.parse(url), headers: ApiService.headersWithToken());
      print(' Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['status'] == 1) {

          final List ordersJson = body['data']['order'];
          print(' Orders JSON: $ordersJson');
          final orders = ordersJson.map((json) => OrderModel.fromJson(json))
              .toList();
          print(' Parsed ${orders.length} orders');
          return orders;

        }
      }
    } catch (e) {
      print("❌ Error loading orders: $e");
    }
    return [];
  }


  static Future<void> sendCart() async {
    final uri = Uri.parse('${ApiService.baseUrl}/api/carts/send');

    try {
      final response = await http.get(uri, headers: ApiService.headersWithToken());
      print(' Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(' [sendCart] API Response: $data');
      } else {
        print('Failed to send cart. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in sendCartAndPrintResponse: $e');
    }
  }

  static Future<List<ShipmentModel>> getShipmentsByOrderId(int orderId) async {
    final uri = Uri.parse('${ApiService.baseUrl}/api/order/shipments/$orderId');

    try {
      final response = await http.get(uri, headers: ApiService.headersWithToken());

      print(' Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[getShipmentsByOrderId] Response: $data');

        final shipments = data['data']['shipments'] as List;
        return shipments.map((e) => ShipmentModel.fromJson(e)).toList();
      } else {
        print(' Failed to fetch shipments. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print(' Exception in getShipmentsByOrderId: $e');
      return [];
    }
  }
  static Future<ShipmentModel?> getFullShipmentById(int id) async {
    final uri = Uri.parse('${ApiService.baseUrl}/api/shipment-full/$id');

    print(" Sending GET request to: $uri");

    try {
      final response = await http.get(uri, headers: ApiService.headersWithToken());

      print(" Status Code: ${response.statusCode}");
      print(" Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        print(" Shipment data received: ${data['shipment']}");
        print(" Supplier data received: ${data['supplier']}");
        print(" Documents: ${data['documents']}");
        print(" Answers: ${data['answers']}");

        return ShipmentModel.fromJson(
          data['shipment'],
          supplier: data['supplier'],
          documentsJson: data['documents'],
          answersJson: data['answers'],
        );
      } else {
        print(" getFullShipmentById failed: ${response.statusCode}");
      }
    } catch (e) {
      print(" Exception in getFullShipmentById: $e");
    }

    return null;
  }


  static Future<bool> postEditShipment({
    required int shipmentId,
    required ShipmentModel shipment,
    PlatformFile? file,
  }) async {
    final uri = Uri.parse('${ApiService.baseUrl}/api/shipment-full/$shipmentId');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(ApiService.headersWithToken());

    final fields = shipment.toJson2();
    print(" Preparing fields for POST:");
    fields.forEach((key, value) {
      if (value != null) {
        print("   $key: $value");
        request.fields[key] = value.toString();
      }
    });

    if (file != null && file.path != null) {
      print(" Adding file to request: ${file.name}");
      request.files.add(await http.MultipartFile.fromPath(
        'sup_invoice',
        file.path!,
        filename: file.name,
      ));
    }

    try {
      final response = await request.send();
      final body = await response.stream.bytesToString();
      final decoded = jsonDecode(body);

      print(" Status Code: ${response.statusCode}");
      print(" Response Body: $body");

      if (response.statusCode == 200 && decoded['status'] == 1) {
        print(" Shipment updated successfully.");
        return true;
      } else {
        print(" Error editing shipment: $body");
        return false;
      }
    } catch (e) {
      print(" Exception in postEditShipment: $e");
      return false;
    }
  }

  static Future<bool> confirmShipment(int shipmentId) async {
    final uri = Uri.parse('${ApiService.baseUrl}/api/shipment/confirm/$shipmentId');
    try {
      final response = await http.get(uri, headers: ApiService.headersWithToken());
      print(" [confirmShipment] Status Code: ${response.statusCode}");

      print(" Body: ${response.body}");

      final data = jsonDecode(response.body);
      print(" data: ${jsonDecode(response.body)}");

      return data['status'] == 1;
    } catch (e) {
      print(" Exception in confirmShipment: $e");
      return false;
    }
  }

  static Future<bool> deleteShipment(int shipmentId) async {
    final uri = Uri.parse('${ApiService.baseUrl}/api/shipment-full/$shipmentId');
    try {
      final response = await http.delete(uri, headers: ApiService.headersWithToken());
      print(" [deleteShipment] Status Code: ${response.statusCode}");
      print(" Body: ${response.body}");

      final data = jsonDecode(response.body);
      return data['status'] == 1;
    } catch (e) {
      print(" Exception in deleteShipment: $e");
      return false;
    }}

 /* static Future<String> confirmOrder(int orderId) async {
    final uri = Uri.parse('${ApiService.baseUrl}/api/order/confirm/$orderId');

    try {
      final response = await http.get(uri, headers: ApiService.headersWithToken());
      print(" [confirmOrder] Status Code: ${response.statusCode}");
      print(" Body: ${response.body}");

      final decoded = jsonDecode(response.body);
      return decoded['message'] ?? 'Unknown error';
    } catch (e) {
      print(" Error in confirmOrder: $e");
      return 'فشل الاتصال بالخادم';
    }
  }*/
  }

