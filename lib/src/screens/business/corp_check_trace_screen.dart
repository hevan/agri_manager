
import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/business/CheckTrace.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/utils/agri_util.dart';
import 'package:agri_manager/src/utils/constants.dart';

class CorpCheckTraceScreen extends StatefulWidget {
  final bool isShowBar;
  final int? status;
  const CorpCheckTraceScreen({Key? key, this.isShowBar = true, this.status}) : super(key: key);

  @override
  State<CorpCheckTraceScreen> createState() => _CorpCheckTraceScreenState();
}

class _CorpCheckTraceScreenState extends State<CorpCheckTraceScreen>{

  List<CheckTrace> listData = [];

  PageModel pageModel = PageModel();

  Corp? curCorp;
  LoginInfoToken userInfo = LoginInfoToken();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {

    super.initState();

    setState(() {
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });

    loadData();
  }

  Future loadData() async{
    var params = {'corpId': curCorp?.id,'userId': userInfo.userId, 'status': widget.status, 'page': pageModel.page, 'size':pageModel.size};


    try {
      var retData = await DioUtils().request(
          HttpApi.check_trace_query, "GET", queryParameters: params);
      if(retData != null && null != retData['content']) {
        setState(() {
          listData = (retData['content'] as List).map((e) => CheckTrace.fromJson(e)).toList();
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
        appBar: widget.isShowBar ? AppBar(title: const Text('待审核')) : null,
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
                                    size: ColumnSize.S,
                                    label: Text('单据类型'),
                                  ),
                                  DataColumn2(
                                    size: ColumnSize.S,
                                    label: Text('名称'),
                                  ),
                                  DataColumn2(
                                    size: ColumnSize.S,
                                    label: Text('描述'),
                                  ),
                                  DataColumn2(
                                    size: ColumnSize.S,
                                    label: Text('状态'),
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
                                              Text(AgriUtil.showOrderType(listData[index].entityName!))),
                                          DataCell(
                                              Text('${listData[index].title}')),
                                      DataCell(
                                          Text('${listData[index].description}')),
                                          DataCell(
                                              Text(AgriUtil.showCheckTraceStatus(listData[index].status))),
                                      DataCell(
                                          Row(children: [
                                            ElevatedButton(
                                              style:  elevateButtonStyle,
                                              onPressed: (){
                                                AgriUtil.toCheckView(context, entityId: listData[index].entityId!, entityName: listData[index].entityName!, checkTrace: listData[index]);
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

}