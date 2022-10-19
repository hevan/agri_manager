import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/contract/Contract.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';

import 'package:intl/intl.dart';

class CustomerContractEditScreen extends StatefulWidget {
  final int? id;
  final int? customerId;
  final String? customerName;
  const CustomerContractEditScreen({Key? key, this.id, this.customerId, this.customerName}) : super(key: key);

  @override
  State<CustomerContractEditScreen> createState() => _CustomerContractEditScreenState();
}

class _CustomerContractEditScreenState extends State<CustomerContractEditScreen> {
  final _textName = TextEditingController();
  final _textDescription = TextEditingController();
  final _textSignAt = TextEditingController();

  final _textStartAt = TextEditingController();
  final _textEndAt = TextEditingController();

  List<int> errorFlag = [0,0,0,0,0,0,0,0,0];

  int _validateCode = 0;
  String _errorMessage = "";

  DateTime selectedDate = DateTime.now();

  DateFormat df = DateFormat('yyyy-MM-dd');

  Contract _contract = Contract();
  int? userId;

  @override
  void dispose() {
    _textName.dispose();
    _textDescription.dispose();
    _textSignAt.dispose();
    _textStartAt.dispose();
    _textEndAt.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();

    if(widget.customerId != null){
      setState(() {
        _contract.customerId = widget.customerId;
        _contract.customerName = widget.customerName;
      });
    }
  }

  Future loadData() async {
   
    

    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.contract_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _contract = Contract.fromJson(retData);

            _textName.text = _contract.name != null ? _contract.name! : '';
            _textDescription.text = _contract.description != null ? _contract.description! : '';
             _textSignAt.text = _contract.signAt != null ? _contract.signAt! : '';
            _textStartAt.text = _contract.startAt != null ? _contract.startAt! : '';
            _textEndAt.text = _contract.endAt != null ? _contract.endAt! : '';
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

    if(_textDescription.text == ''){
      errorFlag[1] = 1;
      checkError=true;
    }

    if(_textSignAt.text == ''){
      errorFlag[2] = 1;
      checkError=true;
    }

    if(_textStartAt.text == ''){
      errorFlag[3] = 1;
      checkError=true;
    }

    if(_textEndAt.text == ''){
      errorFlag[4] = 1;
      checkError=true;
    }

    if(checkError){
      return;
    }

    _contract.name = _textName.text;
    _contract.description = _textDescription.text;
    _contract.signAt = _textSignAt.text;
    _contract.startAt = _textStartAt.text;
    _contract.endAt = _textEndAt.text;

    try {
      var retData = await DioUtils().request(HttpApi.contract_add, "POST",
          data: json.encode(_contract.toJson()), isJson: true);
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
        title: const Text('合约管理'),
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
                    labelText: '合同标题',
                    hintText: '输入合同标题',
                    errorText: errorFlag[0] == 1  ? '标题不能为空' : null,
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
                    errorText: errorFlag[1] == 1 ? '描述不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textSignAt,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: '日期',
                      hintText: '输入日期',
                      errorText: errorFlag[2] == 1  ? '日期不能为空' : null,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.date_range),
                          onPressed:()  {_selectDate(context);}
                      )
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
                      hintText: '输入开始日期',
                      errorText: errorFlag[3] == 1  ? '开始日期不能为空' : null,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.date_range),
                          onPressed:()  {_selectDateStart(context);}
                      )
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
                      hintText: '输入结束日期',
                      errorText: errorFlag[3] == 1  ? '结束日期不能为空' : null,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.date_range),
                          onPressed:()  {_selectDateEnd(context);}
                      )
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

  Future _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2022),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _textSignAt.text = df.format(selectedDate);
        _contract.signAt =  _textSignAt.text;
      });
    }
  }

  Future _selectDateStart(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2022),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        _textStartAt.text = df.format(picked);
        _contract.startAt =  _textStartAt.text;
      });
    }
  }

  Future _selectDateEnd(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2022),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        _textEndAt.text = df.format(picked);
        _contract.endAt =  _textEndAt.text;
      });
    }
  }
}
