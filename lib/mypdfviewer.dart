import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyPdfViewer extends StatelessWidget {
  const MyPdfViewer({super.key, this.title, this.url});
  final title;
  final url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(
        child: SfPdfViewer.network(
          url,
        ),
      ),
    );
  }
}
