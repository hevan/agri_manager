import 'dart:convert';
import 'dart:developer';
import 'dart:html';

import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/ConstType.dart';
import 'package:znny_manager/src/model/manage/CorpDepart.dart';
import 'package:znny_manager/src/model/manage/CorpRole.dart';
import 'package:znny_manager/src/model/product/ProductCycle.dart';
import 'package:znny_manager/src/model/manage/UserInfo.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/manage/role/corp_role_select.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class ManagerEditScreen extends StatefulWidget {
  final int? id;

  const ManagerEditScreen({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  State<ManagerEditScreen> createState() => _ManagerEditScreenState();
}

class _ManagerEditScreenState extends State<ManagerEditScreen> {
  final _textName = TextEditingController();
  final _textMobile = TextEditingController();
  final _textRoleDesc = TextEditingController();

  List<int> errorFlag = [0, 0, 0, 0, 0, 0, 0];

  List<CorpDepart> listDepart = [];
  List<CorpRole> listSelectRole = [];

  UserInfo _userInfo = UserInfo(enabled: false);

  @override
  void dispose() {
    _textName.dispose();
    _textMobile.dispose();
    _textRoleDesc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future loadData() async {
    var params = {'corpId': HttpApi.corpId};

    try {
      var retData =
          await DioUtils().request('${HttpApi.user_find}${widget.id}', "GET", isJson: true);

      if (retData != null) {
        setState(() {
          _userInfo = UserInfo.fromJson(retData);
          _textMobile.text = _userInfo.mobile!;
          _textName.text = _userInfo.nickName!;

          if(_userInfo.roleDesc != null) {
            var retJson = jsonDecode(_userInfo.roleDesc!);

            listSelectRole =
                (retJson as List).map((e) => CorpRole.fromJson(e)).toList();

            String strRoles = '';
            for (int i = 0; i < listSelectRole.length; i++) {
              strRoles = '$strRoles${listSelectRole[i].name},';
            }

            _textRoleDesc.text = strRoles;
          }
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

    try {
      var retDepartData = await DioUtils()
          .request(HttpApi.depart_findAll, "GET", queryParameters: params);

      if (retDepartData != null) {
        setState(() {
          listDepart = (retDepartData as List)
              .map((e) => CorpDepart.fromJson(e))
              .toList();
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

    if (_textMobile.text == '') {
      errorFlag[1] = 1;
      checkError = true;
    }

    if (_textRoleDesc.text == '') {
      errorFlag[3] = 1;
      checkError = true;
    }

    if (checkError) {
      return;
    }

    _userInfo.nickName = _textName.text;
    _userInfo.mobile = _textMobile.text;
    _userInfo.corpId = HttpApi.corpId;

    if(widget.id == null) {
      try {
        var retData = await DioUtils().request(HttpApi.user_add, "POST",
            data: json.encode(_userInfo), isJson: true);
        Navigator.of(context).pop();
      } on DioError catch (error) {
        CustomAppException customAppException = CustomAppException.create(
            error);
        debugPrint(customAppException.getMessage());
      }
    }else{
      try {
        var retData = await DioUtils().request('${HttpApi.user_update}${widget.id}', "PUT",
            data: json.encode(_userInfo), isJson: true);
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
        title: const Text('人员编辑'),
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
                TextField(
                  controller: _textMobile,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '手机号码',
                    hintText: '输入手机号码',
                    errorText: errorFlag[1] == 1 ? '手机号码不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                InputDecorator(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: '部门',
                    labelText:
                    _userInfo.depart == null ? '选择部门' : '部门',
                  ),
                  child: DropdownButton<String>(
                    // Step 3.
                    value: _userInfo.depart,
                    underline: Container(),
                    isExpanded: true,
                    // Step 4.
                    items:  listDepart
                        .map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item.name,
                        child: Text(
                            '${item.name}'
                        ),
                      );
                    }).toList(),
                    // Step 5.
                    onChanged: (String? newValue) {
                      setState(() {
                        _userInfo.depart = newValue;
                      });
                    },
                  ),),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textRoleDesc,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '角色',
                    hintText: '角色',
                    errorText: errorFlag[5] == 1?'请选择角色':'',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        String retRoles = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  CorpRoleSelect(userRoles: listSelectRole),
                                fullscreenDialog: true)
                        );
                        if(retRoles != null)
                          // ignore: curly_braces_in_flow_control_structures
                          setState(() {
                              var retJson = jsonDecode(retRoles);

                              listSelectRole =
                                  (retJson as List).map((e) => CorpRole.fromJson(e)).toList();

                              String strRoles = '';
                              for(int i=0;i<listSelectRole.length;i++){
                                strRoles = '$strRoles${listSelectRole[i].name},';
                              }
                              _userInfo.roleDesc = retRoles;

                              _textRoleDesc.text = strRoles;

                          });
                      },
                      icon: const Icon(Icons.search_sharp),
                    ),
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                Container(
                  child:CheckboxListTile(
                    value: _userInfo.enabled,
                    title: const Text('用户有效状态'),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) {
                      setState(() {
                        _userInfo.enabled = isChecked;
                      });
                    },
                  )
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
