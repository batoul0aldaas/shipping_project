import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/ProfileModel.dart';
import 'api_service.dart';

class ProfileApiService {
  static Future<ProfileModel?> fetchProfile() async {
    try {
      print('📡 [ProfileApiService] Fetching profile...');
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/customer/profile/show'),
        headers: ApiService.headersWithToken(),
      );

      print('➡️ [ProfileApiService] Status: ${response.statusCode}');
      print('📄 [ProfileApiService] Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return ProfileModel.fromJson(data['data']);
        }
        throw Exception(data['message'] ?? 'فشل تحميل الملف الشخصي');
      } else {
        throw Exception('تعذر الاتصال بالخادم (${response.statusCode})');
      }
    } catch (e) {
      print('❌ [ProfileApiService] fetchProfile Error: $e');
      rethrow;
    }
  }

  static Future<ProfileModel?> updateProfile(Map<String, dynamic> body) async {
    try {
      print('📡 [ProfileApiService] Updating profile with body: $body');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiService.baseUrl}/api/customer/profile/update'),
      );

      request.headers.addAll(ApiService.headersWithToken());

      body.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('➡️ [ProfileApiService] Status: ${response.statusCode}');
      print('📄 [ProfileApiService] Body: $responseBody');

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        if (data['status'] == 1) {
          return ProfileModel.fromJson(data['data']);
        }
        throw Exception(data['message'] ?? 'فشل تحديث الملف الشخصي');
      } else {
        throw Exception('تعذر الاتصال بالخادم (${response.statusCode})');
      }
    } catch (e) {
      print('❌ [ProfileApiService] updateProfile Error: $e');
      rethrow;
    }
  }


  static Future<ProfileModel?> uploadImage(File imageFile) async {
    try {
      print('📡 [ProfileApiService] Uploading image: ${imageFile.path}');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiService.baseUrl}/api/customer/profile/upload/image'),
      );
      request.headers.addAll(ApiService.headersWithToken());
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('➡️ [ProfileApiService] Status: ${response.statusCode}');
      print('📄 [ProfileApiService] Body: $responseBody');

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        if (data['status'] == 1) {
          return ProfileModel.fromJson(data['data']);
        }
        throw Exception(data['message'] ?? 'فشل رفع الصورة');
      } else {
        throw Exception('تعذر الاتصال بالخادم (${response.statusCode})');
      }
    } catch (e) {
      print('❌ [ProfileApiService] uploadImage Error: $e');
      rethrow;
    }
  }

  static Future<ProfileModel?> deleteImage() async {
    try {
      print('📡 [ProfileApiService] Deleting profile image...');
      final response = await http.delete(
        Uri.parse('${ApiService.baseUrl}/api/customer/profile/delete/image'),
        headers: ApiService.headersWithToken(),
      );

      print('➡️ [ProfileApiService] Status: ${response.statusCode}');
      print('📄 [ProfileApiService] Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return ProfileModel.fromJson(data['data']);
        }
        throw Exception(data['message'] ?? 'فشل حذف الصورة');
      } else {
        throw Exception('تعذر الاتصال بالخادم (${response.statusCode})');
      }
    } catch (e) {
      print('❌ [ProfileApiService] deleteImage Error: $e');
      rethrow;
    }
  }
}
