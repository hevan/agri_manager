import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/manage/Corp.dart';
import 'package:znny_manager/src/model/sys/Address.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/manage/corp/corp_edit_screen.dart';
import 'package:znny_manager/src/shared_components/show_field_text.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CorpViewScreen extends StatefulWidget {
  final Corp data;

  const CorpViewScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<CorpViewScreen> createState() => _CorpViewScreenState();
}

class _CorpViewScreenState extends State<CorpViewScreen> {


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  /*
  Future loadData() async {
    var params = {'corpId': HttpApi.corpId};

    try {
      var retData =
          await DioUtils().request('${HttpApi.corp_find}${widget.id}', "GET");

      if (retData != null) {
        setState(() {
          _corp = Corp.fromJson(retData);
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }
  }

   */

  toEdit(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>   CorpEditScreen(id: widget.data.id )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FittedBox(
        fit: BoxFit.fill,child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(title: '名称', data: widget.data.name ?? '' ),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(title: '机构代码', data: widget.data.code ?? '' ),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(title: '描述', data: widget.data.description ?? '' , dataLine: 4,),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(title: '所在地区', data: '${widget.data.address?.province ?? ''}${widget.data.address?.city ?? ''}${widget.data.address?.region ?? ''}'),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(title: '详细地址', data: '${widget.data.address?.lineDetail ?? ''}' ),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(title: '联系人', data: '${widget.data.address?.linkName ?? ''}' ),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(title: '联系电话', data: '${widget.data.address?.linkMobile ?? ''}' ),
                const SizedBox(
                  height: kSpacing,
                ),

                ElevatedButton(
                  style: elevateButtonStyle,
                  onPressed: () {
                    toEdit();
                  },
                  child: const Text('编辑'),
                )
              ],
            ),
          ));
  }
}
