import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:sp_util/sp_util.dart';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/project/ProductBatch.dart';
import 'package:znny_manager/src/model/project/BatchCycle.dart';
import 'package:znny_manager/src/model/project/BatchRisk.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class BatchRiskEditScreen extends StatefulWidget {
  final int? id;
  final int batchId;
  final String batchName;
  final int productId;
  final String productName;
  const BatchRiskEditScreen({Key? key, this.id, required this.batchId, required this.batchName, required this.productId, required this.productName}) : super(key: key);

  @override
  State<BatchRiskEditScreen> createState() => _BatchRiskEditScreenState();
}

class _BatchRiskEditScreenState extends State<BatchRiskEditScreen> {
  final _textName = TextEditingController();
  final _textCycleName = TextEditingController();
  final _textFeeAmount = TextEditingController();
  final _textDescription = TextEditingController();
  final _textSolution = TextEditingController();

  List<int> errorFlag = [0,0,0,0,0,0,0];

  List<String> riskCategory = ['虫情','病情','生长风险','自然风险'];

  List<BatchCycle> listCycle = [];
  BatchCycle? parentCycle;

  BatchRisk _batchRisk = BatchRisk();
  int? userId;

  @override
  void dispose() {
    _textName.dispose();
    _textCycleName.dispose();
    _textDescription.dispose();
    _textFeeAmount.dispose();
    _textSolution.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();

    setState(() {
      _batchRisk.batchId = widget.batchId;
      _batchRisk.batchName = widget.batchName;
      _batchRisk.productId = widget.productId;
      _batchRisk.productName = widget.productName;

      userId = SpUtil.getInt(Constant.userId);
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

    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.batch_risk_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _batchRisk = BatchRisk.fromJson(retData);

            _textName.text = _batchRisk.name != null ? _batchRisk.cycleName! : '';
            _textCycleName.text = _batchRisk.cycleName != null ? _batchRisk.name! : '';
            _textSolution.text = _batchRisk.solution != null ? _batchRisk.solution! : '';
            _textFeeAmount.text = _batchRisk.feeAmount != null ? _batchRisk.feeAmount.toString() : '';
            _textDescription.text = _batchRisk.description != null ? _batchRisk.description! : '';
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


    if(_textName.text == ''){
      errorFlag[0] = 1;
      checkError=true;
    }

    if(_batchRisk.riskCategory == ''){
      errorFlag[2] = 1;
      checkError=true;
    }



    if(_textCycleName.text == ''){
      errorFlag[1] = 1;
      checkError=true;
    }

    if(_textDescription.text == ''){
      errorFlag[4] = 1;
      checkError=true;
    }

    if(_textSolution.text == ''){
      errorFlag[5] = 1;
      checkError=true;
    }

    if(_textFeeAmount.text == ''){
      errorFlag[6] = 1;
      checkError=true;
    }

    if(checkError){
      return;
    }

    _batchRisk.name = _textName.text;
    _batchRisk.cycleName = _textCycleName.text;
    _batchRisk.description = _textDescription.text;
    _batchRisk.solution = _textSolution.text;
    _batchRisk.feeAmount = double.parse(_textFeeAmount.text);

    try {
      var retData = await DioUtils().request(HttpApi.batch_risk_add, "POST",
          data: json.encode(_batchRisk), isJson: true);
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
        title: const Text('病虫害'),
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
                  controller: _textCycleName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择主阶段',
                    hintText: '主阶段',
                    errorText: errorFlag[0] == 1?'请选择生产阶段':'',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        int? ret = await showDialog<int>(
                          context: context,
                          builder: (content) {
                            return SimpleDialog(
                                 title: const Text('选择生产阶段'),
                                children:[
                                  SizedBox(
                                  height: 400.0, width: 400.0,
                                    child: ListView.builder(
                                  itemCount: listCycle.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    BatchCycle curItem = listCycle[index];
                                    return ListTile(
                                      title: Text("${curItem.name}"),
                                      subtitle: Text("${curItem.description}"),
                                      onTap: () {
                                        Navigator.of(context).pop(index);
                                      },
                                    );
                                  },
                                ),
                            )]);
                            //使用AlertDialog会报错
                            //return AlertDialog(content: child);
                          },
                        );
                        if (ret != null) {
                          setState(() {
                            parentCycle = listCycle[ret];
                            _textCycleName.text = parentCycle!.name!;
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
                    errorText: errorFlag[1] == 1  ? '名称不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                DropdownButtonFormField<String>(
                  value: _batchRisk.riskCategory,
                  items: riskCategory
                      .map((label) => DropdownMenuItem(
                    child: Text(label.toString()),
                    value: label,
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _batchRisk.riskCategory = value;
                    });

                  },
                  decoration: const InputDecoration(
                    border:  OutlineInputBorder(),
                    labelText: '类别',
                    hintText: '选择类别',
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
                      errorText: errorFlag[4] == 1 ? '描述请填写' : null,
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
                    controller: _textSolution,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: '解决方案',
                      hintText: '解决方案',
                      errorText: errorFlag[5] == 1 ? '解决方案必须填写' : null,
                    ),
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textFeeAmount,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '投入费用',
                    hintText: '费用',
                    errorText: errorFlag[6] == 1 ? '投入费用' : null,
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(withReadStream: true);
    if (result != null) {
      //log(result.files.first.name);
      //File file = File(result.files.first.name);
      log('start to load ');
      try {
        //rint('start to upload');r
       PlatformFile pFile = result.files.single;
        var formData = FormData.fromMap({
          'userId': userId,
          'corpId': HttpApi.corpId,
          'file':  MultipartFile( pFile.readStream as Stream<List<int>>, pFile.size, filename: pFile.name)
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

  String basename(String path){
    return path.substring(path.lastIndexOf('/') + 1);
  }
}
