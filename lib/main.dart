import 'package:ba11/services/api_service.dart';
import 'package:ba11/view/home_page.dart';
import 'package:ba11/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'app_translations.dart';
import 'controller/cart_controller.dart';

// 🟢 هذا بشتغل لما توصلك رسالة وانت خارج التطبيق
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 رسالة بالخلفية: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🟢 تهيئة Firebase
  await Firebase.initializeApp();

  // 🟢 تهيئة التخزين
  await GetStorage.init();

  // 🟢 تسجيل handler للخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 🟢 إضافة CartController
  Get.put(CartController());

  // 🟢 قراءة التوكن المحفوظ (تبع المستخدم)
  final box = GetStorage();
  final token = box.read<String>('token');
  ApiService.token = token;

  // 🟢 بدء التطبيق
  runApp(MyApp(
    initialPage: token != null ? const HomePage() : const LoginView(),
  ));

  // 🟢 تهيئة FCM بعد تشغيل التطبيق
  _initFCM();
}

Future<void> _initFCM() async {
  // طلب إذن (مفيد خصوصاً لو أضفت iOS)
  await FirebaseMessaging.instance.requestPermission();

  // جلب الـ Token
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  print("🔑 FCM Token: $fcmToken");

  // إرسال التوكن للباك اند
  if (fcmToken != null) {
    await sendTokenToBackend(fcmToken);
  }

  // لو التطبيق مفتوح ووصله إشعار
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📲 رسالة داخل التطبيق: ${message.notification?.title}");
    print("📄 البودي: ${message.notification?.body}");
  });
}

Future<void> sendTokenToBackend(String token) async {
  try {
    final url = Uri.parse("http://127.0.0.1:8000/api/save-fcm-token"); // ✨ عدل حسب API تبعك
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"fcm_token": token}),
    );

    if (response.statusCode == 200) {
      print("✅ تم حفظ التوكن بالباك اند");
    } else {
      print("❌ خطأ عند إرسال التوكن: ${response.body}");
    }
  } catch (e) {
    print("⚠️ Exception أثناء إرسال التوكن: $e");
  }
}

class MyApp extends StatelessWidget {
  final Widget initialPage;
  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Import Export App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9FCFF),
        primaryColor: const Color(0xFF334EAC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF081F5C),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFE7F1FF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDDE3FF)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF334EAC),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF081F5C), fontSize: 18),
          bodyMedium: TextStyle(color: Color(0xFF081F5C), fontSize: 16),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      translations: AppTranslations(),
      locale: const Locale('ar'),
      fallbackLocale: const Locale('en'),
      home: initialPage,
    );
  }
}
