import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/model/product/DocResource.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/document/document_pdf_view.dart';
import 'package:agri_manager/src/shared_components/GalleryPhotoView.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sp_util/sp_util.dart';

class DocumentScreen extends StatefulWidget {
  final int entityId;
  final String entityName;
  final String groupName;

  const DocumentScreen(
      {Key? key,
      required this.entityId,
      required this.entityName,
      required this.groupName})
      : super(key: key);

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final TextEditingController _textNameController = TextEditingController();
  final TextEditingController _textFileController = TextEditingController();
  final TextEditingController _textExtController = TextEditingController();

  List<DocResource> listDocument = [];

  List<String> listDocType = ['图片', '文档', '视频'];
  List<int> errorFlag = [0, 0, 0, 0, 0, 0];

  String docType = '图片';

  FilePickerResult? result;

  PageModel pageModel = PageModel();

  LoginInfoToken userInfo = LoginInfoToken();

  Corp? currentCorp;

  Map<String, dynamic> mapUpload = {
    'createdUserId': 1,
    'corpId': 1,
    'docType': '',
    'docExt': '',
    'name': '',
    'groupName': ''
  };

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();

    Map? mapCorpSelect = SpUtil.getObject(Constant.currentCorp);

    debugPrint(json.encode(mapCorpSelect));
    if (null != mapCorpSelect && mapCorpSelect.isNotEmpty) {
      setState(() {
        currentCorp = Corp.fromJson(mapCorpSelect);

        userInfo =
            LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
        mapUpload['corpId'] = currentCorp?.id;
        mapUpload['createdUserId'] = userInfo.userId;
      });
    }
  }

  Future deleteDoc(int index) async {
    try {
      var retData = await DioUtils()
          .request('${HttpApi.doc_delete}${listDocument[index].id}', "DELETE");

      setState(() {
        listDocument.removeAt(index);
      });
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(
          msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
    }
  }

  Future loadData() async {
    var params = {
      'entityId': widget.entityId,
      'entityName': widget.entityName,
      'groupName': widget.groupName,
      'page': pageModel.page,
      'size': pageModel.size
    };

    try {
      var retData = await DioUtils()
          .request(HttpApi.doc_page_query, "GET", queryParameters: params);
      if (retData != null) {
        setState(() {
          listDocument = (retData['content'] as List)
              .map((e) => DocResource.fromJson(e))
              .toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(
          msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
      Container(
        // A fixed-height child.
        height: 80.0,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: elevateButtonStyle,
              onPressed: () {
                loadData();
              },
              child: const Text('查询'),
            ),
            Container(
              width: 20,
            ),
            ElevatedButton(
              style: elevateButtonStyle,
              onPressed: () async {
                await showUploadDialog(context);
              },
              child: const Text('增加'),
            )
          ],
        ),
      ),
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
          DocResource docTemp = listDocument[index];

          if (docTemp.docType == '图片') {
            return Stack(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      openImage(context, listDocument, index);
                    },
                    child: Image.network(
                      '${HttpApi.host_image}${listDocument[index].docUrl}',
                      width: 300,
                      height: 300,
                    )),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      deleteDoc(index);
                    },
                    child: Icon(
                      Icons.close,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Stack(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      openPdfView(docTemp);
                    },
                    child: Text('${docTemp.name}')),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      deleteDoc(index);
                    },
                    child: Icon(
                      Icons.close,
                    ),
                  ),
                ),
              ],
            );
          }

        },
      )
    ])));
  }

  openPdfView(DocResource docResource){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentPdfViewScreen(data: docResource),
      ),
    );
  }

  Future<void> showUploadDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _textFileController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: '文件',
                      hintText: '选择文件',
                      errorText: errorFlag[0] == 1 ? '显示名称不能为空' : null,
                      suffixIcon: IconButton(
                        onPressed: () async {
                          FilePickerResult? resultSelect = await FilePicker
                              .platform
                              .pickFiles(withReadStream: true);

                          if (null != resultSelect) {
                            setState(() {
                              result = resultSelect;
                              PlatformFile pFile = result!.files.single;
                              _textFileController.text = pFile.name;
                              _textExtController.text = pFile.name
                                  .substring(pFile.name.lastIndexOf(".") + 1);
                              _textNameController.text = pFile.name
                                  .substring(0, pFile.name.lastIndexOf("."));
                              mapUpload['name'] = pFile.name;
                              mapUpload['docExt'] = _textExtController.text;
                            });
                          }
                        },
                        icon: const Icon(Icons.search_sharp),
                      ),
                    ),
                  ),
                  Container(
                    height: defaultPadding,
                  ),
                  TextField(
                    controller: _textExtController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: '文件扩展',
                      hintText: '文件扩展',
                      errorText: errorFlag[1] == 1 ? '文件扩展不能为空' : null,
                    ),
                  ),
                  Container(
                    height: defaultPadding,
                  ),
                  Container(
                    height: defaultPadding,
                  ),
                  TextField(
                    controller: _textNameController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: '显示名称',
                      hintText: '显示名称',
                      errorText: errorFlag[2] == 1 ? '显示名称不能为空' : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        mapUpload['name'] = value;
                      });
                    },
                  ),
                  Container(
                    height: defaultPadding,
                  ),
                  DropdownButtonFormField<String>(
                    value: docType,
                    items: listDocType
                        .map((label) => DropdownMenuItem(
                              value: label,
                              child: Text(label.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        docType = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '文件类别',
                      hintText: '选择类别',
                    ),
                  ),
                ],
              ),
              title: const Text('文件上传'),
              actions: <Widget>[
                InkWell(
                  child: const Text('确定'),
                  onTap: () async {
                    setState(() {});
                    await uploadImage();
                    // Do something like updating SharedPreferences or User Settings etc.
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }

  Future uploadImage() async {
    if (result != null) {
      //log(result.files.first.name);
      //File file = File(result.files.first.name);
      debugPrint('start to load ');
      try {
        //print('start to upload');r
        PlatformFile pFile = result!.files.single;
        mapUpload['corpId'] = currentCorp?.id;
        mapUpload['entityId'] = widget.entityId;
        mapUpload['entityName'] = widget.entityName;
        mapUpload['docType'] = docType;
        mapUpload['groupName'] = widget.groupName;
        var formData = FormData.fromMap({
          'docResource': jsonEncode(mapUpload),
          'file': MultipartFile(
              pFile.readStream as Stream<List<int>>, pFile.size,
              filename: pFile.name)
        });

        var retData = await DioUtils()
            .requestUpload(HttpApi.doc_resource_upload, data: formData);
        if (null != retData) {
          //debugPrint(retData);
          Fluttertoast.showToast(
              msg: '上传成功',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1);

          //listDocument.add(DocResource.fromJson(retData));
        } else {
          Fluttertoast.showToast(
              msg: '上传失败',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1);
        }
        // print(json.encode(ret));
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());

        Fluttertoast.showToast(
            msg: customAppException.getMessage(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
      }
    } else {
      // User canceled the picker
    }
  }

  void openImage(
      BuildContext context, List<DocResource> listDocument, final int index) {
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
