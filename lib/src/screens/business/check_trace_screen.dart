
import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/business/CheckTrace.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/agri_util.dart';
import 'package:agri_manager/src/utils/constants.dart';

class CheckTraceScreen extends StatefulWidget {
  final int? userId;
  final int? corpId;
  final int? status;
  const CheckTraceScreen({Key? key, this.userId, this.corpId, this.status}) : super(key: key);

  @override
  State<CheckTraceScreen> createState() => _CheckTraceScreenState();
}

class _CheckTraceScreenState extends State<CheckTraceScreen>{

  List<CheckTrace> listData = [];


  PageModel pageModel = PageModel();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }


  @override
  void initState() {

    super.initState();
  }

  Future loadData() async{
    var params = {'corpId': widget.corpId,'userId': widget.userId,'status': widget.status, 'page': pageModel.page, 'size':pageModel.size};

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
      body: SingleChildScrollView(child: Column(children: <Widget>[
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
        Flexible(
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

                                              },
                                              child: const Text('删除'),
                                            ),
                                            Container(width: 10.0,),
                                            ElevatedButton(
                                              style:  elevateButtonStyle,
                                              onPressed: (){

                                              },
                                              child: const Text('查看'),
                                            ),
                                          ],))
                                    ]))),
                          ))
                    ])
    ));
  }

}