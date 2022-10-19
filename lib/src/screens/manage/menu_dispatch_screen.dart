
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:znny_manager/src/model/manage/CorpRoleMenu.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:znny_manager/src/model/sys/sys_menu.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/manage/menu_edit_screen.dart';
import 'package:znny_manager/src/utils/constants.dart';

class MenuDispatchScreen extends StatefulWidget {
  final int roleId;
  const MenuDispatchScreen({Key? key, required this.roleId}) : super(key: key);

  @override
  State<MenuDispatchScreen> createState() => _MenuDispatchScreenState();
}

class _MenuDispatchScreenState extends State<MenuDispatchScreen>{

  List<SysMenu> listData = [];

  List<SysMenu> listSelected = [];

  List<CorpRoleMenu> listRoleMenu = [];


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {

    super.initState();

    loadData();
  }

  Future loadData() async{
    var params = {'corpId': HttpApi.corpId };

    try {
      var retData = await DioUtils().request(
          HttpApi.sys_menu_findAll, "GET", queryParameters: params);
      if(retData != null) {
        setState(() {
          listData = (retData as List).map((e) => SysMenu.fromJson(e)).toList();
        });
      }
    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
    var paramsRole = {'roleId': widget.roleId };
    try {
      var retDataRole = await DioUtils().request(
          HttpApi.role_menu_findAll, "GET", queryParameters: paramsRole);
      if(retDataRole != null) {
        setState(() {
          listRoleMenu = (retDataRole as List).map((e) => CorpRoleMenu.fromJson(e)).toList();
          for(int m=0; m<listRoleMenu.length;m++){
            for(int n=0;n<listData.length;n++){
              if(listRoleMenu[m].menuId == listData[n].id){
                listSelected.add(listData[n]);
              }
            }
          }

        });
      }
    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        appBar: AppBar(
          title: const Text('功能菜单管理'),
        ),
      body: LayoutBuilder(builder:
          (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                    child: Column(children: <Widget>[
                      Container(
                        // A fixed-height child.
                        height: 80.0,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style:  elevateButtonStyle,
                              onPressed: (){
                                loadData();
                              },
                              child: const Text('查询'),
                            ),
                            Container(width: 20,),
                            ElevatedButton(
                              style:  elevateButtonStyle,
                              onPressed:toAdd,
                              child: const Text('增加'),
                            ),
                            Container(width: 20,),
                            ElevatedButton(
                              style:  elevateButtonStyle,
                              onPressed:toDispatch,
                              child: const Text('确定分配'),
                            )
                          ],
                        ),
                      ),
                      const Divider(height: 1,),
                      Expanded(
                        // A flexible child that will grow to fit the viewport but
                        // still be at least as big as necessary to fit its contents.
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            height: 300,
                            child: DataTable2(
                                columnSpacing: 12,
                                horizontalMargin: 12,
                                minWidth: 600,
                                smRatio: 0.75,
                                lmRatio: 1.5,
                                columns: const [
                                  DataColumn2(
                                    size: ColumnSize.S,
                                    label: Text('id'),
                                  ),

                                  DataColumn2(
                                    label: Text('名称'),
                                  ),
                                  DataColumn2(
                                    size: ColumnSize.S,
                                    label: Text('图标'),
                                  ),
                                  DataColumn2(
                                    size: ColumnSize.S,
                                    label: Text('路径'),
                                  ),
                                  DataColumn2(
                                    size: ColumnSize.S,
                                    label: Text('上级ID'),
                                  ),
                                  DataColumn2(
                                    size: ColumnSize.L,
                                    label: Text('操作'),
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                    listData.length,
                                        (index) => DataRow(
                                            selected: listSelected.contains(listData[index]),
                                            onSelectChanged: (isSelected) {
                                              setState(() {
                                                final isAdding = isSelected != null && isSelected;

                                                isAdding
                                                    ? listSelected.add(listData[index])
                                                    : listSelected.remove(listData[index]);
                                              });
                                            },
                                            cells: [
                                      DataCell(Text('${listData[index].id}')),

                                      DataCell(
                                          Text('${listData[index].name}')),
                                      DataCell(
                                          Text('${listData[index].iconUrl}')),
                                          DataCell(
                                              Text('${listData[index].path}')),
                                          DataCell(
                                              Text('${listData[index].parentId}')),
                                      DataCell(
                                          Row(children: [
                                            ElevatedButton(
                                              style:  elevateButtonStyle,
                                              onPressed: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>  MenuEditScreen(id: listData[index].id)),
                                                );
                                              },
                                              child: const Text('编辑'),
                                            ),

                                            Container(width: 10.0,),
                                            ElevatedButton(
                                              style:  elevateButtonStyle,
                                              onPressed: (){
                                                toDelete(listData[index].id!);
                                              },
                                              child: const Text('删除'),
                                            ),
                                            Container(width: 10.0,),
                                            ElevatedButton(
                                              style:  elevateButtonStyle,
                                              onPressed: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>  MenuEditScreen(id: listData[index].id)),
                                                );
                                              },
                                              child: const Text('查看'),
                                            ),
                                          ],))
                                    ]))),
                          ))
                    ]))));
      })
    );
  }

  toAdd(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  const MenuEditScreen()),
    );
  }

  Future toDelete(int curId) async {
    try {
      var retData = await DioUtils().request(
          '${HttpApi.sys_menu_delete}$curId', "DELETE");

      loadData();
    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  Future toDispatch() async{
    List<CorpRoleMenu> listAdd = [];
    for(int m=0; m<listSelected.length;m++){
      CorpRoleMenu curTemp = CorpRoleMenu(roleId: widget.roleId, menuId: listSelected[m].id);
      listAdd.add(curTemp);
    }

    if(listAdd.isNotEmpty){
      try {
        var retData = await DioUtils().request(
            '${HttpApi.role_menu_add_all}/${widget.roleId}', "POST", data: json.encode(listAdd.map((v) => v.toJson()).toList()),isJson: true);
        if(retData != null){
          Fluttertoast.showToast(msg: '分配成功');
        }
      } on DioError catch(error) {
        CustomAppException customAppException = CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }
  }
}