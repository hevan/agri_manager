import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:znny_manager/src/model/sys/sys_menu.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/settings/settings_view.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends  State<SideMenu>{

  int selectedIndex = 0;
  final List<Map<String, dynamic>> listMenu = [
    {
      'id': 1,
      'name': '首页',
      'path': '/home',
      'iconUrl':'assets/icons/icon_home.png',
      'parentId': null,
      'corpId': 1,
      'children': []
    },
    {
      'id': 2,
      'name': '资讯',
      'path': '/news',
      'iconUrl':'assets/icons/icon_news.png',
      'parentId': null,
      'corpId': 1,
      'children': []
    },
    {
      'id': 3,
      'name': '市场',
      'path': '/market',
      'iconUrl':'assets/icons/icon_market.png',
      'parentId': null,
      'corpId': 1,
      'children': []
    },
    {
      'id': 4,
      'name': '设置',
      'path': '/setting',
      'iconUrl':'assets/icons/icon_setting.png',
      'parentId': null,
      'corpId': 1,
      'children': []
    }
  ];
  Map<String, dynamic>? selectedMenu;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  /*
  Future loadData() async{
    try {
      var params = {'corpId': HttpApi.corpId.toString()};
      var resData = await DioUtils().request(
          HttpApi.sys_menu_findAll, "GET", queryParameters: params);
      debugPrint(jsonEncode(resData));
      if (resData != null) {
        debugPrint('---srat---');
        List<SysMenu> retList =( resData as List ) .map((e) => SysMenu.fromJson(e)).toList();
        debugPrint(jsonEncode(retList));
        for(int i=0;i<retList.length;i++){
          SysMenu curMenu = retList[i];
          debugPrint('---for---');
          if(curMenu.parentId == null){
            debugPrint('---add---');
            listMenu.add(curMenu);
          }else{
            for(int s=0;s<listMenu.length;s++){
              debugPrint('---insert Parent---');
              SysMenu pMenu = listMenu[s];
              if(pMenu.id == curMenu.parentId){
                 pMenu.addChild(curMenu);
                 debugPrint('---insert Parent1---');
                 break;
              }
            }
          }
        }
      }
      debugPrint('---end---');
      setState(() {

      });

    } on DioError catch(error){
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }
   */

  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    return Drawer(
      child:
      Column(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/flutter_logo.png"),
          ),
          Expanded( child: ListView.builder(
            itemCount: listMenu.length,
            itemBuilder: (BuildContext context, int index) {
              //  if(index==0) return controlTile();
              Map<String, dynamic> mainMenu = listMenu[index];
              bool selected = (null != selectedMenu && selectedMenu!['id']  == mainMenu['id']) ? true : false;
              return ListTile(
                  onTap:(){
                    Navigator.pushNamed(
                      context,
                      mainMenu['path'],
                    );
                  },
                  leading: Image.asset(mainMenu['iconUrl']!,height: 32,width: 32,),
                  title: Text(
                   '${mainMenu['name']}',
                  ),
                  trailing: mainMenu['children']!.isEmpty? null :
                  Icon(selected?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                    color: Colors.blueAccent,
                  ),
              );
            },
          ),

          )
        ],
      ),
    );
  }

  toSettingPage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsView()),
    );
  }

  List<Widget> _buildSubMenu(SysMenu subMenu){

    if(null == subMenu.children  || subMenu.children!.isEmpty){
      return <Widget>[];
    }else{

      return subMenu.children!.map((e) => InkWell(
        onTap: (){
          Navigator.pushNamed(context, e.path!);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${e.name}',
            style: const TextStyle(
              fontSize:  14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )).toList();
    }
  }

}

