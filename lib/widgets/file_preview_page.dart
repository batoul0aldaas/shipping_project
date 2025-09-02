import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FilePreviewPage extends StatelessWidget {
  final String url;

  const FilePreviewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("عرض المستند"),
        backgroundColor: const Color(0xFF334EAC),
      ),
      body: SfPdfViewer.network(url),
    );
  }
}
