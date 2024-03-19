import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/ConstType.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/project/BatchProduct.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/base/park_select_screen.dart';
import 'package:agri_manager/src/screens/product/product_select_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

class BatchEditScreen extends StatefulWidget {
  final int? id;

  const BatchEditScreen({Key? key, this.id}) : super(key: key);

  @override
  State<BatchEditScreen> createState() => _BatchEditScreenState();
}

class _BatchEditScreenState extends State<BatchEditScreen> {
  final _textName = TextEditingController();
  final _textProductName = TextEditingController();
  final _textParkName = TextEditingController();
  final _textCode = TextEditingController();
  final _textStartAt = TextEditingController();
  final _textEndAt = TextEditingController();
  final _textDescription = TextEditingController();
  final _textQuantity = TextEditingController();
  final _textArea = TextEditingController();
  final _textestimatedPrice = TextEditingController();
  final _textUnit = TextEditingController();

  List<int> errorFlag = [0,0,0,0,0,0,0,0,0,0,0,0,0,0];

  var selectProduct = {"id":null, 'name': null};

  BatchProduct _productBatch = BatchProduct();
  Corp? curCorp;
  LoginInfoToken? userInfo;

  @override
  void dispose() {
    _textName.dispose();
    _textCode.dispose();
    _textProductName.dispose();
    _textParkName.dispose();
    _textDescription.dispose();
    _textStartAt.dispose();
    _textEndAt.dispose();
    _textParkName.dispose();
    _textQuantity.dispose();
    _textestimatedPrice.dispose();
    _textUnit.dispose();
    _textArea.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();

    setState(() {
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });

  }

