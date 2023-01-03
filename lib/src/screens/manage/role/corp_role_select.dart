
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:znny_manager/src/model/manage/CorpRole.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';

class CorpRoleSelect extends StatefulWidget {
  final List<CorpRole> userRoles;
  const CorpRoleSelect({Key? key, required this.userRoles}) : super(key: key);

  @override
  State<CorpRoleSelect> createState() => _CorpRoleSelectState();
}

class _CorpRoleSelectState extends State<CorpRoleSelect>{

  List<CorpRole> listData = [];

  List<CorpRole> listSelected = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {

    super.initState();

    if(widget.userRoles.isNotEmpty){
      listSelected = widget.userRoles;
    }

    loadData();
  }

  Future loadData() async{
    var params = {'corpId': HttpApi.corpId };

    try {
      var retData = await DioUtils().request(
          HttpApi.role_findAll, "GET", queryParameters: params);
      if(retData != null) {
        setState(() {
          listData = (retData as List).map((e) => CorpRole.fromJson(e)).toList();
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
                              onPressed:toSelect,
                              child: const Text('确定选择'),
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
                                  )
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
                                          Text('${listData[index].name}'))
                                    ]))),
                          ))
                    ]))));
      })
    );
  }

  toSelect(){
    if(listSelected.isNotEmpty) {
      Navigator.of(context).pop(jsonEncode(listSelected));
    }else{
      Fluttertoast.showToast(msg: '请选择角色',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
    }
  }
}