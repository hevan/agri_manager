import 'dart:convert';
import 'dart:developer';

import 'package:sp_util/sp_util.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/market/MarkMarket.dart';
import 'package:agri_manager/src/model/market/MarkProduct.dart';
import 'package:agri_manager/src/model/market/MarkProductMarket.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class MarkProductMarketEditScreen extends StatefulWidget {
  final num? id;
  const MarkProductMarketEditScreen({Key? key, this.id}) : super(key: key);

  @override
  State<MarkProductMarketEditScreen> createState() => _MarkProductMarketEditScreenState();
}

class _MarkProductMarketEditScreenState extends State<MarkProductMarketEditScreen> {
  final _textProductName = TextEditingController();

  final _textPriceRetal = TextEditingController();
  final _textPriceWholesale = TextEditingController();
  final _textMarketName = TextEditingController();
  final _textUnit = TextEditingController();
  final _textQuantity = TextEditingController();
  final _textOccurAt = TextEditingController();

  List<int> errorFlag = [0,0,0,0,0,0,0,0,0];

  DateTime selectedDate = DateTime.now();

  DateFormat df = DateFormat('yyyy-MM-dd');

  int _validateCode = 0;
  String _errorMessage = "";
  List<MarkProduct> listMarkProduct = [];
  MarkProduct? product;

  List<MarkMarket> listMarket = [];
  MarkMarket? market;

  MarkProductMarket _productMarket = MarkProductMarket();

  @override
  void dispose() {
    _textProductName.dispose();

    _textMarketName.dispose();
    _textPriceRetal.dispose();
    _textUnit.dispose();
    _textOccurAt.dispose();
    _textPriceWholesale.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future loadData() async {
    var params = { 'name': '', 'page': 0, 'size': 100};

    try {
      var retData = await DioUtils().request(
          HttpApi.mark_product_query, "GET",
          queryParameters: params);

      if(null != retData && null != retData['content'] ) {
        setState(() {
          listMarkProduct =
              (retData['content'] as List)
                  .map((e) => MarkProduct.fromJson(e))
                  .toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

    var paramsMarket = { 'name': '', 'page': 0, 'size': 100};

    try {
      var retData = await DioUtils().request(
          HttpApi.market_query, "GET",
          queryParameters: paramsMarket);

      setState(() {
        listMarket =
            (retData['content'] as List).map((e) => MarkMarket.fromJson(e)).toList();
      });
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.product_market_find + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _productMarket = MarkProductMarket.fromJson(retData);

            _textProductName.text = _productMarket.product?.name != null ? _productMarket.product!.name! : '';
            _textUnit.text = _productMarket.calcUnit != null ? _productMarket.calcUnit! : '';
            _textOccurAt.text = _productMarket.occurAt != null ? _productMarket.occurAt! : '';
            _textQuantity.text = _productMarket.quantity != null ? _productMarket.quantity.toString() : '';
            _textPriceRetal.text = _productMarket.priceRetal != null ? _productMarket.priceRetal.toString() : '';
            _textPriceWholesale.text = _productMarket.priceWholesale != null ? _productMarket.priceWholesale.toString() : '';
            _textMarketName.text = _productMarket.market?.name != null ? _productMarket.market!.name! : '';

          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException = CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }


  }

  Future save() async {

    bool checkError = false;


    if(_textProductName.text == ''){
      errorFlag[0] = 1;
      checkError=true;
    }

    if(_textMarketName.text == ''){
      errorFlag[1] = 1;
      checkError=true;
    }

    if(_textOccurAt.text == ''){
      errorFlag[2] = 1;
      checkError=true;
    }

    if(_textQuantity.text == ''){
      errorFlag[3] = 1;
      checkError=true;
    }

    if(_textUnit.text == ''){
      errorFlag[4] = 1;
      checkError=true;
    }
    if(_textPriceWholesale.text == ''){
      errorFlag[5] = 1;
      checkError=true;
    }

    if(_textPriceRetal.text == ''){
      errorFlag[6] = 1;
      checkError=true;
    }

    if(checkError){
      return;
    }
    
    _productMarket.calcUnit = _textUnit.text;
    _productMarket.priceRetal = double.parse(_textPriceRetal.text);
    _productMarket.priceWholesale = double.parse(_textPriceWholesale.text);
    _productMarket.quantity = int.parse(_textQuantity.text);

    try {
      var retData = await DioUtils().request(HttpApi.product_market_add, "POST",
          data: json.encode(_productMarket.toJson()), isJson: true);
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
        title: const Text('市场信息编辑'),
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
                        int? ret = await showDialog<int>(
                          context: context,
                          builder: (content) {
                            return SimpleDialog(
                                 title: const Text('选择产品'),
                                children:[
                                  SizedBox(
                                  height: 400.0, width: 400.0,
                                    child: ListView.builder(
                                  itemCount: listMarkProduct.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    MarkProduct curItem = listMarkProduct[index];
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
                            product = listMarkProduct[ret];
                            _textProductName.text = product!.name!;
                            _productMarket.productId = product!.id;
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
                  controller: _textMarketName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '市场',
                    hintText: '输入城市市场',
                    errorText: errorFlag[4] == 1  ? '市场不能为空' : null,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        int? ret = await showDialog<int>(
                          context: context,
                          builder: (content) {
                            return SimpleDialog(
                                title: const Text('选择市场'),
                                children:[
                                  SizedBox(
                                    height: 400.0, width: 400.0,
                                    child: ListView.builder(
                                      itemCount: listMarket.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        MarkMarket curItem = listMarket[index];
                                        return ListTile(
                                          title: Text("${curItem.name}"),
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
                            market = listMarket[ret];
                            _textMarketName.text = market!.name!;
                            _productMarket.marketId = market!.id;

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
                  controller: _textOccurAt,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '日期',
                    hintText: '输入日期',
                    errorText: errorFlag[2] == 1  ? '日期不能为空' : null,
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.date_range),
                        onPressed:()  {_selectDate(context);}
                    )
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textUnit,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '计量单位',
                    hintText: '计量单位',
                    errorText: errorFlag[3] == 1 ? '计量单位不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textQuantity,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '数量',
                    hintText: '数量',
                    errorText: errorFlag[4] == 1 ? '数量' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textPriceWholesale,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '批发价格',
                    hintText: '批发价格',
                    errorText: errorFlag[5] == 1 ? '批发价格不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textPriceRetal,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '零售价格',
                    hintText: '零售价格',
                    errorText: errorFlag[6] == 1 ? '零售价格不能为空' : null,
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


  Future _selectDate(BuildContext context) async {
     DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _textOccurAt.text = df.format(selectedDate);
        _productMarket.occurAt =  _textOccurAt.text;
      });
    }
  }
}