  Future loadData() async {

    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.batch_find  + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _productBatch = BatchProduct.fromJson(retData);
            _textProductName.text = _productBatch.product!.name!;
            _textParkName.text = _productBatch.park!.name!;
            _textName.text = _productBatch.name != null ? _productBatch.name! : '';
            _textCode.text = _productBatch.code != null ? _productBatch.code! : '';
            _textStartAt.text = _productBatch.startAt != null ? _productBatch.startAt! : '';
            _textEndAt.text = _productBatch.endAt != null ? _productBatch.endAt! : '';
            _textDescription.text = _productBatch.description != null ? _productBatch.description! : '';
            _textUnit.text = _productBatch.calcUnit != null ? _productBatch.calcUnit! : '';
            _textQuantity.text = _productBatch.quantity.toString();
            _textestimatedPrice.text = _productBatch.estimatedPrice.toString();
            _textArea.text = _productBatch.area.toString();
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
    log(_textProductName.text);
    if(_textProductName.text == ''){
      errorFlag[0] = 1;
      checkError=true;
    }
    if(_textParkName.text == ''){
      errorFlag[5] = 1;
      checkError=true;
    }

    if(_textName.text == ''){
      errorFlag[1] = 1;
      checkError=true;
    }

    if(_textCode.text == ''){
      errorFlag[2] = 1;
      checkError=true;
    }

    if(_textStartAt.text == ''){
      errorFlag[3] = 1;
      checkError=true;
    }

    if(_textDescription.text == ''){
      errorFlag[4] = 1;
      checkError=true;
    }

    if(_textArea.text == ''){
      errorFlag[9] = 1;
      checkError=true;
    }

    if(_textestimatedPrice.text == ''){
      errorFlag[10] = 1;
      checkError=true;
    }

    if(_textQuantity.text == ''){
      errorFlag[6] = 1;
      checkError=true;
    }

    if(_textUnit.text == ''){
      errorFlag[7] = 1;
      checkError=true;
    }

    if(_textEndAt.text == ''){
      errorFlag[8] = 1;
      checkError=true;
    }

    if(checkError){
      return;
    }

    _productBatch.name = _textName.text;
    _productBatch.code = _textCode.text;
    _productBatch.description = _textDescription.text;
    _productBatch.startAt = _textStartAt.text;
    _productBatch.endAt = _textEndAt.text;
    _productBatch.area = double.parse(_textArea.text);
    _productBatch.quantity = double.parse(_textQuantity.text);
    _productBatch.estimatedPrice = double.parse(_textestimatedPrice.text);
    _productBatch.corpId = curCorp?.id;
    _productBatch.createdUserId = userInfo?.userId;

    try {
      var retData = await DioUtils().request(HttpApi.batch_add, "POST",
          data: json.encode(_productBatch), isJson: true);
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
        title: const Text('项目编辑'),
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
                  controller: _textProductName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择产品',
                    hintText: '产品',
                    errorText: errorFlag[0] == 1?'请选择产品':'',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        String retProduct = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProductSelectScreen(),
                              fullscreenDialog: true)
                        );
                        if(retProduct != null)
                          // ignore: curly_braces_in_flow_control_structures
                          setState(() {
                            var productMap = json.decode(retProduct);
                            _productBatch.productId = productMap['id'];
                           _textProductName.text = productMap['name'];
                          });
                      },
                      icon: const Icon(Icons.search_sharp),
                    ),
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textParkName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择基地',
                    hintText: '基地',
                    errorText: errorFlag[5] == 1?'请选择基地':'',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        String retPark = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ParkSelectScreen(),
                                fullscreenDialog: true)
                        );
                        if(retPark != null)
                          // ignore: curly_braces_in_flow_control_structures
                          setState(() {
                            var parkMap = json.decode(retPark);
                            _productBatch.parkId = parkMap['id'];
                            _textParkName.text = parkMap['name'];
                          });
                      },
                      icon: const Icon(Icons.search_sharp),
                    ),
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textCode,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '编号',
                    hintText: '编号',
                    errorText: errorFlag[1] == 1 ? '编号' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '批次名称',
                    hintText: '输入名称',
                    errorText: errorFlag[2] == 1  ? '名称不能为空' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textStartAt,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '开始日期',
                    hintText: '开始日期',
                    errorText: errorFlag[3] == 1 ? '开始日期不能为空' : null,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: _productBatch.startAt != null ? DateFormat('yyyy-MM-dd').parse(_productBatch.startAt!): DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2055),
                        );
                        if (selected != null ) {

                          setState(() {
                            _productBatch.startAt =  DateFormat('yyyy-MM-dd').format(selected);
                            _textStartAt.text = _productBatch.startAt!;
                          });
                        }
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textEndAt,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '结束日期',
                    hintText: '结束日期',
                    errorText: errorFlag[3] == 1 ? '结束日期不能为空' : null,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: _productBatch.endAt != null ? DateFormat('yyyy-MM-dd').parse(_productBatch.endAt!): DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2055),
                        );
                        if (selected != null ) {

                          setState(() {
                            _productBatch.endAt =  DateFormat('yyyy-MM-dd').format(selected);
                            _textEndAt.text = _productBatch.endAt!;
                          });
                        }
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                  ),
                ),
                TextField(
                  controller: _textUnit,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '计量单位',
                    hintText: '计量单位',
                    errorText: errorFlag[7] == 1  ? '计算单位不能为空' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textArea,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '面积',
                    hintText: '面积',
                    errorText: errorFlag[9] == 1  ? '面积不能为空' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textQuantity,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '单位产量',
                    hintText: '单位产量',
                    errorText: errorFlag[6] == 1  ? '单位产量不能为空' : null,
                  ),
                ),

                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textestimatedPrice,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '预估销售价',
                    hintText: '预估销售价',
                    errorText: errorFlag[6] == 1  ? '预估销售价不能为空' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
            InputDecorator(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: '状态',
                labelText:
                _productBatch.status == null ? '选择状态' : '状态',
              ),
              child: DropdownButton<int>(
                  // Step 3.
                  value: _productBatch.status,
                 underline: Container(),
                  isExpanded: true,
                // Step 4.
                  items:  ConstType.taskStatus
                      .map<DropdownMenuItem<int>>((item) {
                    return DropdownMenuItem<int>(
                      value: item['id'],
                      child: Text(
                        item['name']
                      ),
                    );
                  }).toList(),
                  // Step 5.
                  onChanged: (int? newValue) {
                    setState(() {
                      print(newValue);
                      _productBatch.status = newValue;

                      print(_productBatch.status);
                    });
                  },
                ),),
                Container(
                  height: kSpacing,
                ),
                Container(
                  height: 120,
                  child: TextField(
                    maxLines: 5,
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
