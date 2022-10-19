import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:sp_util/sp_util.dart';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/product/Product.dart';
import 'package:znny_manager/src/model/product/ProductCycle.dart';
import 'package:znny_manager/src/model/product/ProductCycleExpense.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class ProductCycleExpenseEditScreen extends StatefulWidget {
  final int? id;
  final int productId;
  final String productName;
  const ProductCycleExpenseEditScreen({Key? key, this.id, required this.productId, required this.productName}) : super(key: key);

  @override
  State<ProductCycleExpenseEditScreen> createState() => _ProductCycleExpenseEditScreenState();
}

class _ProductCycleExpenseEditScreenState extends State<ProductCycleExpenseEditScreen> {
  final _textCycleName = TextEditingController();
  final _textInvestProductName = TextEditingController();
  final _textQuantity = TextEditingController();
  final _textPrice = TextEditingController();

  List<int> errorFlag = [0,0,0,0,0,0];

  int _validateCode = 0;
  String _errorMessage = "";
  List<ProductCycle> listCycle = [];
  ProductCycle? parentCycle;

  List<Product> listProduct = [];

  Product? investProduct;

  ProductCycleExpense _productCycleExpense = ProductCycleExpense();
  int? userId;

  @override
  void dispose() {
    _textCycleName.dispose();
    _textInvestProductName.dispose();
    _textQuantity.dispose();
    _textPrice.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();

    setState(() {
      _productCycleExpense.productId = widget.productId;
      _productCycleExpense.productName = widget.productName;

      userId = SpUtil.getInt(Constant.userId);
    });
  }

  Future loadData() async {
    var params = {'productId': widget.productId};

    try {
      var retData = await DioUtils().request(
          HttpApi.product_cycle_findAll, "GET",
          queryParameters: params);

      setState(() {
        listCycle =
            (retData as List).map((e) => ProductCycle.fromJson(e)).toList();
      });
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.product_cylce_expense_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _productCycleExpense = ProductCycleExpense.fromJson(retData);

            _textCycleName.text = _productCycleExpense.cycleName != null ? _productCycleExpense.cycleName! : '';
            _textInvestProductName.text = _productCycleExpense.investProductName != null ? _productCycleExpense.investProductName! : '';
            _textQuantity.text = _productCycleExpense.quantity != null ? _productCycleExpense.quantity.toString() : '';
            _textPrice.text = _productCycleExpense.price != null ? _productCycleExpense.price!.toString() : '';

          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException = CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }

    var paramsProduct = {'corpId': HttpApi.corpId, 'name': '', 'page': 0, 'size': 200};

    try {
      var retData = await DioUtils().request(
          HttpApi.product_query, "GET", queryParameters: paramsProduct);
      if(retData != null && retData['content'].length > 0) {
        setState(() {
          listProduct =
              (retData['content'] as List).map((e) => Product.fromJson(e)).toList();
        });
      }
    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

  }

  Future save() async {

    bool checkError = false;


    if(_textCycleName.text == ''){
      errorFlag[1] = 1;
      checkError=true;
    }

    if(_textInvestProductName.text == ''){
      errorFlag[2] = 1;
      checkError=true;
    }

    if(_textQuantity.text == ''){
      errorFlag[3] = 1;
      checkError=true;
    }

    if(_textPrice.text == ''){
      errorFlag[4] = 1;
      checkError=true;
    }

    if(checkError){
      return;
    }

    _productCycleExpense.quantity = int.parse(_textQuantity.text);
    _productCycleExpense.price = double.parse(_textPrice.text);

    try {
      var retData = await DioUtils().request(HttpApi.product_cylce_expense_add, "POST",
          data: json.encode(_productCycleExpense), isJson: true);
      Navigator.of(context).pop();
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('投入品费用'),
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
                  controller: _textCycleName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择主阶段',
                    hintText: '主阶段',
                    errorText: errorFlag[0] == 1?'请选择生产阶段':'',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        int? ret = await showDialog<int>(
                          context: context,
                          builder: (content) {
                            return SimpleDialog(
                                 title: const Text('选择生产阶段'),
                                children:[
                                  SizedBox(
                                  height: 400.0, width: 400.0,
                                    child: ListView.builder(
                                  itemCount: listCycle.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    ProductCycle curItem = listCycle[index];
                                    return ListTile(
                                      title: Text("${curItem.name}"),
                                      subtitle: Text("${curItem.description}"),
                                      onTap: () {
                                        Navigator.of(context).pop(index);
                                      },
                                    );
                                  },
                                ),
                            )]);
                            //使用AlertDialog会报错
                            //return AlertDialog(content: child);
                          },
                        );
                        if (ret != null) {
                          setState(() {
                            parentCycle = listCycle[ret];
                            _textCycleName.text = parentCycle!.name!;
                            _productCycleExpense.cycleId = parentCycle!.id!;
                            _productCycleExpense.cycleName = parentCycle!.name!;
                          });
                        }
                      },
                      icon: const Icon(Icons.search_sharp),
                    ),
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),

                TextField(
                  controller: _textInvestProductName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择投入品',
                    hintText: '投入品',
                    errorText: errorFlag[2] == 1?'选择投入品':'',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        int? ret = await showDialog<int>(
                          context: context,
                          builder: (content) {
                            return SimpleDialog(
                                title: const Text('选择投入品'),
                                children:[
                                  SizedBox(
                                    height: 400.0, width: 400.0,
                                    child: ListView.builder(
                                      itemCount: listProduct.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        Product curItem = listProduct[index];
                                        return ListTile(
                                          title: Text("${curItem.name}"),
                                          subtitle: Text("${curItem.description}"),
                                          onTap: () {
                                            Navigator.of(context).pop(index);
                                          },
                                        );
                                      },
                                    ),
                                  )]);
                            //使用AlertDialog会报错
                            //return AlertDialog(content: child);
                          },
                        );
                        if (ret != null) {
                          setState(() {
                            investProduct = listProduct[ret];
                            _textInvestProductName.text = investProduct!.name!;
                            _productCycleExpense.investProductId = investProduct!.id!;
                            _productCycleExpense.investProductName = investProduct!.name!;
                          });
                        }
                      },
                      icon: const Icon(Icons.search_sharp),
                    ),
                  ),
                ),

                Container(
                  height: defaultPadding,
                ),
                Container(
                  child: TextField(
                    controller: _textQuantity,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: '数量',
                      hintText: '数量',
                      errorText: errorFlag[3] == 1 ? '投入数量请填写' : null,
                    ),
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textPrice,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '单价',
                    hintText: '单价',
                    errorText: errorFlag[4] == 1 ? '单价不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
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

  Future uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(withReadStream: true);
    if (result != null) {
      //log(result.files.first.name);
      //File file = File(result.files.first.name);
      log('start to load ');
      try {
        //rint('start to upload');r
       PlatformFile pFile = result.files.single;
        var formData = FormData.fromMap({
          'userId': userId,
          'corpId': HttpApi.corpId,
          'file':  MultipartFile( pFile.readStream as Stream<List<int>>, pFile.size, filename: pFile.name)
        });
        //print('start to upload');
        var ret = await DioUtils().requestUpload(
          HttpApi.open_file_upload,
          data: formData,
        );
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    } else {
      // User canceled the picker
    }
  }

  String basename(String path){
    return path.substring(path.lastIndexOf('/') + 1);
  }
}
