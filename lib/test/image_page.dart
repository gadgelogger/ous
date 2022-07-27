import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'firebase_file.dart';
import 'firebase_api.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ImagePage extends StatelessWidget {
  final FirebaseFile file;

  const ImagePage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpeg', '.jpg', '.png'].any(file.name.contains);
    final isPdf = ['.pdf'].any(file.name.contains);

    return Scaffold(
      appBar: AppBar(
        title: Text(file.name),
        centerTitle: true,
      ),
      body: isPdf
          ? SfPdfViewer.network(file.url)
          : Center(
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 5,
                child: Container(
                  child: Image.network(
                    file.url,
                    height: double.infinity,
                  )
                ),
              )),
    );
  }
}
