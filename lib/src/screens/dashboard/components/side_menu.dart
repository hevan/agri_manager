import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/sys/sys_menu.dart';
import 'package:agri_manager/src/settings/settings_view.dart';
import 'package:agri_manager/src/utils/constants.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
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
      'name': '管理',
      'path': '/managerDashboard',
      'iconUrl':'assets/icons/menu/icon_corp_manage.png',
      'parentId': null,
      'corpId': 1,
      'children': []
    },
    {
      'id': 5,
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
    return
      Container(
    child: SingleChildScrollView(
    child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(kSpacing),
            child: Image.asset("assets/images/flutter_logo.png", fit: BoxFit.cover, width: 200, height: 100,),
          ),
          const Divider(thickness: 1),
           ListView.builder(
            itemCount: listMenu.length,
            shrinkWrap: true,
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
                  )
              );
            },
          ),
        ],
    )));
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

