import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/customer/CustomerLink.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';

class CustomerLinkEditScreen extends StatefulWidget {
  final int? id;
  final int? customerId;
  const CustomerLinkEditScreen({Key? key, this.id, this.customerId}) : super(key: key);

  @override
  State<CustomerLinkEditScreen> createState() => _CustomerLinkEditScreenState();
}

class _CustomerLinkEditScreenState extends State<CustomerLinkEditScreen> {
  final _textLinkName = TextEditingController();
  final _textLinkMobile = TextEditingController();
  final _textDescription = TextEditingController();
  final _textPosition = TextEditingController();

  List<int> errorFlag = [0,0,0,0,0,0,0,0,0];

  int _validateCode = 0;
  String _errorMessage = "";

  CustomerLink _customerLink = CustomerLink();
  int? userId;

  @override
  void dispose() {
    _textLinkName.dispose();
    _textPosition.dispose();
    _textLinkMobile.dispose();
    _textDescription.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();

    if(widget.customerId != null){
      setState(() {
        _customerLink.customerId = widget.customerId;
      });
    }
  }

  Future loadData() async {
   
    

    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.customer_link_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _customerLink = CustomerLink.fromJson(retData);

            _textLinkName.text = _customerLink.linkName != null ? _customerLink.linkName! : '';
            _textDescription.text = _customerLink.description != null ? _customerLink.description! : '';
             _textLinkMobile.text = _customerLink.linkMobile != null ? _customerLink.linkMobile! : '';
            _textPosition.text =_customerLink.position != null ? _customerLink.position! : '';
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


    if(_textLinkName.text == ''){
      errorFlag[0] = 1;
      checkError=true;
    }

    if(_textLinkMobile.text == ''){
      errorFlag[1] = 1;
      checkError=true;
    }


    if(_textDescription.text == ''){
      errorFlag[2] = 1;
      checkError=true;
    }

    if(_textPosition.text == ''){
      errorFlag[3] = 1;
      checkError=true;
    }

    if(checkError){
      return;
    }

    _customerLink.linkMobile = _textLinkMobile.text;
    _customerLink.description = _textDescription.text;
    _customerLink.linkName = _textLinkName.text;
    _customerLink.position = _textPosition.text;
    try {
      var retData = await DioUtils().request(HttpApi.customer_link_add, "POST",
          data: json.encode(_customerLink.toJson()), isJson: true);
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
        title: const Text('客户联系人'),
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
                  controller: _textLinkName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '姓名',
                    hintText: '输入姓名',
                    errorText: errorFlag[0] == 1  ? '姓名不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textLinkMobile,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '电话',
                    hintText: '输入电话',
                    errorText: errorFlag[1] == 1  ? '电话不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textPosition,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '职务',
                    hintText: '输入职务',
                    errorText: errorFlag[3] == 1  ? '职务不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textDescription,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '描述',
                    hintText: '描述',
                    errorText: errorFlag[2] == 1 ? '描述不能为空' : null,
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
