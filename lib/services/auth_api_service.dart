import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../model/UserModel.dart';

class AuthApiService {
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse("${ApiService.baseUrl}/api/auth/login");

    try {
      final response = await http.post(
        uri,
        headers: ApiService.headersWithoutToken(),
        body: {'email': email, 'password': password},
      );

      print(" LOGIN STATUS: ${response.statusCode}");
      print(" LOGIN BODY: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("LOGIN ERROR: $e");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, String> body, {String? filePath}) async {
    final uri = Uri.parse("${ApiService.baseUrl}/api/auth/register");

    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(ApiService.headersWithoutToken());
      request.fields.addAll(body);

      if (filePath != null && filePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('commercial_register', filePath));
      }

      final response = await request.send();
      final bodyStr = await response.stream.bytesToString();

      print(" REGISTER STATUS: ${response.statusCode}");
      print(" REGISTER BODY: $bodyStr");

      return jsonDecode(bodyStr);
    } catch (e) {
      print("REGISTER ERROR: $e");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> verifyCode({required UserModel user, required String code}) async {
    final uri = Uri.parse("${ApiService.baseUrl}/api/auth/verifyAuthCode/${user.id}");

    try {
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(ApiService.headersWithoutToken());
      request.fields['code'] = code;

      final res = await request.send();
      final responseBody = await res.stream.bytesToString();

      print(" VERIFY CODE STATUS: ${res.statusCode}");
      print(" VERIFY CODE BODY: $responseBody");

      return jsonDecode(responseBody);
    } catch (e) {
      print(" VERIFY CODE ERROR: $e");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> verifyPasswordCode({required UserModel user, required String code}) async {
    final uri = Uri.parse("${ApiService.baseUrl}/api/auth/verifyPasswordCode/${user.id}");

    try {
      final response = await http.post(
        uri,
        headers: ApiService.headersWithoutToken(),
        body: {'code': code},
      );

      print("VERIFY RESET CODE STATUS: ${response.statusCode}");
      print(" VERIFY RESET CODE BODY: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print(" VERIFY RESET CODE ERROR: $e");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> forgetPassword(String email) async {
    final uri = Uri.parse("${ApiService.baseUrl}/api/auth/forgetPassword");

    try {
      final response = await http.post(
        uri,
        headers: ApiService.headersWithoutToken(),
        body: {'email': email},
      );

      print(" FORGET PASSWORD STATUS: ${response.statusCode}");
      print("FORGET PASSWORD BODY: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print(" FORGET PASSWORD ERROR: $e");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> resetPassword({
    required int? userId,
    required String password,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse("${ApiService.baseUrl}/api/auth/resetPassword/$userId");

    try {
      final res = await http.post(
        uri,
        headers: ApiService.headersWithoutToken(),
        body: {
          'password': password,
          'password_confirmation': confirmPassword,
        },
      );

      print(" RESET PASSWORD STATUS: ${res.statusCode}");
      print(" RESET PASSWORD BODY: ${res.body}");

      return jsonDecode(res.body);
    } catch (e) {
      print(" RESET PASSWORD ERROR: $e");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> refreshCode(int? userId) async {
    final uri = Uri.parse("${ApiService.baseUrl}/api/auth/refreshCode/$userId");

    try {
      final res = await http.get(uri, headers: ApiService.headersWithToken());

      print(" REFRESH CODE STATUS: ${res.statusCode}");
      print(" REFRESH CODE BODY: ${res.body}");

      return jsonDecode(res.body);
    } catch (e) {
      print(" REFRESH CODE ERROR: $e");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    final uri = Uri.parse("${ApiService.baseUrl}/api/auth/logout");

    final res = await http.get(uri, headers: ApiService.headersWithToken());

    print("LOGOUT STATUS: ${res.statusCode}");
    print("LOGOUT BODY: ${res.body}");

    return jsonDecode(res.body);
  }

}
