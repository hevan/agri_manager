import 'dart:convert';
import 'dart:developer';

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/business/SaleOrder.dart';
import 'package:agri_manager/src/model/business/SaleOrderItem.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/product/Product.dart';
import 'package:agri_manager/src/model/project/BatchProduct.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/business/sale_order_item_edit_screen.dart';
import 'package:agri_manager/src/screens/customer/customer_select_screen.dart';
import 'package:agri_manager/src/screens/document/document_screen.dart';
import 'package:agri_manager/src/screens/project/batch_select_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

class SaleOrderEditScreen extends StatefulWidget {
  final int? id;
  final int? batchId;

  const SaleOrderEditScreen({Key? key, this.id,  this.batchId})
      : super(key: key);

  @override
  State<SaleOrderEditScreen> createState() =>
      _SaleOrderEditScreenState();
}

class _SaleOrderEditScreenState extends State<SaleOrderEditScreen> {
  final _textName = TextEditingController();
  final _textDescription = TextEditingController();
  final _textOccurAt = TextEditingController();
  final _textBatchName = TextEditingController();
  final _textCustomerName = TextEditingController();


  List<int> errorFlag = [0, 0, 0, 0, 0, 0, 0];

  List<String> varFoundDirect = ['支出', '收入'];
  

  List<Product> listProduct = [];
  List<BatchProduct> listBatchProduct = [];
  Product? investBatch;

  List<SaleOrderItem> listOrderItem = [];

  SaleOrder _saleOrder = SaleOrder();


  LoginInfoToken userInfo =  LoginInfoToken();

  Corp? curCorp;

