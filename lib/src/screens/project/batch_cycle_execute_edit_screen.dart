import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/project/BatchCycle.dart';
import 'package:agri_manager/src/model/project/BatchCycleExecute.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';

class BatchCycleExecuteEditScreen extends StatefulWidget {
  final int? id;
  final int batchCycleId;
  final String batchCycleName;

  const BatchCycleExecuteEditScreen(
      {Key? key, this.id,  required this.batchCycleId,  required this.batchCycleName})
      : super(key: key);

  @override
  State<BatchCycleExecuteEditScreen> createState() => _BatchCycleExecuteEditScreenState();
}

class _BatchCycleExecuteEditScreenState extends State<BatchCycleExecuteEditScreen> {
  final _textName = TextEditingController();
  final _textBatchCycleName = TextEditingController();
  final _textEndAt = TextEditingController();
  final _textProgress = TextEditingController();
  final _textDescription = TextEditingController();
  final _textStartAt = TextEditingController();

  List<int> errorFlag = [0, 0, 0, 0, 0, 0, 0,   0];
  
  List<BatchCycle> listCycle = [];
  BatchCycle? parentCycle;

  BatchCycleExecute _batchCycleExecute = BatchCycleExecute(status: 0);


  Corp? curCorp;
  LoginInfoToken? userInfo;

  @override
  void dispose() {
    _textName.dispose();
    _textBatchCycleName.dispose();
    _textEndAt.dispose();
    _textDescription.dispose();
    _textProgress.dispose();
    _textStartAt.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });

    loadData();
  }

  Future loadData() async {

    if (widget.id != null) {
      try {
        var retData = await DioUtils().request(
            HttpApi.batch_cycle_execute_find + widget.id!.toString(), "GET");

        if (retData != null) {
          setState(() {
            _batchCycleExecute = BatchCycleExecute.fromJson(retData);

            _textName.text =
            _batchCycleExecute.name != null ? _batchCycleExecute.name! : '';
            _textDescription.text = _batchCycleExecute.description != null
                ? _batchCycleExecute.description!
                : '';
            _textProgress.text = _batchCycleExecute.progress != null
                ? _batchCycleExecute.progress!.toString()
                : '';
            _textStartAt.text = _batchCycleExecute.startAt != null
                ? _batchCycleExecute.startAt!
                : '';
            _textEndAt.text = _batchCycleExecute.endAt != null
                ? _batchCycleExecute.endAt!
                : '';
            _textProgress.text = _batchCycleExecute.progress != null
                ? _batchCycleExecute.progress!.toString()
                : '';

          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }
      setState(() {
        _batchCycleExecute.batchCycleId = widget.batchCycleId;
        _textBatchCycleName.text = widget.batchCycleName;
      });
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
    if (_textEndAt.text == '') {
      errorFlag[3] = 1;
      checkError = true;
    }

    if (_textProgress.text == '') {
      errorFlag[4] = 1;
      checkError = true;
    }

    if (_textDescription.text == '') {
      errorFlag[5] = 1;
      checkError = true;
    }

    if (checkError) {
      return;
    }

    _batchCycleExecute.name = _textName.text;
    _batchCycleExecute.description = _textDescription.text;
    _batchCycleExecute.startAt = _textStartAt.text;
    _batchCycleExecute.endAt = _textEndAt.text;
    _batchCycleExecute.progress = double.parse(_textProgress.text);
    _batchCycleExecute.corpId = curCorp?.id;
    _batchCycleExecute.createdUserId = userInfo?.userId;

    debugPrint(json.encode(_batchCycleExecute));
    try {
      var retData = await DioUtils().request(HttpApi.batch_cycle_execute_add, "POST",
          data: json.encode(_batchCycleExecute), isJson: true);
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
        title: const Text('任务执行'),
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
                  controller: _textBatchCycleName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择任务',
                    hintText: '选择任务',
                    errorText: errorFlag[0] == 1 ? '请选择任务阶段' : '',
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
                            _textBatchCycleName.text = parentCycle!.name!;
                            _batchCycleExecute.batchCycleId = parentCycle!.id!;
                            _batchCycleExecute.batchId = parentCycle!.batchId!;
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
                          initialDate: _batchCycleExecute.startAt != null ? DateFormat('yyyy-MM-dd').parse(_batchCycleExecute.startAt!): DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2055),
                        );
                        if (selected != null ) {

                          setState(() {
                            _batchCycleExecute.startAt =  DateFormat('yyyy-MM-dd').format(selected);
                            _textStartAt.text = _batchCycleExecute.startAt!;
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
                TextField(
                  controller: _textEndAt,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '结束日期',
                    hintText: '结束日期',
                    errorText: errorFlag[3] == 1 ? '日期不能为空' : null,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: _batchCycleExecute.endAt != null ? DateFormat('yyyy-MM-dd').parse(_batchCycleExecute.endAt!): DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2055),
                        );
                        if (selected != null ) {

                          setState(() {
                            _batchCycleExecute.endAt =  DateFormat('yyyy-MM-dd').format(selected);
                            _textEndAt.text = _batchCycleExecute.endAt!;
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
                  controller: _textProgress,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '进度',
                    hintText: '进度',
                    errorText: errorFlag[4] == 1 ? '进度' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                DropdownButtonFormField<Map<String, dynamic>>(
                  value:  Constant.listStatus[_batchCycleExecute.status!],
                  items: Constant.listStatus
                      .map((itemStatus) => DropdownMenuItem(
                    child: Text('${itemStatus['name']}'),
                    value: itemStatus,
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _batchCycleExecute.status = value!['status']!;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '任务状态',
                    hintText: '选择任务状态',
                  ),
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
}
