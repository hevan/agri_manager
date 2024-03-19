import 'dart:convert';
import 'dart:developer';

import 'package:sp_util/sp_util.dart';

import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/business/FinanceExpense.dart';
import 'package:agri_manager/src/model/business/FinanceExpenseItem.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/product/Product.dart';
import 'package:agri_manager/src/model/project/BatchCycle.dart';
import 'package:agri_manager/src/model/project/BatchProduct.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/document/document_screen.dart';
import 'package:agri_manager/src/screens/project/batch_select_screen.dart';
import 'package:agri_manager/src/screens/project/finance_expense_item_edit_screen.dart';
import 'package:agri_manager/src/utils/agri_util.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class FinanceExpenseEditScreen extends StatefulWidget {
  final int? id;
  final int? batchId;
  final String? batchName;

  const FinanceExpenseEditScreen({Key? key, this.id,  this.batchId, this.batchName})
      : super(key: key);

  @override
  State<FinanceExpenseEditScreen> createState() =>
      _FinanceExpenseEditScreenState();
}

class _FinanceExpenseEditScreenState extends State<FinanceExpenseEditScreen> {
  final _textName = TextEditingController();
  final _textCycleName = TextEditingController();
  final _textExpenseType = TextEditingController();
  final _textDescription = TextEditingController();
  final _textOccurAt = TextEditingController();
  final _textBatchName = TextEditingController();

  List<int> errorFlag = [0, 0, 0, 0, 0, 0, 0];

  List<String> varFoundDirect = ['支出', '收入'];

  List<BatchCycle> listCycle = [];
  BatchCycle? parentCycle;

  List<Product> listProduct = [];
  Product? investBatch;

  List<FinanceExpenseItem> listExpenseItem = [];

  FinanceExpense _financeExpense = FinanceExpense();

  LoginInfoToken userInfo =  LoginInfoToken();

  Corp? curCorp;

  @override
  void dispose() {
    _textCycleName.dispose();
    _textName.dispose();
    _textDescription.dispose();
    _textExpenseType.dispose();
    _textOccurAt.dispose();
    _textBatchName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();


      setState(() {
        curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
        userInfo =
            LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
      });

    if(null !=  widget.id) {
      loadData(widget.id);
    }

    if(null !=  widget.batchId){
      _financeExpense.batchId = widget.batchId;
      _textBatchName.text = widget.batchName!;

      loadBatchCycle(widget.batchId!);
    }

    loadProduct();

  }

