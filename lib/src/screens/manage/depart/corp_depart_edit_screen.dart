import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/manage/CorpDepart.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class CorpDepartEditScreen extends StatefulWidget {
  final int? id;

  const CorpDepartEditScreen({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  State<CorpDepartEditScreen> createState() => _CorpDepartEditScreenState();
}

class _CorpDepartEditScreenState extends State<CorpDepartEditScreen> {
  final _textName = TextEditingController();
  List<int> errorFlag = [0, 0, 0, 0, 0, 0, 0];
  
  CorpDepart _corpDepart = CorpDepart();
  Corp?   currentCorp;
  @override
  void dispose() {
    _textName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState((){
      currentCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
    });
    loadData();
  }

  Future loadData() async {
    var params = {'corpId': currentCorp!.id};

    try {
      var retData =
          await DioUtils().request('${HttpApi.depart_find}${widget.id}', "GET");

      if (retData != null) {
        setState(() {
          _corpDepart = CorpDepart.fromJson(retData);
          _textName.text = _corpDepart.name!;
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }


  }

  Future save() async {
    bool checkError = false;

    if (_textName.text == '') {
      errorFlag[0] = 1;
      checkError = true;
    }


    if (checkError) {
      setState((){

      });
      return;
    }

    _corpDepart.name = _textName.text;
    _corpDepart.corpId = currentCorp!.id;

    if(null == widget.id ) {
      try {
        var retData = await DioUtils().request(HttpApi.depart_add, "POST",
            data: json.encode(_corpDepart), isJson: true);
        Navigator.of(context).pop();
      } on DioError catch (error) {
        CustomAppException customAppException = CustomAppException.create(
            error);
        debugPrint(customAppException.getMessage());
      }
    }else{
      try {
        var retData = await DioUtils().request('${HttpApi.depart_update}${widget.id}', "PUT",
            data: json.encode(_corpDepart), isJson: true);
        Navigator.of(context).pop();
      } on DioError catch (error) {
        CustomAppException customAppException = CustomAppException.create(
            error);
        debugPrint(customAppException.getMessage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('部门编辑'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '名称',
                    hintText: '输入名称',
                    errorText: errorFlag[0] == 1 ? '名称不能为空' : null,
                  ),
                ),

                Container(
                  height: defaultPadding,
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
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withReadStream: true);
    if (result != null) {
      //log(result.files.first.name);
      //File file = File(result.files.first.name);
      log('start to load ');
      try {
        //rint('start to upload');r
        PlatformFile pFile = result.files.single;
        var formData = FormData.fromMap({
          'userId': widget.id,
          'corpId': currentCorp?.id,
          'file': MultipartFile(
              pFile.readStream as Stream<List<int>>, pFile.size,
              filename: pFile.name)
        });
        //print('start to upload');
        var ret = await DioUtils().requestUpload(
          HttpApi.open_gridfs_upload,
          data: formData,
        );
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    } else {
      // User canceled the picker
    }
  }

  String basename(String path) {
    return path.substring(path.lastIndexOf('/') + 1);
  }
}
