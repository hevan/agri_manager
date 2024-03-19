import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:agri_manager/src/model/business/PurchaseOrder.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/screens/business/purchase_order_edit_screen.dart';
import 'package:agri_manager/src/screens/business/purchase_order_view_screen.dart';
import 'package:agri_manager/src/screens/project/batch_select_screen.dart';
import 'package:agri_manager/src/utils/agri_util.dart';
import 'package:agri_manager/src/utils/constants.dart';

class PurchaseOrderScreen extends StatefulWidget {
  final int? batchId;
  final String? batchName;

  const PurchaseOrderScreen({Key? key,  this.batchId, this.batchName})
      : super(key: key);

  @override
  State<PurchaseOrderScreen> createState() => _PurchaseOrderScreenState();
}

class _PurchaseOrderScreenState extends State<PurchaseOrderScreen> {
  List<PurchaseOrder> listData = [];

  final _textBatchName = TextEditingController();
  PageModel pageModel = PageModel();

  int? _batchId;

  Corp? curCorp;
  LoginInfoToken userInfo = LoginInfoToken();

  @override
  void dispose() {
    _textBatchName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });

    if(null != widget.batchId){
      setState(() {
        _batchId = widget.batchId;
        _textBatchName.text = widget.batchName!;
      });
    }

    loadData();
  }

  Future loadData() async {
    var params = {
      'corpId': curCorp?.id,
      'batchId': _batchId,
      'page': pageModel.page,
      'size': pageModel.size,
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.purchase_order_query, "GET",
          queryParameters: params);
      if (retData != null) {
        setState(() {
          listData =
              (retData['content'] as List).map((e) => PurchaseOrder.fromJson(e)).toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("采购订单"),),
        body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                  child: Column(children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        maxWidth: 500,
                      ),
                      child: Column(children: [
                        const SizedBox(height: kSpacing,),
                        TextField(
                          controller: _textBatchName,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: '选择项目',
                            hintText: '项目',
                            suffixIcon: IconButton(
                              onPressed: () async {
                                String retData = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const BatchProductSelectScreen(),
                                        fullscreenDialog: true)
                                );
                                if(retData != null) {
                                  // ignore: curly_braces_in_flow_control_structures
                                  setState(() {
                                    var retDataMap = json.decode(retData);
                                    _batchId = retDataMap['id'];
                                    _textBatchName.text = retDataMap['name'] ?? '';
                                  });
                                }

                              },
                              icon: const Icon(Icons.search_sharp),
                            ),
                          ),
                        ),]),),
                Container(
                  // A fixed-height child.
                  height: 80.0,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: elevateButtonStyle,
                        onPressed: () {
                          loadData();
                        },
                        child: const Text('查询'),
                      ),
                      Container(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: elevateButtonStyle,
                        onPressed: toAdd,
                        child: const Text('增加'),
                      )
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
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
                          label: Text('名称'),
                        ),
                        DataColumn2(
                          label: Text('单据号'),
                        ),
                        DataColumn2(
                          label: Text('数量'),
                        ),
                        DataColumn2(
                          label: Text('金额'),
                        ),
                        DataColumn2(
                          label: Text('发生日期'),
                        ),
                        DataColumn2(
                          label: Text('备注'),
                        ),
                        DataColumn2(
                          label: Text('审核状态'),
                        ),
                        DataColumn2(
                          label: Text('单据状态'),
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
                                DataCell(Text('${listData[index].name}')),
                                DataCell(Text('${listData[index].code}')),
                               DataCell(Text('${listData[index].quantity}')),
                                DataCell(Text('${listData[index].amount}')),
                            DataCell(
                                Text('${listData[index].occurAt}')),
                                DataCell(
                                    Text('${listData[index].description}')),
                            DataCell(Text(AgriUtil.showCheckStatus(listData[index].checkStatus))),
                            DataCell(Text(AgriUtil.showOrderStatus(listData[index].status))),
                            DataCell(Row(
                                  children: [
                                    ElevatedButton(
                                      style: elevateButtonStyle,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PurchaseOrderEditScreen(
                                                      id: listData[index].id,
                                                      batchId: widget.batchId)),
                                        );
                                      },
                                      child: const Text('编辑'),
                                    ),
                                    Container(
                                      width: 10.0,
                                    ),

                                    ElevatedButton(
                                      style: elevateButtonStyle,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PurchaseOrderViewScreen(
                                                      id: listData[index].id!)),
                                        );
                                      },
                                      child: const Text('查看'),
                                    ),
                                  ],
                                ))
                              ]))),
                ))
              ]))));
    }));
  }

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PurchaseOrderEditScreen(batchId: widget.batchId)),
    );
  }
}
