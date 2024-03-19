import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/business/CheckTrace.dart';
import 'package:agri_manager/src/model/business/SaleOrder.dart';
import 'package:agri_manager/src/model/business/SaleOrderItem.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/business/check_apply_edit_screen.dart';
import 'package:agri_manager/src/screens/business/entity_check_trace_screen.dart';
import 'package:agri_manager/src/screens/business/sale_order_edit_screen.dart';
import 'package:agri_manager/src/screens/document/document_show_screen.dart';
import 'package:agri_manager/src/shared_components/show_field_text.dart';
import 'package:agri_manager/src/utils/agri_util.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:data_table_2/data_table_2.dart';

class SaleOrderViewScreen extends StatefulWidget {
  final int id;
  final CheckTrace? checkTrace;
  const SaleOrderViewScreen({Key? key, required this.id, this.checkTrace})
      : super(key: key);

  @override
  State<SaleOrderViewScreen> createState() =>
      _SaleOrderViewScreenState();
}

class _SaleOrderViewScreenState extends State<SaleOrderViewScreen> with TickerProviderStateMixin{


  SaleOrder _saleOrder = SaleOrder();

  List<SaleOrderItem> listItem = [];

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
    debugPrint('-------------------check trace ------------------');
    debugPrint(jsonEncode(widget.checkTrace));

    if (widget.id != null) {
      try {
        var retData = await DioUtils().request(
            HttpApi.sale_order_find + widget.id.toString(), "GET");

        if (retData != null) {
          setState(() {
            _saleOrder = SaleOrder.fromJson(retData);

          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }

      var paramsBatch = {
        'orderId': widget.id,
      };

      try {
        var retData = await DioUtils()
            .request(HttpApi.sale_order_item_findAll, "GET", queryParameters: paramsBatch);
        if (retData != null && retData.length > 0) {
          setState(() {
            listItem = (retData as List)
                .map((e) => SaleOrderItem.fromJson(e))
                .toList();
          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException = CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }

    var paramsBatch = {
      'orderId': widget.id,
    };

    try {
      var retData = await DioUtils()
          .request(HttpApi.sale_order_item_findAll, "GET", queryParameters: paramsBatch);
      if (retData != null && retData.length > 0) {
        setState(() {
          listItem = (retData as List)
              .map((e) => SaleOrderItem.fromJson(e))
              .toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  Future deleteData(int id) async {

    if(_saleOrder.status! > 0){
      Fluttertoast.showToast(
          msg: '当前记录已提交审核或已审核不能删除！',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
      return;
    }
    try {
      await DioUtils().request('${HttpApi.sale_order_delete}${id}', "DELETE");
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
          builder: (context) => CheckApplyEditScreen(entityId: _saleOrder.id!, entityName:'saleOrder', title:_saleOrder.name! , userId: _saleOrder.createdUserId!)),
    );
  }

  toCheck() async{
    try {
      await DioUtils().request('${HttpApi.check_trace_update_status}', 'POST',
          queryParameters: {'id': widget.checkTrace?.id, 'status': 1}, );

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
        title: const Text('单据查看'),
      ),
      body: SingleChildScrollView(
        child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
            Center(
            child: Container(
                padding: const EdgeInsets.all(defaultPadding),
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),child: Column(
        children: <Widget> [
                ShowFieldText(title: '名称', data: _saleOrder.name ?? ''),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(title: '单据号', data: _saleOrder.code ?? ''),
                const SizedBox(
                  height: kSpacing,
                ),
          ShowFieldText(title: '客户', data: _saleOrder.customer?.name ?? ''),
          const SizedBox(
            height: kSpacing,
          ),
                ShowFieldText(
                  title: '数量',
                  data: _saleOrder.quantity.toString(),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(
                  title: '金额',
                  data: _saleOrder.amount.toString(),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(
                  title: '发生日期',
                  data: _saleOrder.occurAt ?? '',
                ),
                const SizedBox(
                  height: kSpacing,
                ),
          ShowFieldText(
            title: '审核状态',
            data: AgriUtil.showCheckStatus(_saleOrder.checkStatus)
          ),
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(
              title: '状态',
              data: AgriUtil.showOrderStatus(_saleOrder.status)
          ),
          const SizedBox(
            height: kSpacing,
          ),
                ShowFieldText(
                  title: '描述',
                  data: _saleOrder.description ?? '',
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
                      onPressed: () {
                        toEdit();
                      },
                      child: const Text('编辑'),
                    ),
                    SizedBox(
                      width: kSpacing,
                    ),
                    ElevatedButton(
                      style: elevateButtonStyle,
                      onPressed: null != _saleOrder.checkStatus && _saleOrder.checkStatus! < 1 ?  () {
                        confirmDeleteDialog(context, _saleOrder.id!);
                      } : null,
                      child: const Text('删除'),
                    ),
                    SizedBox(
                      width: kSpacing,
                    ),
                    null == widget.checkTrace ? ElevatedButton(
                      style: elevateButtonStyle,
                      onPressed: null != _saleOrder.checkStatus && _saleOrder.checkStatus == 0 ? () {
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
                ),

              ],
            ),
          ),
        ),
    _tabSection(context),
    ]
      ),
    ));
  }

  toEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SaleOrderEditScreen(id: _saleOrder.id, batchId: _saleOrder.batchId!,)),
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
              Tab(text: "费用明细"),
              Tab(text: "费用凭证"),
              Tab(text: "审核记录")
            ]),
          ),
          Container(
            //Add this to give height
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [
              Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  height: 600,
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
                        listItem.length,
                            (index) => DataRow(cells: [
                          DataCell(Text('${listItem[index].id}')),
                          DataCell(Text('${listItem[index].product?.name}')),
                          DataCell(Text('${listItem[index].productSku}')),
                          DataCell(Text('${listItem[index].quantity}')),
                          DataCell(Text('${listItem[index].price}')),
                          DataCell(Text('${listItem[index].amount}')),
                          DataCell(Text('${listItem[index].description}')),
                        ])),
                  )),
              Container(
                child: DocumentShowScreen(entityId: widget.id,entityName: 'saleOrder',groupName: '凭证',),
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
