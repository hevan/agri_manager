import 'dart:convert';
import 'dart:developer';

import 'package:sp_util/sp_util.dart';

import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/business/FinanceExpense.dart';
import 'package:agri_manager/src/model/business/FinanceExpenseItem.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/product/Product.dart';
import 'package:agri_manager/src/model/project/BatchCycle.dart';
import 'package:agri_manager/src/model/project/BatchCycleInvest.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/product/product_select_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class BatchCycleInvestEditScreen extends StatefulWidget {
  final num? id;
  final int batchId;

  const BatchCycleInvestEditScreen({Key? key, this.id,  required this.batchId})
      : super(key: key);

  @override
  State<BatchCycleInvestEditScreen> createState() =>
      _BatchCycleInvestEditScreenState();
}

class _BatchCycleInvestEditScreenState extends State<BatchCycleInvestEditScreen> {
  final _textProductName = TextEditingController();
  final _textPrice = TextEditingController();
  final _textQuantity = TextEditingController();
  final _textDescription = TextEditingController();
  final _textAmount = TextEditingController();
  final _textProductSku = TextEditingController();
  final _textCycleName = TextEditingController();

  List<int> errorFlag = [0, 0, 0, 0, 0, 0, 0];


  BatchCycleInvest _batchCycleInvest =  BatchCycleInvest();

  List<BatchCycle> listCycle = [];

  Corp? curCorp;
  LoginInfoToken? userInfo;


  @override
  void dispose() {
    _textProductName.dispose();
    _textPrice.dispose();
    _textDescription.dispose();
    _textQuantity.dispose();
    _textAmount.dispose();
    _textProductSku.dispose();
    _textCycleName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();


      loadData();
     loadBatchCycle(widget.batchId);
    setState(() {
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });
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
  Future loadData() async {


    if (widget.id != null) {

      try {
        var retData = await DioUtils().request(
            HttpApi.batch_cycle_invest_find + widget.id!.toString(), "GET");

        if (retData != null) {
          setState(() {
            _batchCycleInvest = BatchCycleInvest.fromJson(retData);

            _textDescription.text = _batchCycleInvest.description ?? '';
            _textProductName.text = null != _batchCycleInvest.product ? _batchCycleInvest.product!.name! : '';
            _textAmount.text = null != _batchCycleInvest.amount ? _batchCycleInvest.amount.toString() : '';
            _textPrice.text = null != _batchCycleInvest.price ? _batchCycleInvest.price.toString() : '';
            _textQuantity.text = null != _batchCycleInvest.quantity ? _batchCycleInvest.quantity.toString() : '';
            _textCycleName.text = null != _batchCycleInvest.batchCycle ? _batchCycleInvest.batchCycle!.name!: '';
            _textDescription.text = null != _batchCycleInvest.description ? _batchCycleInvest.description! : '';

          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }
  }

  Future save() async {
    bool checkError = false;

    if (_textProductName.text == '') {
      errorFlag[0] = 1;
      checkError = true;
    }

    if (_textProductSku.text == '') {
      errorFlag[1] = 1;
      checkError = true;
    }


    if (_textQuantity.text == '') {
      errorFlag[2] = 1;
      checkError = true;
    }



    if (_textPrice.text == '') {
      errorFlag[3] = 1;
      checkError = true;
    }

    if (_textAmount.text == '') {
      errorFlag[4] = 1;
      checkError = true;
    }

    if (_textCycleName.text == '') {
      errorFlag[5] = 1;
      checkError = true;
    }


    if (checkError) {
      return;
    }

    try {
      _batchCycleInvest.price = double.parse(_textPrice.text);
      _batchCycleInvest.quantity = double.parse(_textQuantity.text);
      _batchCycleInvest.amount = double.parse(_textAmount.text);
      _batchCycleInvest.productSku = _textProductSku.text;
      _batchCycleInvest.batchId = widget.batchId;
      _batchCycleInvest.corpId = curCorp?.id;
      _batchCycleInvest.createdUserId = userInfo?.userId;
      _batchCycleInvest.description = _textDescription.text;

      if(null == widget.id) {
        var retData = await DioUtils().request(
            HttpApi.batch_cycle_invest_add, "POST",
            data: json.encode(_batchCycleInvest), isJson: true);
           Navigator.of(context).pop();
      }else{
        var retData = await DioUtils().request(
            '${HttpApi.batch_cycle_invest_update}${widget.id}', "PUT",
            data: json.encode(_batchCycleInvest), isJson: true);
           Navigator.of(context).pop();
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

  toEdit(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('预计投入费用'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
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
                        int? retIndex = await showDialog<int>(
                          context: context,
                          builder: (content) {
                            return SimpleDialog(
                                title: const Text('选择阶段'),
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
                        if (retIndex != null) {
                          setState(() {
                              _textCycleName.text = listCycle[retIndex].name!;
                              _batchCycleInvest.batchCycleId = listCycle[retIndex]?.id;

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
                  controller: _textProductName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择产品',
                    hintText: '产品',
                    errorText: errorFlag[0] == 1?'请选择产品':'',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        String retProduct = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProductSelectScreen(),
                                fullscreenDialog: true)
                        );
                        if(retProduct != null)
                          // ignore: curly_braces_in_flow_control_structures
                          setState(() {
                            var productMap = json.decode(retProduct);
                            Product selectProduct = Product.fromJson(productMap);
                            _batchCycleInvest.productId = selectProduct.id;
                            _batchCycleInvest.product = selectProduct;
                            _textProductName.text = selectProduct.name ?? '';
                          });
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
                    controller: _textProductSku,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: '产品SKU',
                      hintText: '产品SKU',
                      errorText: errorFlag[1] == 1 ? '请填写产品SKU' : null,
                    ),
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textQuantity,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '数量',
                    hintText: '数量',
                    errorText: errorFlag[2] == 1 ? '填写数量' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textPrice,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '单价',
                    hintText: '单价',
                    errorText: errorFlag[3] == 1 ? '填写单价' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textAmount,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '金额',
                    hintText: '金额',
                    errorText: errorFlag[4] == 1 ? '填写金额' : null,
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
                ElevatedButton(
                  style: elevateButtonStyle,
                  onPressed: () {
                    save();
                  },
                  child: const Text('保存'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
