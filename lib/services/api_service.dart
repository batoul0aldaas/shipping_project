import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiService {
  static const String baseUrl = "https://pink-scorpion-423797.hostingersite.com";
  static String? token;

  static Map<String, String> _baseHeaders({bool withAuth = false}) {
    final headers = {
      'Accept': 'application/json',
      'Accept-Language': Get.locale?.languageCode ?? 'ar',
    };

    if (withAuth) {
      final box = GetStorage();
      token ??= box.read('token');

      if (token != null && token!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        print(" AUTH TOKEN ATTACHED: $token");
      } else {
        print(" No token found. User might be unauthenticated.");
      }
    }

    return headers;
  }

  static Map<String, String> headersWithToken() {
    return _baseHeaders(withAuth: true);
  }

  static Map<String, String> headersWithoutToken() {
    return _baseHeaders();
  }
}
