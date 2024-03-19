import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:agri_manager/src/model/business/CheckTrace.dart';
import 'package:agri_manager/src/model/business/FinanceExpense.dart';
import 'package:agri_manager/src/model/business/FinanceExpenseItem.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/business/check_apply_edit_screen.dart';
import 'package:agri_manager/src/screens/business/entity_check_trace_screen.dart';
import 'package:agri_manager/src/screens/document/document_show_screen.dart';
import 'package:agri_manager/src/screens/project/finance_expense_edit_screen.dart';
import 'package:agri_manager/src/shared_components/show_field_text.dart';
import 'package:agri_manager/src/utils/agri_util.dart';
import 'package:agri_manager/src/utils/constants.dart';

class FinanceExpenseViewScreen extends StatefulWidget {
  final int id;
  final CheckTrace? checkTrace;
  const FinanceExpenseViewScreen({Key? key, required this.id, this.checkTrace})
      : super(key: key);

  @override
  State<FinanceExpenseViewScreen> createState() =>
      _FinanceExpenseViewScreenState();
}

class _FinanceExpenseViewScreenState extends State<FinanceExpenseViewScreen> with TickerProviderStateMixin{


  FinanceExpense _financeExpense = FinanceExpense();

  List<FinanceExpenseItem> listExpenseItem = [];


  @override
  void dispose() {

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();

  }

  Future loadData() async {


    if (widget.id != null) {
      try {
        var retData = await DioUtils().request(
            HttpApi.finance_expense_find + widget.id!.toString(), "GET");

        if (retData != null) {
          setState(() {
            _financeExpense = FinanceExpense.fromJson(retData);

          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }

    var paramsBatch = {
      'expenseId': widget.id,
    };

    try {
      var retData = await DioUtils()
          .request(HttpApi.finance_expense_item_findAll, "GET", queryParameters: paramsBatch);
      if (retData != null && retData.length > 0) {
        setState(() {
          listExpenseItem = (retData as List)
              .map((e) => FinanceExpenseItem.fromJson(e))
              .toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  Future deleteData(int id) async {
    try {
      await DioUtils().request('${HttpApi.finance_expense_delete}${id}', "DELETE");
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(
          msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }
  }

  toApply(){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CheckApplyEditScreen(entityId: _financeExpense.id!, entityName:'financeExpense', title:_financeExpense.name! , userId: _financeExpense.createdUserId!)),
    );
  }

  toCheck() async{
    try {
      await DioUtils().request('${HttpApi.check_trace_update_status}', 'POST',
          queryParameters: {'id': widget.checkTrace?.id, 'status': 1},  );

          Navigator.of(context).pop();

    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(
          msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('费用单据查看'),
      ),
      body: SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
        Center(
        child: Container(
            padding: const EdgeInsets.all(defaultPadding),
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        child: Column(
            children: <Widget>[
                ShowFieldText(title: '名称', data: _financeExpense.name ?? ''),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(title: '单据号', data: _financeExpense.code ?? ''),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(
                  title: '费用类型',
                  data: _financeExpense.expenseType ?? ''
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(
                  title: '资金方向',
                  data: _financeExpense.foundDirect == 1 ? '收入': '支出',
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(
                  title: '金额',
                  data: _financeExpense.amount.toString(),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(
                  title: '发生日期',
                  data: _financeExpense.occurAt ?? '',
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(
                  title: '描述',
                  data: _financeExpense.description ?? '',
                  dataLine: 4,
                ),
                const SizedBox(
                  height: kSpacing,
                ),
              ShowFieldText(
                title: '审核状态',
                data: AgriUtil.showCheckStatus(_financeExpense.checkStatus),
                dataLine: 4,
              ),
              const SizedBox(
                height: kSpacing,
              ),
              ShowFieldText(
                title: '状态',
                data: AgriUtil.showCheckStatus(_financeExpense.status),
                dataLine: 4,
              ),
              const SizedBox(
                height: kSpacing,
              ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: elevateButtonStyle,
                      onPressed: null != _financeExpense.checkStatus && _financeExpense.checkStatus == 0 ?  () {
                        toEdit();
                      } : null ,
                      child: const Text('编辑'),
                    ),
                    SizedBox(
                      width: kSpacing,
                    ),
                    ElevatedButton(
                      style: elevateButtonStyle,
                      onPressed: () {
                        confirmDeleteDialog(context, _financeExpense.id!);
                      },
                      child: const Text('删除'),
                    ),
                    SizedBox(
                      width: kSpacing,
                    ),
                   null == widget.checkTrace ? ElevatedButton(
                      style: elevateButtonStyle,
                      onPressed: null != _financeExpense.checkStatus && _financeExpense.checkStatus == 0 ? () {
                         toApply();
                      } : null ,
                      child: const Text('提交审核'),
                    ) : ElevatedButton(
                     style: elevateButtonWarningStyle,
                     onPressed: () {
                        toCheck();
                     },
                     child: const Text('审核'),
                   ),
                  ],
                )]), ),
                ),
                 _tabSection(context),
              ],

        ),
      ),
    );
  }

  toEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FinanceExpenseEditScreen(id: _financeExpense.id)),
    );
  }

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(tabs: [
              Tab(text: "明细"),
              Tab(text: "凭证"),
              Tab(text: "审核记录")
            ]),
          ),
          Container(
            //Add this to give height
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [
              Container(
                child:
                  DataTable2(
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
                      label: Text('产品名称'),
                    ),
                    DataColumn2(
                      size: ColumnSize.S,
                      label: Text('产品SKU'),
                    ),
                    DataColumn2(
                      label: Text('数量'),
                    ),
                    DataColumn2(
                      label: Text('单价'),
                    ),
                    DataColumn2(
                      label: Text('金额'),
                    ),
                    DataColumn2(
                      label: Text('备注'),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                      listExpenseItem.length,
                          (index) => DataRow(cells: [
                        DataCell(Text('${listExpenseItem[index].id}')),
                        DataCell(Text('${listExpenseItem[index].product?.name}')),
                        DataCell(Text('${listExpenseItem[index].productSku}')),
                        DataCell(Text('${listExpenseItem[index].quantity}')),
                        DataCell(Text('${listExpenseItem[index].price}')),
                        DataCell(Text('${listExpenseItem[index].amount}')),
                        DataCell(
                            Text('${listExpenseItem[index].description}'))
                      ])),
                ),
              ),
              Container(
                child: DocumentShowScreen(entityId: widget.id,entityName: 'financeExpense',groupName: '凭证',),
              ),
              Container(
                child: EntityCheckTraceScreen(entityId: widget.id,entityName: 'financeExpense'),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  confirmDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("确定删除"),
          content: const Text("确定要删除该记录吗?，若存在关联数据将无法删除"),
          actions: [
            ElevatedButton(
              style: elevateButtonStyle,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              style: elevateButtonStyle,
              onPressed: () async {
                await deleteData(id);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
