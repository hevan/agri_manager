import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/customer/CustomerTrace.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';

import 'package:intl/intl.dart';

class CustomerTraceEditScreen extends StatefulWidget {
  final int? id;
  final int? customerId;
  final String? customerName;
  const CustomerTraceEditScreen({Key? key, this.id, this.customerId, this.customerName}) : super(key: key);

  @override
  State<CustomerTraceEditScreen> createState() => _CustomerTraceEditScreenState();
}

class _CustomerTraceEditScreenState extends State<CustomerTraceEditScreen> {
  final _textTitle = TextEditingController();
  final _textDescription = TextEditingController();
  final _textOccurAt = TextEditingController();
  final _textLinkName = TextEditingController();
  final _textLinkMobile = TextEditingController();

  List<int> errorFlag = [0,0,0,0,0,0,0,0,0];

  int _validateCode = 0;
  String _errorMessage = "";

  DateTime selectedDate = DateTime.now();

  DateFormat df = DateFormat('yyyy-MM-dd');

  CustomerTrace _customerTrace = CustomerTrace();

  Corp? curCorp;
  LoginInfoToken? userInfo;

  @override
  void dispose() {
    _textTitle.dispose();
    _textDescription.dispose();
    _textOccurAt.dispose();
    _textLinkName.dispose();
    _textLinkMobile.dispose();
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

    if(widget.customerId != null){
      setState(() {
        _customerTrace.customerId = widget.customerId;
      });
    }
  }

  Future loadData() async {
   
    

    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.customer_trace_find + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _customerTrace = CustomerTrace.fromJson(retData);

            _textTitle.text = _customerTrace.title != null ? _customerTrace.title! : '';
            _textDescription.text = _customerTrace.description != null ? _customerTrace.description! : '';
             _textOccurAt.text = _customerTrace.occurAt != null ? _customerTrace.occurAt! : '';
            _textLinkName.text = _customerTrace.linkName != null ? _customerTrace.linkName! : '';
            _textLinkMobile.text = _customerTrace.linkMobile != null ? _customerTrace.linkMobile! : '';
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

    if(_textOccurAt.text == ''){
      errorFlag[0] = 1;
      checkError=true;
    }

    if(_textLinkName.text == ''){
      errorFlag[1] = 1;
      checkError=true;
    }

    if(_textLinkMobile.text == ''){
      errorFlag[2] = 1;
      checkError=true;
    }

    if(_textTitle.text == ''){
      errorFlag[3] = 1;
      checkError=true;
    }


    if(_textDescription.text == ''){
      errorFlag[4] = 1;
      checkError=true;
    }

    if(checkError){
      return;
    }

    _customerTrace.title = _textTitle.text;
    _customerTrace.description = _textDescription.text;
    _customerTrace.occurAt = _textOccurAt.text;
    _customerTrace.linkName = _textLinkName.text;
    _customerTrace.linkMobile = _textLinkMobile.text;
    _customerTrace.corpId = curCorp?.id;
    _customerTrace.createdUserId = userInfo?.userId;


    try {
      var retData = await DioUtils().request(HttpApi.customer_trace_add, "POST",
          data: json.encode(_customerTrace), isJson: true);
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
        title: const Text('客户跟进'),
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
                  controller: _textOccurAt,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: '日期',
                      hintText: '输入日期',
                      errorText: errorFlag[1] == 1  ? '日期不能为空' : null,
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
                  controller: _textLinkName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '联系人',
                    hintText: '联系人',
                    errorText: errorFlag[1] == 1  ? '联系人不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textLinkMobile,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '联系电话',
                    hintText: '联系电话',
                    errorText: errorFlag[2] == 1  ? '联系电话不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textTitle,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '跟进标题',
                    hintText: '输入跟进标题',
                    errorText: errorFlag[3] == 1  ? '标题不能为空' : null,
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
                    errorText: errorFlag[4] == 1 ? '描述不能为空' : null,
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
        _textOccurAt.text = df.format(selectedDate);
        _customerTrace.occurAt =  _textOccurAt.text;
      });
    }
  }
}
