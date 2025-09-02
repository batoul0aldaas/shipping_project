import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

class UniversalFilePreviewPage extends StatefulWidget {
  final String fileUrl;

  const UniversalFilePreviewPage({super.key, required this.fileUrl});

  @override
  State<UniversalFilePreviewPage> createState() => _UniversalFilePreviewPageState();
}

class _UniversalFilePreviewPageState extends State<UniversalFilePreviewPage> {
  String? localPath;
  bool isLoading = true;
  late String extension;

  @override
  void initState() {
    super.initState();
    extension = widget.fileUrl.split('.').last.toLowerCase();
    downloadFile();
  }

  Future<void> downloadFile() async {
    try {
      final response = await http.get(Uri.parse(widget.fileUrl));
      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final fileName = "downloaded_file.$extension";
        final file = File("${dir.path}/$fileName");
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          localPath = file.path;
          isLoading = false;
        });
        if (extension != 'pdf') {
          await OpenFile.open(file.path);
          Navigator.of(context).pop();
        }
      } else {
        throw Exception("فشل في تحميل الملف");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("عرض الملف"),
        backgroundColor: const Color(0xFF334EAC),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (extension == 'pdf' && localPath != null)
          ? PDFView(
        filePath: localPath!,
        enableSwipe: true,
        autoSpacing: true,
        swipeHorizontal: false,
      )
          : const Center(child: Text("يتم فتح الملف في تطبيق خارجي...")),
    );
  }
}
