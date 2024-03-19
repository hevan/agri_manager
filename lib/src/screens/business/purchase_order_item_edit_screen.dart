import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:agri_manager/src/model/business/PurchaseOrderItem.dart';
import 'package:agri_manager/src/model/product/Product.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/product/product_select_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

class PurchaseOrderItemEditScreen extends StatefulWidget {
  final int? id;
  final int? orderId;

  const PurchaseOrderItemEditScreen({Key? key, this.id,  this.orderId})
      : super(key: key);

  @override
  State<PurchaseOrderItemEditScreen> createState() =>
      _PurchaseOrderItemEditScreenState();
}

class _PurchaseOrderItemEditScreenState extends State<PurchaseOrderItemEditScreen> {
  final _textProductName = TextEditingController();
  final _textPrice = TextEditingController();
  final _textQuantity = TextEditingController();
  final _textDescription = TextEditingController();
  final _textAmount = TextEditingController();
  final _textProductSku = TextEditingController();

  List<int> errorFlag = [0, 0, 0, 0, 0, 0, 0];


  PurchaseOrderItem _purchaseOrderItem =  PurchaseOrderItem();


  @override
  void dispose() {
    _textProductName.dispose();
    _textPrice.dispose();
    _textDescription.dispose();
    _textQuantity.dispose();
    _textAmount.dispose();
    _textProductSku.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();


      loadData();
      
      if(null != widget.orderId) {
        setState(() {
          _purchaseOrderItem.orderId = widget.orderId;
        });
      }
  }

  Future loadData() async {


    if (widget.id != null) {
      
      try {
        var retData = await DioUtils().request(
            HttpApi.purchase_order_item_find + widget.id!.toString(), "GET");

        if (retData != null) {
          setState(() {
            _purchaseOrderItem = PurchaseOrderItem.fromJson(retData);

            _textDescription.text = _purchaseOrderItem.description ?? '';
            _textProductName.text = null != _purchaseOrderItem.product ? _purchaseOrderItem.product!.name! : '';
            _textAmount.text = null != _purchaseOrderItem.amount ? _purchaseOrderItem.amount.toString() : '';
            _textPrice.text = null != _purchaseOrderItem.price ? _purchaseOrderItem.price.toString() : '';
            _textQuantity.text = null != _purchaseOrderItem.quantity ? _purchaseOrderItem.quantity.toString() : '';

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


    if (checkError) {
      return;
    }

    try {
      _purchaseOrderItem.price = double.parse(_textPrice.text);
      _purchaseOrderItem.quantity = double.parse(_textQuantity.text);
      _purchaseOrderItem.amount = double.parse(_textAmount.text);
      _purchaseOrderItem.productSku = _textProductSku.text;
      if(null != widget.orderId) {
        var retData = await DioUtils().request(
            HttpApi.purchase_order_item_add, "POST",
            data: json.encode(_purchaseOrderItem), isJson: true);
        Navigator.of(context).pop(json.encode(retData));
      }else{
        Navigator.of(context).pop(json.encode(_purchaseOrderItem));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('明细管理'),
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
                            _purchaseOrderItem.productId = selectProduct.id;
                            _purchaseOrderItem.product = selectProduct;
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
