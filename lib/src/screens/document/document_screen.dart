import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:znny_manager/src/model/product/DocResource.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sp_util/sp_util.dart';

class DocumentScreen extends StatefulWidget {
  final int entityId;
  final String entityName;
  final String name;
  const DocumentScreen({Key? key, required this.entityId, required this.entityName, required this.name}) : super(key: key);

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {

  final TextEditingController _textNameController = TextEditingController();
  final TextEditingController _textFileController = TextEditingController();
  final TextEditingController _textExtController = TextEditingController();
  final TextEditingController _textCategoryController = TextEditingController();

  List<DocResource> listDocument = [];

  List<String> listDocType = ['图片','文档','视频'];
  List<int> errorFlag = [0,0,0,0,0,0];

  String docType = '图片';

  FilePickerResult? result;

  int? userId;
  Map<String, dynamic> mapUpload = {
    'userId': 1,
    'corpId': 1,
    'docType': '',
    'docExt': '',
    'name': '',
    'category': ''};


  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
    _textNameController.text = widget.name;
    setState(() {
      userId = SpUtil.getInt(Constant.userId);
    });
  }

  Future loadData() async {
    var params = {'entityId': widget.entityId, 'entityName': widget.entityName};

    try {
      var retData = await DioUtils()
          .request(HttpApi.doc_findAll, "GET", queryParameters: params);
      if (retData != null) {
        setState(() {
          listDocument = (retData as List).map((e) => DocResource.fromJson(e)).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
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
                    const Divider(
                      height: 1,
                    ),
                    Expanded(
                        // A flexible child that will grow to fit the viewport but
                        // still be at least as big as necessary to fit its contents.
                        child: Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      height: 300,
                      child: DataTable2(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 600,
                          smRatio: 0.75,
                          lmRatio: 1.5,
                          columns: const [
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('id'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('名称'),
                            ),
                            DataColumn2(
                              label: Text('url'),
                            ),
                            DataColumn2(
                              size: ColumnSize.L,
                              label: Text('操作'),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                              listDocument.length,
                              (index) => DataRow(cells: [
                                    DataCell(Text('${listDocument[index].id}')),
                                    DataCell(Text('${listDocument[index].name}')),
                                    DataCell(Text('${listDocument[index].docUrl}')),
                                    DataCell(
                                        Row(
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: ElevatedButton(
                                              style: elevateButtonStyle,
                                              onPressed: () {
                                              },
                                              child: Container(width: 160, child: Text('编辑')),
                                            )),
                                        Container(width: 10,),
                                        Expanded(
                                            flex: 2,
                                            child: ElevatedButton(
                                              style: elevateButtonStyle,
                                              onPressed: () {},
                                              child: Container(width: 160, child: Text('删除')),
                                            )),
                                        Container(width: 10,),
                                        Expanded(
                                            flex: 2,
                                            child: ElevatedButton(
                                              style: elevateButtonStyle,
                                              onPressed: () {

                                              },
                                              child: Container(width: 160, child: Text('查看')),
                                            )),
                                      ],
                                    ))
                                  ]))),
                    ))
                  ]))));
        }));
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
                              FilePickerResult? resultSelect = await FilePicker.platform.pickFiles(withReadStream: true);

                              if(null != resultSelect) {
                                setState(() {
                                  result = resultSelect;
                                    PlatformFile pFile = result!.files.single;
                                  _textFileController.text = pFile.name;
                                  _textExtController.text = pFile.name.substring(pFile.name.lastIndexOf(".") + 1);
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
                      TextField(
                        controller: _textCategoryController,
                        decoration: const InputDecoration(
                          border:  OutlineInputBorder(),
                          labelText: '分类',
                          hintText: '分类'
                        ),
                        onChanged: (value) {
                          setState(() {
                            mapUpload['category'] = value;
                          });
                        },
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
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            docType = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          border:  OutlineInputBorder(),
                          labelText: '文件类别',
                          hintText: '选择类别',
                        ),
                      ),
                    ],
                  ),
              title: const Text('文件上传'),
              actions: <Widget>[
                InkWell(
                  child: const Text('确定   '),
                  onTap: () async {
                    setState((){});
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
      log('start to load ');
      try {
        //print('start to upload');r
        PlatformFile pFile = result!.files.single;
        mapUpload['userId'] = userId;
        mapUpload['corpId'] = HttpApi.corpId;
        mapUpload['docType'] = docType;
        mapUpload['entityId'] = widget.entityId;
        mapUpload['entityName'] = widget.entityName;
        var formData = FormData.fromMap({
          'docResource': jsonEncode(mapUpload),
          'file':  MultipartFile( pFile.readStream as Stream<List<int>>, pFile.size, filename: pFile.name)
        });

        var ret = await DioUtils().requestUpload(
            HttpApi.doc_resource_upload,
            data: formData
        );
        // print(json.encode(ret));
        Fluttertoast.showToast(msg: '上传成功',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);

        loadData();
      } on DioError catch (error) {
        CustomAppException customAppException =
        CustomAppException.create(error);
        debugPrint(customAppException.getMessage());

        Fluttertoast.showToast(msg: customAppException.getMessage(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
      }
    } else {
      // User canceled the picker
    }
  }
}
