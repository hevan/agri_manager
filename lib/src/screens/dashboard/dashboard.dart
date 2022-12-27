

import 'package:flutter/cupertino.dart';
import 'package:sp_util/sp_util.dart';
import 'package:znny_manager/src/model/sys/LoginInfoToken.dart';
import 'package:znny_manager/src/screens/main/components/header.dart';
import 'package:znny_manager/src/utils/agri_util.dart';
import 'package:znny_manager/src/utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>{



  LoginInfoToken userInfo =  LoginInfoToken();

  @override
  void initState() {
    super.initState();

    setState((){
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));

      if(null != userInfo.expiration){
        AgriUtil.checkToken(userInfo, context);
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
       Header(data:userInfo),
       const SizedBox(height: defaultPadding),
    ]),
    ),);
  }
}