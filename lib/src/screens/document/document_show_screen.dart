import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/model/product/DocResource.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/shared_components/GalleryPhotoView.dart';
import 'package:agri_manager/src/utils/constants.dart';

class DocumentShowScreen extends StatefulWidget {
  final int entityId;
  final String entityName;
  final String groupName;
  const DocumentShowScreen({Key? key, required this.entityId, required this.entityName,  required this.groupName}) : super(key: key);

  @override
  State<DocumentShowScreen> createState() => _DocumentShowScreenState();
}

class _DocumentShowScreenState extends State<DocumentShowScreen> {


  List<DocResource> listDocument = [];


  PageModel pageModel = PageModel();

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  Future loadData() async {
    var params = {'entityId': widget.entityId, 'entityName': widget.entityName, 'groupName': widget.groupName, 'page': pageModel.page, 'size': pageModel.size};

    try {
      var retData = await DioUtils()
          .request(HttpApi.doc_page_query, "GET", queryParameters: params);
      if (retData != null) {
        setState(() {
          listDocument = (retData['content'] as List).map((e) => DocResource.fromJson(e)).toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
    }
  }

  toManage(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(
              child:  Column(children: <Widget>[
                       const SizedBox(height: kSpacing,),
                       GridView.builder(
                          shrinkWrap: true,
                          itemCount: listDocument.length,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                openImage(context,listDocument,index);
                              },
                              child:
                                Image.network('${HttpApi.host_image}${listDocument[index].docUrl}',
                                  width: 300,
                                  height: 300,
                                ),
                            );
                          },
                        )
                  ]))
        );
  }

  void openImage(BuildContext context, List<DocResource> listDocument, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: listDocument,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
