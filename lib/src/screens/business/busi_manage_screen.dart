import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/sys/sys_menu.dart';
import 'package:znny_manager/src/utils/constants.dart';

class BusiManageScreen extends StatefulWidget {
  const BusiManageScreen({ Key? key }) : super(key: key);

  @override
  _BusiManageScreenState createState() => _BusiManageScreenState();
}

class _BusiManageScreenState extends State<BusiManageScreen> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('业务管理'),
     ),
     body: body(),
     drawer: const ComplexDrawer()
  );
  }

  Widget body(){
    return Center(
      child:  Container(
         padding: const EdgeInsets.all(10),
        child: const FlutterLogo(
         size: 150,
     ),
      ),
    );
  }
}


class ComplexDrawer extends StatefulWidget {
  const ComplexDrawer({ Key? key }) : super(key: key);

  @override
  _ComplexDrawerState createState() => _ComplexDrawerState();
}

class _ComplexDrawerState extends State<ComplexDrawer> {

  int selectedIndex = -1;//dont set it to 0

  bool isExpanded = false;


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: row(),
      color: compexDrawerCanvasColor,
    );
  }

  Widget row(){
    return Row(
      children: [
         isExpanded? blackIconTiles():blackIconMenu(),
        invisibleSubMenus(),
      ]
    );
  }

  Widget blackIconTiles(){
    return Container(
      width: 200,
      color: complexDrawerBlack,
      child: Column(
        children: [
          controlTile(),
          Expanded(            child: ListView.builder(
              itemCount: cdms.length,
              itemBuilder: (BuildContext context, int index) {
            //  if(index==0) return controlTile();
               
               
              SysMenu cdm = cdms[index];
              bool selected = selectedIndex == index;
               return ExpansionTile(
                 onExpansionChanged:(z){
                   setState(() {
                     selectedIndex = z?index:-1;
                   });
                 },
               leading:  Image.asset(cdm.iconUrl!),
                title: Text(
                  cdm.name!,
                ),
                trailing: cdm.children!.isEmpty? null : Icon(selected?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                children: cdm.children!.map((subMenu){
                  return sMenuButton(subMenu, false);
                }).toList()
              );
             },
            ),
          ),
          accountTile(),
        ],
      ),
    );
  }


  Widget controlTile(){
    return Padding(
      padding: const EdgeInsets.only(top:20,bottom: 30),
      child: ListTile(
        leading: const FlutterLogo(),
        title: const Text(
           "FlutterShip"
        ),
        onTap: expandOrShrinkDrawer,
      ),
    );
  }

  Widget blackIconMenu(){
    return AnimatedContainer(
      duration: const Duration(seconds:1),
      width: 100,
      child: Column(
        children: [
          controlButton(),
          Expanded(
            child: ListView.builder(
              itemCount: cdms.length,
              itemBuilder: (content, index){
                  // if(index==0) return controlButton();
                return InkWell(
                  onTap: (){
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    child: Image.asset(cdms[index].iconUrl!),
                  ),
                );
              }
            ),
          ),
          accountButton(),
        ],
      ),
    );
  }

  Widget invisibleSubMenus(){
    // List<CDM> _cmds = cdms..removeAt(0);
    return AnimatedContainer(
      duration: const Duration(milliseconds:500),
      width: isExpanded? 0:125,
      child: Column(
        children: [
          Container(height:95),
          Expanded(
            child: ListView.builder(
              itemCount: cdms.length,
              itemBuilder: (context, index){  
                SysMenu cmd = cdms[index];
                // if(index==0) return Container(height:95);  
                //controll button has 45 h + 20 top + 30 bottom = 95    
          
                bool selected = selectedIndex==index;
                bool isValidSubMenu = selected && cmd.children!.isNotEmpty;
                return subMenuWidget(cmd.name!,cmd.children!, isValidSubMenu);
              }
            ),
          ),
        ],
      ),
    );
  }


  Widget controlButton(){
    return Padding(
      padding: const EdgeInsets.only(top:20,bottom: 30),
      child: InkWell(
        onTap: expandOrShrinkDrawer,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          child: const FlutterLogo(
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget subMenuWidget(String title, List<SysMenu> submenus, bool isValidSubMenu){
     return AnimatedContainer(
       duration: const Duration(milliseconds:500),
       height: isValidSubMenu? submenus.length.toDouble() *37.5 : 45,
       alignment: Alignment.center,
       decoration: BoxDecoration(
         color:isValidSubMenu? complexDrawerBlueGrey:
         Colors.transparent,
         borderRadius: const BorderRadius.only(
           topRight: Radius.circular(8),
           bottomRight:  Radius.circular(8),
         )
       ),
       child: ListView.builder(
         padding: const EdgeInsets.all(6),
                itemCount: isValidSubMenu? submenus.length:0,
                itemBuilder: (context,index){
                  SysMenu subMenu = submenus[index];
                  return sMenuButton(subMenu,index==0);
                }
              ),
     );
  }


  Widget sMenuButton(SysMenu subMenu,bool isTitle){
    return InkWell(
                    onTap: (){
                      //handle the function
                      //if index==0? donothing: doyourlogic here
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                       subMenu.name!
                      ),
                    ),
                  );
  }


  Widget accountButton({bool usePadding = true}){
    return Padding(
      padding: EdgeInsets.all(usePadding?8:0),
      child: AnimatedContainer(
        duration: const Duration(seconds:1),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget accountTile(){
    return Container(
      color: complexDrawerBlueGrey,
      child: ListTile(
        leading: accountButton(usePadding: false),
        title: const Text(
          "Prem Shanhi"
        ),
        subtitle: const Text(
        "Web Designer"
        ),
      ),
    );
  }



    // CDM(Icons.grid_view, "Control", []),
    static List<Map<String, dynamic>> listMenus = [{
      "id": 1,
      "name": "产品管理",
      "path": "/product",
      "iconUrl": "assets/icons/icon_person.png",
      "parentId": 0,
      "children": [{
        "id": 2,
        "name": "分类管理",
        "path": "/product/category",
        "iconUrl": "assets/icons/icon_person.png",
        "parentId": 1,
        "children": []
      },
        {
          "id": 3,
          "name": "产品管理",
          "path": "/product/product",
          "iconUrl": "assets/icons/icon_person.png",
          "parentId": 1,
          "children": []
        },
        {
          "id": 4,
          "name": "生产数据",
          "path": "/product/cycle",
          "iconUrl": "assets/icons/icon_person.png",
          "parentId": 1,
          "children": []
        },
        {
          "id": 5,
          "name": "市场数据",
          "path": "/product/market",
          "iconUrl": "assets/icons/icon_person.png",
          "parentId": 1,
          "children": []
        }
      ]
    },
      {
        "id": 6,
        "name": "客户管理",
        "path": "/customer",
        "iconUrl": "assets/icons/icon_person.png",
        "parentId": null,
        "children": [{
          "id": 7,
          "name": "客户管理",
          "path": "/customer/customer",
          "iconUrl": "assets/icons/icon_person.png",
          "parentId": 6,
          "children": []
        },
          {
            "id": 8,
            "name": "专家管理",
            "path": "/customer/expert",
            "iconUrl": "assets/icons/icon_person.png",
            "parentId": 6,
            "children": []
          }
        ]
      }
    ];

    // ignore: prefer_function_declarations_over_variables
    List<SysMenu> cdms = readSysMenu();

    static List<SysMenu> readSysMenu(){
      return listMenus.map((v) => SysMenu.fromJson(v)).toList();
    }

   void expandOrShrinkDrawer(){
     setState(() {
       isExpanded = !isExpanded;
     });
   }


}