  Future loadBatchCycle(int batchId) async{
    var params = {'batchId': batchId};

    try {
      var retData = await DioUtils()
          .request(HttpApi.batch_cycle_findAll, "GET", queryParameters: params);

      setState(() {
        listCycle =
            (retData as List).map((e) => BatchCycle.fromJson(e)).toList();
      });
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }
  Future loadData(int? curId) async {

      try {
        var retData = await DioUtils().request(
            HttpApi.finance_expense_find + curId!.toString(), "GET");

        if (retData != null) {
          setState(() {
            _financeExpense = FinanceExpense.fromJson(retData);
            _textBatchName.text = _financeExpense.batchProduct!.name!;
            _textCycleName.text = _financeExpense.cycleName!;
            _textName.text = _financeExpense.name!;
            _textDescription.text = _financeExpense.description ?? '';
            _textExpenseType.text = _financeExpense.expenseType ?? '';
            _textOccurAt.text = _financeExpense.occurAt ?? '';

          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }

      loadDataItem(curId);

  }

  loadProduct() async{
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

  Future loadDataItem(int? curId) async{
    var paramsBatch = {
      'expenseId': curId,
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

  Future save() async {
    bool checkError = false;

    if (_textCycleName.text == '') {
      errorFlag[0] = 1;
      checkError = true;
    }

    if (_textName.text == '') {
      errorFlag[1] = 1;
      checkError = true;
    }

    if (_textExpenseType.text == '') {
      errorFlag[2] = 1;
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
      _financeExpense.name = _textName.text;
      _financeExpense.expenseType = _textExpenseType.text;
      _financeExpense.description = _textDescription.text;
      _financeExpense.occurAt = _textOccurAt.text;
      _financeExpense.cycleName = _textCycleName.text;
      _financeExpense.corpId = curCorp?.id;
      _financeExpense.checkStatus = 0;
      _financeExpense.status = 0;
      _financeExpense.createdUserId = userInfo.userId;


      var retData = await DioUtils().request(
          HttpApi.finance_expense_add, "POST",
          data: json.encode(_financeExpense), isJson: true);

      if(null != retData){
        _financeExpense = FinanceExpense.fromJson(retData);
        Fluttertoast.showToast(
            msg: '保存成功',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 6);
      }

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

  toDelateItem(FinanceExpenseItem item, int index){
    if(null != item.id){
      deleteExpenseItem(item.id!);
    }
    setState(() {
      listExpenseItem.removeAt(index);
    });
  }

  Future deleteExpenseItem(int id) async {
    try {
      await DioUtils().request('${HttpApi.finance_expense_item_delete}${id}', "DELETE");
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
     String retProduct = await Navigator.push(
         context,
         MaterialPageRoute(builder: (context) =>  FinanceExpenseItemEditScreen(expenseId: widget.id,),
             fullscreenDialog: true)
     );
     if(retProduct != null) {
       // ignore: curly_braces_in_flow_control_structures
       setState(() {
         FinanceExpenseItem curExpenseItem  = FinanceExpenseItem.fromJson(json.decode(retProduct));
         setState(() {
           listExpenseItem.add(curExpenseItem);
         });
       });
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投入费用'),
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
                    errorText: errorFlag[6] == 1?'请选择项目':'',
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
                            _financeExpense.batchId = retDataMap['id'];
                            _textBatchName.text = retDataMap['name'] ?? '';
                          });
                          loadBatchCycle(_financeExpense.batchId!);
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
                  controller: _textCycleName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择项目阶段',
                    hintText: '阶段',
                    errorText: errorFlag[0] == 1 ? '请选择项目阶段' : '',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        int? ret = await showDialog<int>(
                          context: context,
                          builder: (content) {
                            return SimpleDialog(
                                title: const Text('选择生产阶段'),
                                children: [
                                  SizedBox(
                                    height: 400.0,
                                    width: 400.0,
                                    child: ListView.builder(
                                      itemCount: listCycle.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        BatchCycle curItem = listCycle[index];
                                        return ListTile(
                                          title: Text("${curItem.name}"),
                                          subtitle:
                                              Text("${curItem.description}"),
                                          onTap: () {
                                            setState(() {
                                              parentCycle = curItem;
                                            });
                                            Navigator.of(context).pop(index);
                                          },
                                        );
                                      },
                                    ),
                                  )
                                ]);
                            //使用AlertDialog会报错
                            //return AlertDialog(content: child);
                          },
                        );
                        if (ret != null) {
                          setState(() {
                            parentCycle = listCycle[ret];
                            _textCycleName.text = parentCycle!.name!;
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
                      errorText: errorFlag[1] == 1 ? '费用名称改请填写' : null,
                    ),
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textExpenseType,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '费用种类',
                    hintText: '费用种类',
                    errorText: errorFlag[2] == 1 ? '费用种类填写' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                DropdownButtonFormField<String>(
                  value: _financeExpense.foundDirect == -1 ? '支出' : '收入',
                  items: varFoundDirect
                      .map((label) => DropdownMenuItem(
                            child: Text(label.toString()),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _financeExpense.foundDirect = value == '支出' ? -1 : 1;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '资金方向',
                    hintText: '选择资金方向',
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
                          initialDate: _financeExpense.occurAt != null
                              ? DateFormat('yyyy-MM-dd')
                                  .parse(_financeExpense.occurAt!)
                              : DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2055),
                        );
                        if (selected != null) {
                          setState(() {
                            _financeExpense.occurAt =
                                DateFormat('yyyy-MM-dd').format(selected);
                            _textOccurAt.text = _financeExpense.occurAt!;
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
                        listExpenseItem.length,
                            (index) => DataRow(cells: [
                          DataCell(Text('${listExpenseItem[index].id}')),
                          DataCell(Text('${listExpenseItem[index].product?.name}')),
                          DataCell(Text('${listExpenseItem[index].productSku}')),
                          DataCell(Text('${listExpenseItem[index].quantity}')),
                          DataCell(Text('${listExpenseItem[index].price}')),
                          DataCell(Text('${listExpenseItem[index].amount}')),
                          DataCell(
                              Text('${listExpenseItem[index].description}')),
                          DataCell(Row(
                            children: [
                              ElevatedButton(
                                style: elevateButtonStyle,
                                onPressed:() {
                                  toDelateItem(listExpenseItem[index], index);
                                },
                                child: const Text('删除'),
                              ),
                            ],
                          ))
                        ])),
                  )),
              Container(
                child: null != _financeExpense.id ? DocumentScreen(entityId: _financeExpense.id!,entityName: 'financeExpense',groupName: '凭证',) : Center(),
              ),

            ]),
          ),
        ],
      ),
    );
  }

}
