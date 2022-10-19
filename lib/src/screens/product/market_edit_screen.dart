import 'dart:convert';
import 'dart:developer';

import 'package:sp_util/sp_util.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/product/Product.dart';
import 'package:znny_manager/src/model/product/Market.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class MarketEditScreen extends StatefulWidget {
  final int? id;
  const MarketEditScreen({Key? key, this.id}) : super(key: key);

  @override
  State<MarketEditScreen> createState() => _MarketEditScreenState();
}

class _MarketEditScreenState extends State<MarketEditScreen> {
  final _textName = TextEditingController();

  final _textArea = TextEditingController();
  final _textLocation = TextEditingController();
  final _textProvince = TextEditingController();
  final _textCity = TextEditingController();
  final _textAddress = TextEditingController();

  List<int> errorFlag = [0,0,0,0,0,0,0,0,0];

  int _validateCode = 0;
  String _errorMessage = "";

  Market _market = Market();

  @override
  void dispose() {
    _textName.dispose();

    _textArea.dispose();
    _textProvince.dispose();
    _textCity.dispose();
    _textAddress.dispose();
    _textLocation.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future loadData() async {
  
    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.market_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _market = Market.fromJson(retData);

            _textName.text = _market.name != null ? _market.name! : '';
            _textArea.text = _market.area != null ? _market.area! : '';
            _textProvince.text = _market.province != null ? _market.province! : '';
            _textCity.text = _market.city != null ? _market.city! : '';
            _textLocation.text = _market.location != null ? _market.location! : '';
            _textAddress.text = _market.address != null ? _market.address! : '';
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

    if(_textArea.text == ''){
      errorFlag[1] = 1;
      checkError=true;
    }

    if(_textProvince.text == ''){
      errorFlag[2] = 1;
      checkError=true;
    }

    if(_textCity.text == ''){
      errorFlag[3] = 1;
      checkError=true;
    }

    if(_textAddress.text == ''){
      errorFlag[4] = 1;
      checkError=true;
    }

    if(checkError){
      return;
    }

    _market.name = _textName.text;
    _market.area = _textArea.text;
    _market.province = _textProvince.text;
    _market.city = _textCity.text;
    _market.address = _textAddress.text;
    _market.location = _textLocation.text;
    _market.corpId = HttpApi.corpId;
    try {
      var retData = await DioUtils().request(HttpApi.market_add, "POST",
          data: json.encode(_market.toJson()), isJson: true);
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
        title: const Text('全国市场'),
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
                    labelText: '市场名称',
                    hintText: '市场名称',
                    errorText: errorFlag[0] == 1?'请输入市场名称':'',
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textArea,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '区域',
                    hintText: '输入区域',
                    errorText: errorFlag[1] == 1  ? '区域不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textProvince,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '省份',
                    hintText: '输入省份',
                    errorText: errorFlag[2] == 1  ? '省份不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textCity,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '城市',
                    hintText: '输入城市',
                    errorText: errorFlag[3] == 1  ? '城市不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),

                TextField(
                  controller: _textAddress,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '详细地址',
                    hintText: '详细地址',
                    errorText: errorFlag[4] == 1 ? '详细地址不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textLocation,
                  decoration: const InputDecoration(
                    border:  OutlineInputBorder(),
                    labelText: '地址定位',
                    hintText: '地址定位'
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
