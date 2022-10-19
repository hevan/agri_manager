import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/customer/Customer.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';

class CustomerEditScreen extends StatefulWidget {
  final int? id;
  const CustomerEditScreen({Key? key, this.id}) : super(key: key);

  @override
  State<CustomerEditScreen> createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final _textName = TextEditingController();

  final _textCode = TextEditingController();
  final _textDescription = TextEditingController();
  final _textManagerName = TextEditingController();
  final _textManagerMobile = TextEditingController();
  

  List<int> errorFlag = [0,0,0,0,0,0,0,0,0];

  int _validateCode = 0;
  String _errorMessage = "";

  Customer _customer = Customer(isCustomer: false, isSupply: false);

  @override
  void dispose() {
    _textName.dispose();

    _textCode.dispose();
    _textManagerName.dispose();
    _textManagerMobile.dispose();
    _textDescription.dispose();

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
            HttpApi.customer_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _customer = Customer.fromJson(retData);

            _textName.text = _customer.name != null ? _customer.name! : '';
            _textCode.text = _customer.code != null ? _customer.code! : '';
            _textManagerName.text = _customer.managerName != null ? _customer.managerName! : '';
            _textManagerMobile.text = _customer.managerMobile != null ? _customer.managerMobile! : '';
            _textDescription.text = _customer.description != null ? _customer.description! : '';
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

    if(_textCode.text == ''){
      errorFlag[1] = 1;
      checkError=true;
    }

    if(_textManagerName.text == ''){
      errorFlag[2] = 1;
      checkError=true;
    }

    if(_textManagerMobile.text == ''){
      errorFlag[3] = 1;
      checkError=true;
    }


    if(checkError){
      return;
    }

    _customer.name = _textName.text;
    _customer.code = _textCode.text;
    _customer.managerName = _textManagerName.text;
    _customer.managerMobile = _textManagerMobile.text;
    _customer.description = _textDescription.text;
    _customer.corpId = HttpApi.corpId;

    try {
      var retData = await DioUtils().request(HttpApi.customer_add, "POST",
          data: json.encode(_customer.toJson()), isJson: true);
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
        title: const Text('客户'),
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
                    hintText: '名称',
                    errorText: errorFlag[0] == 1?'请输入名称':'',
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textCode,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '代码',
                    hintText: '代码',
                    errorText: errorFlag[1] == 1  ? '代码不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textManagerName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '联系人',
                    hintText: '联系人',
                    errorText: errorFlag[2] == 1  ? '联系人不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textManagerMobile,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '联系电话',
                    hintText: '联系电话',
                    errorText: errorFlag[3] == 1  ? '联系电话不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textDescription,
                  decoration: const InputDecoration(
                    border:  OutlineInputBorder(),
                    labelText: '描述',
                    hintText: '描述'
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                Row(
                  children: [
                     Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: _customer.isCustomer,
                      onChanged: (bool? value) {
                        setState(() {
                          _customer.isCustomer = value!;
                        });
                      },
                    ),
                    const Text('客户'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: _customer.isSupply,
                      onChanged: (bool? value) {
                        setState(() {
                          _customer.isSupply = value!;
                        });
                      },
                    ),
                    const Text('供应商'),
                  ],
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

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }
}
