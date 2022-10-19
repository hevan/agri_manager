import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:sp_util/sp_util.dart';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/base/Park.dart';
import 'package:znny_manager/src/model/product/Category.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class ParkEditScreen extends StatefulWidget {
  final int? id;

  const ParkEditScreen({Key? key, this.id}) : super(key: key);

  @override
  State<ParkEditScreen> createState() => _ParkEditScreenState();
}

class _ParkEditScreenState extends State<ParkEditScreen> {
  final _textName = TextEditingController();
  final _textArea = TextEditingController();
  final _textAreaUse = TextEditingController();
  final _textDescription = TextEditingController();

  List<int> errorFlag = [0,0,0,0,0,0];

  int _validateCode = 0;
  String _errorMessage = "";
  List<Category> listCategory = [];
  Category? selectCategory;

  Park _park = Park(corpId: HttpApi.corpId);
  int? userId;

  @override
  void dispose() {
    _textName.dispose();
    _textArea.dispose();
    _textAreaUse.dispose();
    _textDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {
      userId = SpUtil.getInt(Constant.userId);
    });
  }

  Future loadData() async {

    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.park_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _park = Park.fromJson(retData);

            _textName.text = _park.name != null ? _park.name! : '';
            _textAreaUse.text = _park.areaUse != null ? _park.areaUse!.toString() : '';
            _textDescription.text = _park.description != null ? _park.description! : '';
            _textArea.text = _park.area != null ? _park.area!.toString() : '';
          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException = CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }


  }

  Future save() async {

    bool checkError = false;
    log(_textArea.text);
    if(_textArea.text == ''){
      errorFlag[0] = 1;
      checkError=true;
    }

    if(_textName.text == ''){
      errorFlag[1] = 1;
      checkError=true;
    }

    if(_textAreaUse.text == ''){
      errorFlag[2] = 1;
      checkError=true;
    }

    if(_textDescription.text == ''){
      errorFlag[4] = 1;
      checkError=true;
    }

    if(checkError){
      return;
    }

    _park.name = _textName.text;
    _park.areaUse = double.parse(_textAreaUse.text);
    _park.area = double.parse(_textArea.text);
    _park.description = _textDescription.text;

    try {
      var retData = await DioUtils().request(HttpApi.park_add, "POST",
          data: json.encode(_park), isJson: true);
      Navigator.of(context).pop();
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('基地编辑'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                TextField(
                  controller: _textName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '名称',
                    hintText: '输入名称',
                    errorText: errorFlag[0] == 1  ? '名称不能为空' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textArea,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '面积',
                    hintText: '输入面积',
                    errorText: errorFlag[1] == 1  ? '面积不能为空' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textAreaUse,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '实用面积',
                    hintText: '输入实用面积',
                    errorText: errorFlag[2] == 1  ? '实用面积不能为空' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                Container(
                  height: 120,
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: _textDescription,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: '描述',
                      hintText: '描述',
                      errorText: errorFlag[3] == 1 ? '描述请填写' : null,
                    ),
                  ),
                ),

                Container(
                  height: kSpacing,
                ),
                Container(
                  child: InkWell(
                    onTap: uploadImage,
                    child: _park.imageUrl != null
                        ?  Image(
                            image: NetworkImage(
                                'http://localhost:8080/open/gridfs/${_park.imageUrl}'),
                          )
                        : Center(
                            child:
                                Image.asset('assets/icons/icon_add_image.png'),
                          ),
                  ),
                  height: 200,
                ),
                Container(
                  height: kSpacing,
                ),
                ElevatedButton(
                  style: elevateButtonStyle,
                  onPressed: () {
                    save();
                  },
                  child: const Text('保存'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(withReadStream: true);
    if (result != null) {
      //log(result.files.first.name);
      //File file = File(result.files.first.name);
      log('start to load ');
      try {
        //print('start to upload');r
       PlatformFile pFile = result.files.single;
        var formData = FormData.fromMap({
          'userId': userId,
          'corpId': HttpApi.corpId,
          'file':  MultipartFile( pFile.readStream as Stream<List<int>>, pFile.size, filename: pFile.name)
        });
      
        var ret = await DioUtils().requestUpload(
          HttpApi.open_gridfs_upload,
          data: formData
        );
      // print(json.encode(ret));
        setState((){
          _park.imageUrl = ret['id'];
        });
        
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    } else {
      // User canceled the picker
    }
  }

  String basename(String path){
    return path.substring(path.lastIndexOf('/') + 1);
  }
}
