

import 'package:flutter/cupertino.dart';
import 'package:znny_manager/src/model/manage/UserInfo.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/main/components/header.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:sp_util/sp_util.dart';
import 'package:dio/dio.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>{



  UserInfo _userInfo =  UserInfo();

  @override
  void initState() {
    super.initState();

    setState((){
      UserInfo? hisUserInfo = SpUtil.getObj(Constant.USER_INFO, (v) => UserInfo.fromJson(v));

      if(hisUserInfo != null){
        _userInfo = hisUserInfo;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
    child: Column(
    children:  [
       Header(data:_userInfo),
       const SizedBox(height: defaultPadding),
    ]),
    ),);
  }
}