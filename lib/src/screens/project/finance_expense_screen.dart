import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:agri_manager/src/model/business/FinanceExpense.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/screens/project/batch_select_screen.dart';
import 'package:agri_manager/src/screens/project/finance_expense_edit_screen.dart';
import 'package:agri_manager/src/screens/project/finance_expense_view_screen.dart';
import 'package:agri_manager/src/utils/agri_util.dart';
import 'package:agri_manager/src/utils/constants.dart';

class FinanceExpenseScreen extends StatefulWidget {
  final int? batchId;
  final String? batchName;

  const FinanceExpenseScreen({Key? key,  this.batchId, this.batchName})
      : super(key: key);

  @override
  State<FinanceExpenseScreen> createState() => _FinanceExpenseScreenState();
}

class _FinanceExpenseScreenState extends State<FinanceExpenseScreen> {
  List<FinanceExpense> listData = [];

  PageModel pageModel = PageModel();

  final _textBatchName = TextEditingController();
  int? _batchId;

  Corp? curCorp;
  LoginInfoToken userInfo = LoginInfoToken();

  @override
  void dispose() {
    _textBatchName.dispose();
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
  }

  Future loadData() async {

    var params = {'corpId': curCorp?.id, 'batchId': _batchId,'createUserId': userInfo.userId, 'page': pageModel.page, 'size': pageModel.size};

    try {
      var retData = await DioUtils().request(
          HttpApi.finance_expense_query, "GET",
          queryParameters: params);
      if (retData != null) {
        setState(() {
          listData =
              (retData['content'] as List).map((e) => FinanceExpense.fromJson(e)).toList();
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
       appBar: AppBar(
          title: const Text('财务费用'),
        ),
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
                    ),
                    ]
                    )),

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
                          label: Text('阶段'),
                        ),
                        DataColumn2(
                          label: Text('单据类别'),
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
                          label: Text('状态'),
                        ),
                        DataColumn2(
                          label: Text('操作'),
                          fixedWidth: 100,
                        ),
                      ],
                      rows: List<DataRow>.generate(
                          listData.length,
                          (index) => DataRow(cells: [
                                DataCell(Text('${listData[index].id}')),
                                DataCell(Text('${listData[index].name}')),
                                DataCell(Text('${listData[index].code}')),
                               DataCell(Text('${listData[index].cycleName}')),
                                DataCell(Text(listData[index].foundDirect == -1
                                    ? '支出'
                                    : '收入')),
                                DataCell(Text('${listData[index].amount}')),
                            DataCell(
                                Text('${listData[index].occurAt}')),
                                DataCell(
                                    Text('${listData[index].description}')),
                        DataCell(
                          Text(AgriUtil.showCheckStatus(listData[index].checkStatus))),
                            DataCell(
                                Text(AgriUtil.showOrderStatus(listData[index].status))),
                          DataCell(Row(
                                  children: [
                                    Expanded(child:
                                    ElevatedButton(
                                      style: elevateButtonStyle,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FinanceExpenseEditScreen(
                                                      id: listData[index].id)),
                                        );
                                      },
                                      child: const Text('编辑'),
                                    ), flex:2),
                                    Expanded(child:
                                    ElevatedButton(
                                      style: elevateButtonStyle,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FinanceExpenseViewScreen(
                                                      id: listData[index].id!)),
                                        );
                                      },
                                      child: const Text('查看'),
                                    ), flex:2),
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
              const FinanceExpenseEditScreen()),
    );
  }
}
