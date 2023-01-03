import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:znny_manager/src/model/manage/CorpRole.dart';
import 'package:znny_manager/src/model/sys/sys_menu.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';

class MenuEditScreen extends StatefulWidget {
  final int? id;

  const MenuEditScreen({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  State<MenuEditScreen> createState() => _MenuEditScreenState();
}

class _MenuEditScreenState extends State<MenuEditScreen> {
  final _textName = TextEditingController();
  final _textIcon = TextEditingController();
  final _textPath = TextEditingController();

  List<int> errorFlag = [0, 0, 0, 0, 0, 0, 0];

  List<SysMenu> listMenu = [];
  List<CorpRole> listSelectRole = [];

  SysMenu _sysMenu = SysMenu();

  @override
  void dispose() {
    _textName.dispose();
    _textIcon.dispose();
    _textPath.dispose();
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
          await DioUtils().request('${HttpApi.sys_menu_find}${widget.id}', "GET", isJson: true);

      if (retData != null) {
        setState(() {
          _sysMenu = SysMenu.fromJson(retData);
          if(_sysMenu.iconUrl != null) {
            _textIcon.text = _sysMenu.iconUrl!;
          }
          _textName.text = _sysMenu.name!;
          _textPath.text = _sysMenu.path!;

        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

    try {
      var retMenuData = await DioUtils()
          .request(HttpApi.sys_menu_findAll, "GET", queryParameters: params);

      if (retMenuData != null) {
        setState(() {
          listMenu = (retMenuData as List)
              .map((e) => SysMenu.fromJson(e))
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


    if (_textPath.text == '') {
      errorFlag[3] = 1;
      checkError = true;
    }

    if (checkError) {
      return;
    }

    _sysMenu.name = _textName.text;
    _sysMenu.iconUrl = _textIcon.text;
    _sysMenu.path = _textPath.text;
    _sysMenu.corpId = HttpApi.corpId;

    if(widget.id == null) {
      try {
        var retData = await DioUtils().request(HttpApi.sys_menu_add, "POST",
            data: json.encode(_sysMenu), isJson: true);
        Navigator.of(context).pop();
      } on DioError catch (error) {
        CustomAppException customAppException = CustomAppException.create(
            error);
        debugPrint(customAppException.getMessage());
      }
    }else{
      try {
        var retData = await DioUtils().request('${HttpApi.sys_menu_update}${widget.id}', "PUT",
            data: json.encode(_sysMenu), isJson: true);
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
        title: const Text('菜单编辑'),
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
                  controller: _textIcon,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '图标路径',
                    hintText: '输入图标路径',
                    errorText: errorFlag[1] == 1 ? '图标路径不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textPath,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '路径',
                    hintText: '输入路径',
                    errorText: errorFlag[1] == 1 ? '路径不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                InputDecorator(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: '上级',
                    labelText:
                    _sysMenu.parentId == null ? '选择上级' : '上级',
                  ),
                  child: DropdownButton<int>(
                    // Step 3.
                    value: _sysMenu.parentId,
                    underline: Container(),
                    isExpanded: true,
                    // Step 4.
                    items: listMenu
                        .map<DropdownMenuItem<int>>((item) {
                      return DropdownMenuItem<int>(
                        value: item.id,
                        child: Text(
                            '${item.name}'
                        ),
                      );
                    }).toList(),
                    // Step 5.
                    onChanged: (int? newValue) {
                      setState(() {
                        //print(newValue);
                        _sysMenu.parentId = newValue;
                      });
                    },
                  ),),
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
