
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:znny_manager/src/controller/menu_controller.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/dashboard/dashboard.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sp_util/sp_util.dart';
import 'package:dio/dio.dart';


import '../responsive.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {

  int? _userId;
  @override
  void initState(){
    super.initState();
    initializeDateFormatting('zh_CN');
    setState((){
      _userId = SpUtil.getInt(Constant.userId);
    });

    loadData();
  }

  Future loadData() async{
    if(_userId != null){
      try {
        var retData = await DioUtils().request('${HttpApi.user_find}$_userId', "GET");

        if(retData != null) {
          SpUtil.putObject(Constant.USER_INFO, retData);
        }
      } on DioError catch (error) {
        CustomAppException customAppException = CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer:  (Responsive.isDesktop(context))
          ? null : const  Drawer(
        child: Padding(
          padding:  EdgeInsets.only(top: kSpacing),
          child:  SideMenu(),
        ),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
               Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                 flex: 1,
                child:  Container(
                    color: Colors.blueAccent,
                    child: const SideMenu()),
              ),
            const Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
