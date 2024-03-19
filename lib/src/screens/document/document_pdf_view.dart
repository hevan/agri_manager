
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/product/DocResource.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:agri_manager/src/net/http_api.dart';

class DocumentPdfViewScreen extends StatefulWidget {
  final DocResource data;
  const DocumentPdfViewScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<DocumentPdfViewScreen> createState() => _DocumentPdfViewScreenState();
}

class _DocumentPdfViewScreenState extends State<DocumentPdfViewScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: SfPdfViewer.network(
                '${HttpApi.host_image}${widget.data.docUrl}',
                password: 'syncfusion')));
  }

}
