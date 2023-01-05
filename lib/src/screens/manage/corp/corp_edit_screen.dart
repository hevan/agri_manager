import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/manage/Corp.dart';
import 'package:znny_manager/src/model/sys/Address.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CorpEditScreen extends StatefulWidget {
  final int? id;

  const CorpEditScreen({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  State<CorpEditScreen> createState() => _CorpEditScreenState();
}

class _CorpEditScreenState extends State<CorpEditScreen> {
  final _textName = TextEditingController();
  final _textCode = TextEditingController();
  final _textDescription = TextEditingController();
  final _textProvince = TextEditingController();
  final _textCity = TextEditingController();
  final _textRegion = TextEditingController();
  final _textLineDetail = TextEditingController();
  final _textLinkName = TextEditingController();
  final _textLinkMobile = TextEditingController();

  List<int> errorFlag = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  
  Corp _corp = Corp();

  @override
  void dispose() {
    _textName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if(null != widget.id) {
      loadData();
    }
  }

  Future loadData() async {

    try {
      var retData =
          await DioUtils().request('${HttpApi.corp_find}${widget.id}', "GET");

      if (retData != null) {
        setState(() {
          _corp = Corp.fromJson(retData);
          _textName.text = _corp.name?? '';
          _textCode.text = _corp.code?? '';
          _textDescription.text = _corp.description?? '';
          _textProvince.text = _corp.address?.province ?? '';
          _textCity.text = _corp.address?.city ?? '';
          _textRegion.text = _corp.address?.region ?? '';
          _textLineDetail.text = _corp.address?.lineDetail ?? '';
          _textLinkName.text = _corp.address?.linkName ?? '';
          _textLinkMobile.text = _corp.address?.linkMobile ?? '';
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }


  }

  Future save() async {
    bool checkError = false;

    if (_textName.text == '') {
      errorFlag[0] = 1;
      checkError = true;
    }

    if (_textCode.text == '') {
      errorFlag[1] = 1;
      checkError = true;
    }

    if (_textDescription.text == '') {
      errorFlag[2] = 1;
      checkError = true;
    }

    if (_textProvince.text == '') {
      errorFlag[3] = 1;
      checkError = true;
    }

    if (_textCity.text == '') {
      errorFlag[4] = 1;
      checkError = true;
    }

    if (_textRegion.text == '') {
      errorFlag[5] = 1;
      checkError = true;
    }

    if (_textLineDetail.text == '') {
      errorFlag[6] = 1;
      checkError = true;
    }

    if (_textLinkName.text == '') {
      errorFlag[7] = 1;
      checkError = true;
    }

    if (_textLinkMobile.text == '') {
      errorFlag[8] = 1;
      checkError = true;
    }


    if (checkError) {
      setState((){

      });
      return;
    }

    _corp.name = _textName.text;
    _corp.code = _textCode.text;
    _corp.description = _textDescription.text;
    _corp.address ??= new Address();
    _corp.address!.province = _textProvince.text;
    _corp.address!.city = _textCity.text;
    _corp.address!.region = _textRegion.text;
    _corp.address!.lineDetail = _textCity.text;
    _corp.address!.linkName = _textLinkName.text;
    _corp.address!.linkMobile = _textLinkMobile.text;

    try {
      if(null == widget.id ) {
        var retData = await DioUtils().request(HttpApi.corp_add, "POST",
            data: json.encode(_corp), isJson: true);
      }else{
        var retData = await DioUtils().request('${HttpApi.corp_update}${widget.id}', "PUT",
            data: json.encode(_corp), isJson: true);
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('企业信息编辑'),
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
                const SizedBox(
                  height: kSpacing,
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
                const SizedBox(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textCode,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '机构代码',
                    hintText: '输入机构代码',
                    errorText: errorFlag[1] == 1 ? '机构代码不能为空' : null,
                  ),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textDescription,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '描述',
                    hintText: '输入描述',
                    errorText: errorFlag[2] == 1 ? '2述不能为空' : null,
                  ),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textProvince,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '省份',
                    hintText: '输入省份',
                    errorText: errorFlag[3] == 1 ? '省份不能为空' : null,
                  ),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textCity,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '城市',
                    hintText: '输入城市',
                    errorText: errorFlag[4] == 1 ? '城市不能为空' : null,
                  ),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textRegion,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '区县',
                    errorText: errorFlag[5] == 1 ? '区县不能为空' : null,
                  ),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textLineDetail,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '详细地址',
                    errorText: errorFlag[6] == 1 ? '详细地址不能为空' : null,
                  ),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textLinkName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '联系人',
                    hintText: '输入联系人',
                    errorText: errorFlag[7] == 1 ? '联系人不能为空' : null,
                  ),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textLinkMobile,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '联系电话',
                    hintText: '输入联系电话',
                    errorText: errorFlag[8] == 1 ? '联系电话不能为空' : null,
                  ),
                ),
                const SizedBox(
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
            ),),
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
          'corpId': HttpApi.corpId,
          'file': MultipartFile(
              pFile.readStream as Stream<List<int>>, pFile.size,
              filename: pFile.name)
        });
        //print('start to upload');
        var ret = await DioUtils().requestUpload(
          HttpApi.open_file_upload,
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
