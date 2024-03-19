import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/sys/Address.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';

class AddressEditScreen extends StatefulWidget {
  final Address? address;
  const AddressEditScreen({Key? key, this.address}) : super(key: key);

  @override
  State<AddressEditScreen> createState() => _AddressEditScreenState();
}

class _AddressEditScreenState extends State<AddressEditScreen> {
  final _textLinkName = TextEditingController();
  final _textLinkMobile = TextEditingController();

  final _textRegion = TextEditingController();
  final _textProvince = TextEditingController();
  final _textCity = TextEditingController();
  final _textLineDetail = TextEditingController();

  List<int> errorFlag = [0,0,0,0,0,0,0,0,0];


  Address _address = Address();

  @override
  void dispose() {
    _textLinkName.dispose();
    _textLinkMobile.dispose();
    _textRegion.dispose();
    _textProvince.dispose();
    _textCity.dispose();
    _textLineDetail.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // loadData();

    if(null != widget.address){
      setState(() {
        _address = widget.address!;
      });
    }
  }

  /*
  Future loadData() async {
  
    if(widget.address != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.market_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _address = Address.fromJson(retData);

            _textLinkName.text = _address.linkName != null ? _address.linkName! : '';
            _textLinkMobile.text = _address.linkMobile != null ? _address.linkMobile! : '';
            _textRegion.text = _address.region != null ? _address.region! : '';
            _textProvince.text = _address.province != null ? _address.province! : '';
            _textCity.text = _address.city != null ? _address.city! : '';
            _textLineDetail.text = _address.lineDetail != null ? _address.lineDetail! : '';
          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException = CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }


  }
   */

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

    if(_textProvince.text == ''){
      errorFlag[2] = 1;
      checkError=true;
    }
    if(_textCity.text == ''){
      errorFlag[3] = 1;
      checkError=true;
    }

    if(_textRegion.text == ''){
      errorFlag[4] = 1;
      checkError=true;
    }


    if(_textLineDetail.text == ''){
      errorFlag[5] = 1;
      checkError=true;
    }

    if(checkError){
      return;
    }

    _address.linkName = _textLinkName.text;
    _address.linkMobile = _textLinkMobile.text;
    _address.region = _textRegion.text;
    _address.province = _textProvince.text;
    _address.city = _textCity.text;
    _address.lineDetail = _textLineDetail.text;

    try {
      if(null != _address.id) {
        var retData = await DioUtils().request('${HttpApi.address_updte}${_address.id}', "PUT",
            data: json.encode(_address.toJson()), isJson: true);
      }else{
        Navigator.of(context).pop(json.encode(_address));
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('地址编辑'),
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
                    labelText: '联系人',
                    hintText: '联系人名称',
                    errorText: errorFlag[0] == 1?'请输入联系人名称':'',
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
                    errorText: errorFlag[1] == 1?'请输入联系电话':'',
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
                  controller: _textRegion,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '区域',
                    hintText: '输入区域',
                    errorText: errorFlag[4] == 1  ? '区域不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textLineDetail,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '详细地址',
                    hintText: '详细地址',
                    errorText: errorFlag[5] == 1 ? '详细地址不能为空' : null,
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
