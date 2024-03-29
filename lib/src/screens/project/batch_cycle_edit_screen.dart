import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/business/CheckManager.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/project/BatchCycle.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/manage/manager/manager_select_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

class BatchCycleEditScreen extends StatefulWidget {
  final int? id;
  final int batchId;

  const BatchCycleEditScreen(
      {Key? key, this.id, required this.batchId})
      : super(key: key);

  @override
  State<BatchCycleEditScreen> createState() => _BatchCycleEditScreenState();
}

class _BatchCycleEditScreenState extends State<BatchCycleEditScreen> {
  final _textName = TextEditingController();
  final _textParentName = TextEditingController();
  final _textDays = TextEditingController();
  final _textDescription = TextEditingController();
  final _textStartAt = TextEditingController();
  final _textEndAt = TextEditingController();
  final _textStatus = TextEditingController();
  final _textProgress = TextEditingController();
  final _textCreateUserName = TextEditingController();

  List<int> errorFlag = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  
  List<BatchCycle> listCycle = [];
  BatchCycle? parentCycle;

  BatchCycle _batchCycle = BatchCycle(status: 0);

  Corp? curCorp;
  LoginInfoToken? userInfo;

  @override
  void dispose() {
    _textName.dispose();
    _textParentName.dispose();
    _textDays.dispose();
    _textDescription.dispose();
    _textStartAt.dispose();
    _textEndAt.dispose();
    _textStatus.dispose();
    _textProgress.dispose();
    _textCreateUserName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();

    setState(() {
      _batchCycle.batchId = widget.batchId;
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });

  }

