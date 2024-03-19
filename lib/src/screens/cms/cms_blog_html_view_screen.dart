import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/cms/CmsBlog.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:flutter_html/flutter_html.dart';

class CmsBlogHtmlViewScreen extends StatefulWidget {
  final int? id;
  final String? title;
  final String? imageUrl;
  const CmsBlogHtmlViewScreen({Key? key, this.id, this.title, this.imageUrl}) : super(key: key);

  @override
  State<CmsBlogHtmlViewScreen> createState() => _CmsBlogHtmlViewScreenState();
}

class _CmsBlogHtmlViewScreenState extends State<CmsBlogHtmlViewScreen> {

  CmsBlog? _cmsBlog;
  LoginInfoToken? userInfo;
  Corp? curCorp;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    
    setState(() {
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
      //curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
    });

    loadData();

  }

  Future loadData() async {

    if (widget.id != null) {
      try {
        var retData = await DioUtils()
            .request('${HttpApi.cms_blog_find}${widget.id}', "GET");

        if (retData != null) {
          setState(() {
            _cmsBlog = CmsBlog.fromJson(retData);

          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
        Fluttertoast.showToast(
            msg: customAppException.getMessage(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 6);
      }
    }
  }

  Future saveUserActive(String action) async {

    var activeData = {"userId": userInfo?.userId, "blogId": _cmsBlog?.id, "action": action};

    try {
       var retData = await DioUtils().request(HttpApi.cms_user_active_add, "POST",
            data: json.encode(activeData), isJson: true);

       return true;
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(
          msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return await saveUserActive('view');
        },
        child: Scaffold(
      appBar: AppBar(
        title:  Text('${widget?.title}'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_cmsBlog?.author}'),
                    Text('${_cmsBlog?.category?.name}'),
                    Text('${_cmsBlog?.publishAt}')
                  ],
                ),
                null != _cmsBlog && null != _cmsBlog?.content ? Html(
                  data: _cmsBlog?.content) :const  Center(child:  Text("暂无数据"),),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: InkWell(
                      child:Image.asset('assets/icons/raise_up.png', width: 32, height: 32,),
                      onTap: (){
                        saveUserActive('raiseUp');
                      },
                    ), flex: 1,),
                    Expanded(child: InkWell(
                      child: Image.asset('assets/icons/raise_down.png', width: 32, height: 32,),
                      onTap: (){saveUserActive('raiseDown');},
                    ), flex: 1,)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_cmsBlog?.countView}'),
                    Text('${_cmsBlog?.countRaiseUp}'),
                    Text('${_cmsBlog?.countRaiseDown}')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

}
