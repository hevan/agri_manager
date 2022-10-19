import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:sp_util/sp_util.dart';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/product/Category.dart';
import 'package:znny_manager/src/model/product/Product.dart';
import 'package:znny_manager/src/model/product/ProductCycle.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class ProductCycleEditScreen extends StatefulWidget {
  final int? id;
  final int productId;
  final String productName;

  const ProductCycleEditScreen(
      {Key? key, this.id, required this.productId, required this.productName})
      : super(key: key);

  @override
  State<ProductCycleEditScreen> createState() => _ProductCycleEditScreenState();
}

class _ProductCycleEditScreenState extends State<ProductCycleEditScreen> {
  final _textName = TextEditingController();
  final _textParentName = TextEditingController();
  final _textDays = TextEditingController();
  final _textAmount = TextEditingController();
  final _textDescription = TextEditingController();
  final _textSequence = TextEditingController();

  List<int> errorFlag = [0, 0, 0, 0, 0, 0];

  int _validateCode = 0;
  String _errorMessage = "";
  List<ProductCycle> listCycle = [];
  ProductCycle? parentCycle;

  ProductCycle _productCycle = ProductCycle();
  int? userId;

  @override
  void dispose() {
    _textName.dispose();
    _textParentName.dispose();
    _textDays.dispose();
    _textDescription.dispose();
    _textAmount.dispose();
    _textSequence.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();

    setState(() {
      _productCycle.productId = widget.productId;
      _productCycle.productName = widget.productName;

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

    if (widget.id != null) {
      try {
        var retData = await DioUtils().request(
            HttpApi.product_cylce_find + '/' + widget.id!.toString(), "GET");

        if (retData != null) {
          setState(() {
            _productCycle = ProductCycle.fromJson(retData);

            _textName.text =
                _productCycle.name != null ? _productCycle.name! : '';
            _textDays.text =
                _productCycle.days != null ? _productCycle.days.toString() : '';
            _textAmount.text = _productCycle.amount != null
                ? _productCycle.amount.toString()
                : '';
            _textDescription.text = _productCycle.description != null
                ? _productCycle.description!
                : '';
            _textSequence.text = _productCycle.sequence != null
                ? _productCycle.sequence!
                : '';

            if (null != _productCycle.parentId) {
              for (int i = 0; i < listCycle.length; i++) {
                if (listCycle[i].id == _productCycle.parentId) {
                  parentCycle = listCycle[i];
                  _textParentName.text = parentCycle!.name!;
                }
              }
            }
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

    if (_textName.text == '') {
      errorFlag[1] = 1;
      checkError = true;
    }

    if (_textDays.text == '') {
      errorFlag[3] = 1;
      checkError = true;
    }
    if (_textSequence.text == '') {
      errorFlag[2] = 1;
      checkError = true;
    }
    if (_textAmount.text == '') {
      errorFlag[4] = 1;
      checkError = true;
    }

    if (_textDescription.text == '') {
      errorFlag[5] = 1;
      checkError = true;
    }

    if (checkError) {
      return;
    }

    _productCycle.name = _textName.text;
    _productCycle.days = int.parse(_textDays.text);
    _productCycle.amount = double.parse(_textAmount.text);
    _productCycle.description = _textDescription.text;
    _productCycle.sequence = _textSequence.text;

    try {
      var retData = await DioUtils().request(HttpApi.product_cylce_add, "POST",
          data: json.encode(_productCycle), isJson: true);
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
        title: const Text('产品生产阶段'),
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
                  controller: _textParentName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择主阶段',
                    hintText: '主阶段',
                    errorText: errorFlag[0] == 1 ? '请选择生产阶段' : '',
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
                                        ProductCycle curItem = listCycle[index];
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
                        if (ret != null) {
                          setState(() {
                            parentCycle = listCycle[ret];
                            _textParentName.text = parentCycle!.name!;
                            _productCycle.parentId = parentCycle!.id!;
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
                  controller: _textName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '名称',
                    hintText: '输入名称',
                    errorText: errorFlag[1] == 1 ? '名称不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textSequence,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '序号',
                    hintText: '输入序号',
                    errorText: errorFlag[2] == 1 ? '序号不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                Container(
                  height: 120,
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: _textDescription,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: '描述',
                      hintText: '描述',
                      errorText: errorFlag[5] == 1 ? '描述请填写' : null,
                    ),
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textDays,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '生长天数',
                    hintText: '生长天数',
                    errorText: errorFlag[3] == 1 ? '生长天数不能为空' : null,
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                TextField(
                  controller: _textAmount,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '投入费用',
                    hintText: '费用',
                    errorText: errorFlag[4] == 1 ? '投入费用' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                Container(
                  child: InkWell(
                    onTap: uploadImage,
                    child: _productCycle.imageUrl != null
                        ? Image(
                            image: NetworkImage(
                                'http://localhost:8080/open/gridfs/${_productCycle.imageUrl}'),
                          )
                        : Center(
                            child:
                                Image.asset('assets/icons/icon_add_image.png'),
                          ),
                  ),
                  height: 200,
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
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withReadStream: true);
    if (result != null) {
      //log(result.files.first.name);
      //File file = File(result.files.first.name);
      log('start to load ');
      try {
        //print('start to upload');r
        PlatformFile pFile = result.files.single;
        var formData = FormData.fromMap({
          'userId': userId,
          'corpId': HttpApi.corpId,
          'file': MultipartFile(
              pFile.readStream as Stream<List<int>>, pFile.size,
              filename: pFile.name)
        });

        var ret = await DioUtils()
            .requestUpload(HttpApi.open_gridfs_upload, data: formData);
        // print(json.encode(ret));
        setState(() {
          _productCycle.imageUrl = ret['id'];
        });
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    } else {
      // User canceled the picker
    }
  }

  String basename(String path) {
    return path.substring(path.lastIndexOf('/') + 1);
  }
}
