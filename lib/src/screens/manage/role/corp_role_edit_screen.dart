import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/manage/CorpRole.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';

class CorpRoleEditScreen extends StatefulWidget {
  final int? id;

  const CorpRoleEditScreen({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  State<CorpRoleEditScreen> createState() => _CorpRoleEditScreenState();
}

class _CorpRoleEditScreenState extends State<CorpRoleEditScreen> {
  final _textName = TextEditingController();
  List<int> errorFlag = [0, 0, 0, 0, 0, 0, 0];
  
  CorpRole _corpRole = CorpRole();
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

    try {
      var retData =
          await DioUtils().request('${HttpApi.role_find}${widget.id}', "GET");

      if (retData != null) {
        setState(() {
          _corpRole = CorpRole.fromJson(retData);
          _textName.text = _corpRole.name!;
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

    _corpRole.name = _textName.text;
    _corpRole.corpId = currentCorp!.id;

    if(null == widget.id ) {
      try {
        var retData = await DioUtils().request(HttpApi.role_add, "POST",
            data: json.encode(_corpRole), isJson: true);
        Navigator.of(context).pop();
      } on DioError catch (error) {
        CustomAppException customAppException = CustomAppException.create(
            error);
        debugPrint(customAppException.getMessage());
      }
    }else{
      try {
        var retData = await DioUtils().request('${HttpApi.role_update}${widget.id}', "PUT",
            data: json.encode(_corpRole), isJson: true);
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
        title: const Text('角色编辑'),
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

}