  Future loadData() async {
    var params = {'batchId': widget.batchId};

    try {
      var retData = await DioUtils().request(
          HttpApi.batch_cycle_findAll, "GET",
          queryParameters: params);

      setState(() {
        listCycle =
            (retData as List).map((e) => BatchCycle.fromJson(e)).toList();
      });
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

    if (widget.id != null) {
      try {
        var retData = await DioUtils().request(
            HttpApi.batch_cycle_find + widget.id!.toString(), "GET");

        if (retData != null) {
          setState(() {
            _batchCycle = BatchCycle.fromJson(retData);

            _textName.text =
                _batchCycle.name != null ? _batchCycle.name! : '';
            _textDays.text =
                _batchCycle.days != null ? _batchCycle.days.toString() : '';
            _textDescription.text = _batchCycle.description != null
                ? _batchCycle.description!
                : '';
            _textStartAt.text = _batchCycle.startAt != null
                ? _batchCycle.startAt!
                : '';
            _textEndAt.text = _batchCycle.endAt != null
                ? _batchCycle.endAt!
                : '';

            if (null != _batchCycle.parentId) {
              for (int i = 0; i < listCycle.length; i++) {
                if (listCycle[i].id == _batchCycle.parentId) {
                  parentCycle = listCycle[i];
                  _textParentName.text = parentCycle!.name!;
                }
              }
            }
          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }
  }

  Future save() async {
    bool checkError = false;

    if (_textName.text == '') {
      errorFlag[1] = 1;
      checkError = true;
    }

    if (_textStartAt.text == '') {
      errorFlag[2] = 1;
      checkError = true;
    }


    if (_textDays.text == '') {
      errorFlag[3] = 1;
      checkError = true;
    }


    if (_textDescription.text == '') {
      errorFlag[5] = 1;
      checkError = true;
    }

    if (_textCreateUserName.text == '') {
      errorFlag[6] = 1;
      checkError = true;
    }

    if (checkError) {
      return;
    }

    _batchCycle.name = _textName.text;
    _batchCycle.days = int.parse(_textDays.text);
    _batchCycle.description = _textDescription.text;
    _batchCycle.startAt = _textStartAt.text;
    _batchCycle.batchId = widget.batchId;
    _batchCycle.parentId = null != parentCycle ? parentCycle!.id : null;
    _batchCycle.corpId = curCorp?.id;
    _batchCycle.createdUserId = userInfo?.userId;

    debugPrint(json.encode(_batchCycle));
    try {
      var retData = await DioUtils().request(HttpApi.batch_cycle_add, "POST",
          data: json.encode(_batchCycle), isJson: true);
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
        title: const Text('任务管理'),
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
                  controller: _textParentName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择主阶段',
                    hintText: '主阶段',
                    errorText: errorFlag[0] == 1 ? '请选择生产阶段' : '',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        int? ret = await showDialog<int>(
                          context: context,
                          builder: (content) {
                            return SimpleDialog(
                                title: const Text('选择生产阶段'),
                                children: [
                                  SizedBox(
                                    height: 400.0,
                                    width: 400.0,
                                    child: ListView.builder(
                                      itemCount: listCycle.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        BatchCycle curItem = listCycle[index];
                                        return ListTile(
                                          title: Text("${curItem.name}"),
                                          subtitle:
                                              Text("${curItem.description}"),
                                          onTap: () {


                                            Navigator.of(context).pop(index);
                                          },
                                        );
                                      },
                                    ),
                                  )
                                ]);
                            //使用AlertDialog会报错
                            //return AlertDialog(content: child);
                          },
                        );
                        if (ret != null) {
                          setState(() {
                            parentCycle = listCycle[ret];
                            _textParentName.text = parentCycle!.name!;
                            _batchCycle.parentId = parentCycle!.id!;
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
                  controller: _textName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '名称',
                    hintText: '输入名称',
                    errorText: errorFlag[1] == 1 ? '名称不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textStartAt,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '开始日期',
                    hintText: '开始日期',
                    errorText: errorFlag[2] == 1 ? '日期不能为空' : null,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: _batchCycle.startAt != null ? DateFormat('yyyy-MM-dd').parse(_batchCycle.startAt!): DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2055),
                        );
                        if (selected != null ) {

                          setState(() {
                            _batchCycle.startAt =  DateFormat('yyyy-MM-dd').format(selected);
                            _textStartAt.text = _batchCycle.startAt!;
                          });
                        }
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                  ),
                ),
                Container(
                  height: defaultPadding,
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
                      errorText: errorFlag[5] == 1 ? '描述请填写' : null,
                    ),
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textDays,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '生长天数',
                    hintText: '生长天数',
                    errorText: errorFlag[3] == 1 ? '生长天数不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                DropdownButtonFormField<Map<String, dynamic>>(
                  value:  Constant.listStatus[_batchCycle.status!],
                  items: Constant.listStatus
                      .map((itemStatus) => DropdownMenuItem(
                    child: Text('${itemStatus['name']}'),
                    value: itemStatus,
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _batchCycle.status = value!['status']!;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '任务状态',
                    hintText: '选择任务状态',
                  ),
                ),
                TextField(
                  controller: _textCreateUserName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '责任人',
                    hintText: '责任人',
                    errorText: errorFlag[6] == 1 ? '请选择责任人' : '',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        String retData = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ManagerSelectScreen(),
                                fullscreenDialog: true));
                        if (retData != null) {
                          // ignore: curly_braces_in_flow_control_structures
                          setState(() {
                            var retDataMap = json.decode(retData);
                            CheckManager curCheck = CheckManager.fromJson(retDataMap);
                            _textCreateUserName.text = curCheck.nickName!;
                            _batchCycle.createdUserId = curCheck.userId!;
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
                Container(
                  height: kSpacing,
                ),
                Container(
                  child: InkWell(
                    onTap: uploadImage,
                    child: _batchCycle.imageUrl != null
                        ? Image(
                            image: NetworkImage(
                                '${HttpApi.host_image}${_batchCycle.imageUrl}'),
                          )
                        : Center(
                            child:
                                Image.asset('assets/icons/icon_add_image.png'),
                          ),
                  ),
                  height: 200,
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
        //print('start to upload');r
        PlatformFile pFile = result.files.single;
        var formData = FormData.fromMap({
          'userId': userInfo?.userId,
          'corpId': curCorp?.id,
          'file': MultipartFile(
              pFile.readStream as Stream<List<int>>, pFile.size,
              filename: pFile.name)
        });

        var ret = await DioUtils()
            .requestUpload(HttpApi.open_gridfs_upload, data: formData);
        // print(json.encode(ret));
        setState(() {
          _batchCycle.imageUrl = ret['id'];
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

  String basename(String path) {
    return path.substring(path.lastIndexOf('/') + 1);
  }
}
