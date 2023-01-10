import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sp_util/sp_util.dart';
import 'package:znny_manager/src/model/manage/Corp.dart';
import 'package:znny_manager/src/model/manage/CorpDepart.dart';
import 'package:znny_manager/src/model/manage/CorpManager.dart';
import 'package:znny_manager/src/model/manage/CorpManagerDepart.dart';
import 'package:znny_manager/src/model/manage/CorpManagerInfo.dart';
import 'package:znny_manager/src/model/manage/CorpManagerRole.dart';
import 'package:znny_manager/src/model/manage/CorpRole.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/agri_util.dart';
import 'package:znny_manager/src/utils/constants.dart';

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
  final _textPosition = TextEditingController();

  List<int> errorFlag = [0, 0, 0, 0, 0, 0, 0];

  Corp?   currentCorp;

  List<CorpDepart> listDepart = [];
  List<CorpRole> listRole = [];

  CorpManagerInfo _corpManagerInfo = CorpManagerInfo();

  @override
  void dispose() {
    _textName.dispose();
    _textMobile.dispose();
    _textPosition.dispose();
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
    var params = {'id': widget.id};

    try {
      var retData =
          await DioUtils().request(HttpApi.corp_manager_info_find, "GET", queryParameters: params, isJson: true);

      if (retData != null) {
        setState(() {
          _corpManagerInfo = CorpManagerInfo.fromJson(retData);
          _textMobile.text = _corpManagerInfo.mobile!;
          _textName.text = _corpManagerInfo.nickName!;
          _textPosition.text = _corpManagerInfo.position!;
        });

        debugPrint(json.encode(_corpManagerInfo));
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
    var paramsCorpId = {'corpId': currentCorp!.id};

    try {

      var retDepartData = await DioUtils()
          .request(HttpApi.depart_findAll, "GET", queryParameters: paramsCorpId, isJson: true);

      if (retDepartData != null) {
        debugPrint(json.encode(retDepartData));
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

    try {
      var retDepartRole = await DioUtils()
          .request(HttpApi.role_findAll, "GET", queryParameters: paramsCorpId, isJson:true);

      if (retDepartRole != null) {
        debugPrint(json.encode(retDepartRole));
        setState(() {
          listRole = (retDepartRole as List)
              .map((e) => CorpRole.fromJson(e))
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

    if (_textPosition.text == '') {
      errorFlag[2] = 1;
      checkError = true;
    }

    if (checkError) {
      return;
    }

    _corpManagerInfo.nickName = _textName.text;
    _corpManagerInfo.mobile = _textMobile.text;
    _corpManagerInfo.corpId = currentCorp?.id;
    if(widget.id == null) {
      try {
        var retData = await DioUtils().request(HttpApi.corp_manager_info_add, "POST",
            data: json.encode(_corpManagerInfo), isJson: true);
        Navigator.of(context).pop();
      } on DioError catch (error) {
        CustomAppException customAppException = CustomAppException.create(
            error);
        debugPrint(customAppException.getMessage());
      }
    }else{
      try {
        List<CorpManagerDepart> manageDeparts = _corpManagerInfo.listCorpDepart!.map((e) => CorpManagerDepart(id: null, managerId: _corpManagerInfo.id, departId: e.id)).toList();
        List<CorpManagerRole> manageRoles = _corpManagerInfo.listCorpRole!.map((e) => CorpManagerRole(id: null, managerId: _corpManagerInfo.id, roleId: e.id)).toList();

        CorpManager corpManager =  CorpManager(id:_corpManagerInfo.id, corpId: _corpManagerInfo.corpId, userId: _corpManagerInfo.userId,
            createdAt: AgriUtil.dateTimeFormat(DateTime.now()), position: _corpManagerInfo.position, listManagerDepart: manageDeparts, listManagerRole: manageRoles);
        debugPrint(json.encode(corpManager));
        var retData = await DioUtils().request('${HttpApi.corp_manager_update}${widget.id}', "PUT",
            data: json.encode(corpManager), isJson: true);
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
                TextField(
                  controller: _textPosition,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '职位',
                    hintText: '输入职位',
                    errorText: errorFlag[1] == 1 ? '职位不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.4),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      MultiSelectBottomSheetField(
                        initialChildSize: 0.4,
                        listType: MultiSelectListType.CHIP,
                        searchable: true,
                        buttonText: Text("角色选择"),
                        title: Text("角色"),
                        initialValue: _corpManagerInfo.listCorpRole ?? [],
                        items: listRole
                            .map((role) => MultiSelectItem<CorpRole>(role, role.name!))
                            .toList(),
                        onConfirm: (values) {
                          setState(() {
                            _corpManagerInfo.listCorpRole = values.cast<CorpRole>();
                          });

                        },
                        chipDisplay: MultiSelectChipDisplay(
                          onTap: (value) {
                            setState(() {
                              _corpManagerInfo.listCorpRole?.remove(value);
                            });
                          },
                        ),
                      ),
                      _corpManagerInfo.listCorpRole == null || _corpManagerInfo.listCorpRole!.isEmpty
                          ? Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "没有选择角色",
                            style: TextStyle(color: Colors.black54),
                          ))
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.4),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      MultiSelectBottomSheetField(
                        initialChildSize: 0.4,
                        listType: MultiSelectListType.CHIP,
                        searchable: true,
                        buttonText: Text("部门选择"),
                        title: Text("部门"),
                        initialValue: _corpManagerInfo.listCorpDepart ?? [],
                        items: listDepart
                            .map((item) => MultiSelectItem<CorpDepart>(item, item.name!))
                            .toList(),
                        onConfirm: (values) {
                          setState(() {
                            _corpManagerInfo.listCorpDepart = values.cast<CorpDepart>();
                          });

                        },
                        chipDisplay: MultiSelectChipDisplay(
                          onTap: (value) {
                            setState(() {
                              _corpManagerInfo.listCorpDepart?.remove(value);
                            });
                          },
                        ),
                      ),
                      _corpManagerInfo.listCorpDepart == null || _corpManagerInfo.listCorpDepart!.isEmpty
                          ? Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "没有选择角色",
                            style: TextStyle(color: Colors.black54),
                          ))
                          : Container(),
                    ],
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
