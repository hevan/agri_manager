import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sp_util/sp_util.dart';
import 'package:znny_manager/src/model/ConstType.dart';
import 'package:znny_manager/src/model/project/ProductBatch.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/base/park_select_screen.dart';
import 'package:znny_manager/src/screens/product/product_select_screen.dart';
import 'package:znny_manager/src/utils/constants.dart';

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
  final _textDescription = TextEditingController();
  final _textQuantity = TextEditingController();
  final _textUnit = TextEditingController();

  List<int> errorFlag = [0,0,0,0,0,0,0,0];

  var selectProduct = {"id":null, 'name': null};

  ProductBatch _productBatch = ProductBatch(corpId: HttpApi.corpId);
  int? userId;

  @override
  void dispose() {
    _textName.dispose();
    _textProductName.dispose();
    _textCode.dispose();
    _textDescription.dispose();
    _textStartAt.dispose();
    _textParkName.dispose();
    _textQuantity.dispose();
    _textUnit.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();

    setState(() {
      userId = SpUtil.getInt(Constant.userId);
    });
  }

  Future loadData() async {

    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.batch_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _productBatch = ProductBatch.fromJson(retData);

            _textName.text = _productBatch.name != null ? _productBatch.name! : '';
            _textCode.text = _productBatch.code != null ? _productBatch.code! : '';
            _textProductName.text = _productBatch.productName != null ? _productBatch.productName! : '';
            _textParkName.text = _productBatch.parkName != null ? _productBatch.parkName! : '';
            _textStartAt.text = _productBatch.startAt != null ? _productBatch.startAt! : '';
            _textDescription.text = _productBatch.description != null ? _productBatch.description! : '';
            _textUnit.text = _productBatch.unit != null ? _productBatch.unit! : '';
            _textQuantity.text = _productBatch.quantity != null ? _productBatch.quantity!.toString() : '';
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

    if(_textQuantity.text == ''){
      errorFlag[6] = 1;
      checkError=true;
    }

    if(_textUnit.text == ''){
      errorFlag[7] = 1;
      checkError=true;
    }

    if(checkError){
      setState((){

      });
      return;
    }

    _productBatch.name = _textName.text;
    _productBatch.code = _textCode.text;
    _productBatch.description = _textDescription.text;
    _productBatch.startAt = _textStartAt.text;
    _productBatch.quantity = double.parse(_textQuantity.text);
    _productBatch.unit = _textUnit.text;

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
                            _productBatch.productName = productMap['name'];
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
                            _productBatch.parkName = parkMap['name'];
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
                  controller: _textQuantity,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '数量',
                    hintText: '数量',
                    errorText: errorFlag[6] == 1  ? '数量不能为空' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textUnit,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '计算单位',
                    hintText: '计算单位',
                    errorText: errorFlag[7] == 1  ? '计算单位不能为空' : null,
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
