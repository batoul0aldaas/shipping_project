
import 'package:ba11/services/api_service.dart';
import 'package:ba11/view/home_page.dart';
import 'package:ba11/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app_translations.dart';
import 'controller/cart_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put(CartController());

  final box = GetStorage();
  final token = box.read<String>('token');

  ApiService.token = token;
  runApp(MyApp(
    initialPage: token != null ? const HomePage() : const LoginView(),
  ));
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
