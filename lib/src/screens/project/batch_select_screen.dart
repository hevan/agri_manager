import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/ConstType.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/model/project/BatchProduct.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';

class BatchProductSelectScreen extends StatefulWidget {
  const BatchProductSelectScreen({Key? key}) : super(key: key);

  @override
  State<BatchProductSelectScreen> createState() => _BatchProductSelectScreenState();
}

class _BatchProductSelectScreenState extends State<BatchProductSelectScreen> {

  List<BatchProduct> listProductBatch = [];

  PageModel pageModel = PageModel();
  Corp? curCorp;

  int? selectedIndex = 0;

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();

    Map? mapCorpSelect = SpUtil.getObject(Constant.currentCorp);

    debugPrint(json.encode(mapCorpSelect));
    if (null != mapCorpSelect && mapCorpSelect.isNotEmpty) {
      setState(() {
        curCorp = Corp.fromJson(mapCorpSelect);
      });
    }

  }
  Future loadData() async {
    var params = {'corpId': curCorp?.id, 'page': pageModel.page, 'size': pageModel.size};

    try {
      var retData = await DioUtils().request(
          HttpApi.batch_query, "GET", queryParameters: params);
      if(retData != null && retData['content'].length > 0) {
        setState(() {
          listProductBatch =
              (retData['content'] as List).map((e) => BatchProduct.fromJson(e)).toList();
        });
      }
    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('项目选择'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('选择')),
          ],
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
                              size: ColumnSize.S,
                              label: Text('编号'),
                            ),
                            DataColumn2(
                              label: Text('名称'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('产品名'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('种植面积'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('开始日期'),
                            ),

                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('状态'),
                            )
                          ],
                          rows: List<DataRow>.generate(
                              listProductBatch.length,
                              (index) => DataRow(
                                  selected: index == selectedIndex,
                                  onSelectChanged: (val) {
                                    setState(() {
                                      selectedIndex = index;

                                      String jsonStr = json.encode({
                                        'id': listProductBatch[index].id,
                                        'name': listProductBatch[index].name
                                      });
                                      Navigator.of(context).pop(jsonStr);
                                    });
                                  },
                                  cells: [
                                    DataCell(Text('${listProductBatch[index].id}')),
                                DataCell(
                                    Text('${listProductBatch[index].code}')),
                                    DataCell(
                                        Text('${listProductBatch[index].name}')),
                                DataCell(
                                    Text('${listProductBatch[index].product?.name}')),
                                DataCell(
                                    Text('${listProductBatch[index].area}')),
                                DataCell(
                                    Text('${listProductBatch[index].startAt}')),

                                DataCell(
                                    Text(ConstType.getTaskStatus(listProductBatch[index].status))),

                                  ]))),
                    ))
                  ]))));
        }));
  }
}
