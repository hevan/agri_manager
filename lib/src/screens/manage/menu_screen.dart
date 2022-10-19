
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:znny_manager/src/model/manage/UserInfo.dart';
import 'package:znny_manager/src/model/sys/sys_menu.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/manage/menu_edit_screen.dart';
import 'package:znny_manager/src/utils/constants.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>{

  List<SysMenu> listData = [];

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
                                        (index) => DataRow(cells: [
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
}