  @override
  void dispose() {
    _textName.dispose();
    _textDescription.dispose();
    _textOccurAt.dispose();
    _textBatchName.dispose();
    _textCustomerName.dispose();
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

  Future loadData() async {

    if (widget.id != null) {
      try {
        var retData = await DioUtils().request(
            HttpApi.sale_order_find + widget.id!.toString(), "GET");

        if (retData != null) {
          setState(() {
            _saleOrder = SaleOrder.fromJson(retData);

            _textName.text = _saleOrder.name!;
            _textDescription.text = _saleOrder.description ?? '';
            _textOccurAt.text = _saleOrder.occurAt ?? '';
            _textBatchName.text = _saleOrder.batchProduct!.name!;
            _textCustomerName.text = _saleOrder.customer!.name!;
          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }

      loadDataItem();
    }

    var paramsBatch = {
      'corpId': curCorp?.id,
      'name': '',
      'page': 0,
      'size': 60
    };

    try {
      var retData = await DioUtils()
          .request(HttpApi.product_query, "GET", queryParameters: paramsBatch);
      if (retData != null && retData['content'].length > 0) {
        setState(() {
          listProduct = (retData['content'] as List)
              .map((e) => Product.fromJson(e))
              .toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  Future loadDataItem() async{
    var paramsBatch = {
      'orderId': widget.id,
    };

    try {
      var retData = await DioUtils()
          .request(HttpApi.sale_order_item_findAll, "GET", queryParameters: paramsBatch);
      if (retData != null && retData.length > 0) {
        setState(() {
          listOrderItem = (retData as List)
              .map((e) => SaleOrderItem.fromJson(e))
              .toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  Future save() async {
    bool checkError = false;

    if (_textBatchName.text == '') {
      errorFlag[0] = 1;
      checkError = true;
    }

    if (_textName.text == '') {
      errorFlag[1] = 1;
      checkError = true;
    }


    if (_textOccurAt.text == '') {
      errorFlag[4] = 1;
      checkError = true;
    }


    if (checkError) {
      return;
    }

    try {
      _saleOrder.name = _textName.text;
      _saleOrder.description = _textDescription.text;
      _saleOrder.occurAt = _textOccurAt.text;
      _saleOrder.corpId = curCorp?.id;
      _saleOrder.createdUserId = userInfo.userId;
      _saleOrder.status = 0;
      _saleOrder.checkStatus = 0;
      var retData = await DioUtils().request(
          HttpApi.sale_order_add, "POST",
          data: json.encode(_saleOrder), isJson: true);
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

  toDelateItem(SaleOrderItem item, int index){
    if(null != item.id){
      deleteOrderItem(item.id!);
    }
    setState(() {
      listOrderItem.removeAt(index);
    });
  }

  Future deleteOrderItem(int id) async {
    try {
      await DioUtils().request('${HttpApi.sale_order_item_delete}${id}', "DELETE");
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

   Future toAddExpenseItem() async{
     String retEditItem = await Navigator.push(
         context,
         MaterialPageRoute(builder: (context) =>  SaleOrderItemEditScreen(orderId: widget.id,),
             fullscreenDialog: true)
     );
     if(retEditItem != null) {
       // ignore: curly_braces_in_flow_control_structures
       setState(() {
         SaleOrderItem curItem  = SaleOrderItem.fromJson(json.decode(retEditItem));
         setState(() {
           listOrderItem.add(curItem);
         });
       });
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('销售单据'),
      ),
      body:  LayoutBuilder(builder:
          (BuildContext context, BoxConstraints viewportConstraints) {

       return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
            Center(
            child: Container(
                padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _textBatchName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择项目',
                    hintText: '项目',
                    errorText: errorFlag[0] == 1?'请选择项目':'',
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
                            _saleOrder.batchId = retDataMap['id'];
                            _textBatchName.text = retDataMap['name'] ?? '';
                          });
                        }

                      },
                      icon: const Icon(Icons.search_sharp),
                    ),
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textCustomerName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择客户',
                    hintText: '客户',
                    errorText: errorFlag[0] == 1?'请选择客户':'',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        String retData = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CustomerSelectScreen(),
                                fullscreenDialog: true)
                        );
                        if(retData != null) {
                          // ignore: curly_braces_in_flow_control_structures
                          setState(() {
                            var retDataMap = json.decode(retData);
                            _saleOrder.customerId = retDataMap['id'];
                            _textCustomerName.text = retDataMap['name'] ?? '';
                          });
                        }
                      },
                      icon: const Icon(Icons.search_sharp),
                    ),
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                Container(
                  child: TextField(
                    controller: _textName,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: '名称',
                      hintText: '名称',
                      errorText: errorFlag[1] == 1 ? '名称请填写' : null,
                    ),
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textOccurAt,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '发生日期',
                    hintText: '发生日期',
                    errorText: errorFlag[4] == 1 ? '日期不能为空' : null,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: _saleOrder.occurAt != null
                              ? DateFormat('yyyy-MM-dd')
                                  .parse(_saleOrder.occurAt!)
                              : DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2055),
                        );
                        if (selected != null) {
                          setState(() {
                            _saleOrder.occurAt =
                                DateFormat('yyyy-MM-dd').format(selected);
                            _textOccurAt.text = _saleOrder.occurAt!;
                          });
                        }
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                  ),
                ),
                Container(
                  height: kSpacing,
                ),

                TextField(
                  controller: _textDescription,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '备注',
                    hintText: '备注'
                  ),
                ),
                Container(
                  height: kSpacing,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: elevateButtonStyle,
                      onPressed: () {
                        toAddExpenseItem();
                      },
                      child: const Text('添加明细'),
                    ),
                    SizedBox(
                      width: kSpacing,
                    ),
                    ElevatedButton(
                      style: elevateButtonStyle,
                      onPressed: () {
                        save();
                      },
                      child: const Text('保存'),
                    ),
                  ],
                ),
              ],))),
              _tabSection(context),
              ],
            ),
          ),
        ),
      );})
    );
  }

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(tabs: [
              Tab(text: "明细"),
              Tab(text: "凭证"),
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

                      DataColumn2(
                        size: ColumnSize.L,
                        label: Text('操作'),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                        listOrderItem.length,
                            (index) => DataRow(cells: [
                          DataCell(Text('${listOrderItem[index].id}')),
                          DataCell(Text('${listOrderItem[index].product?.name}')),
                          DataCell(Text('${listOrderItem[index].productSku}')),
                          DataCell(Text('${listOrderItem[index].quantity}')),
                          DataCell(Text('${listOrderItem[index].price}')),
                          DataCell(Text('${listOrderItem[index].amount}')),
                          DataCell(
                              Text('${listOrderItem[index].description}')),
                          DataCell(Row(
                            children: [
                              ElevatedButton(
                                style: elevateButtonStyle,
                                onPressed:() {
                                  toDelateItem(listOrderItem[index], index);
                                },
                                child: const Text('删除'),
                              ),
                            ],
                          ))
                        ])),
                  )),
              Container(
                child: null != _saleOrder.id ? DocumentScreen(entityId: _saleOrder.id!,entityName: 'saleOrder',groupName: '凭证',) : Center(),
              ),

            ]),
          ),
        ],
      ),
    );
  }
  
}
