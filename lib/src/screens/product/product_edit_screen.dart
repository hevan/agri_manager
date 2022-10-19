import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:sp_util/sp_util.dart';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/product/Category.dart';
import 'package:znny_manager/src/model/product/Product.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class ProductEditScreen extends StatefulWidget {
  final int? id;

  const ProductEditScreen({Key? key, this.id}) : super(key: key);

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _textName = TextEditingController();
  final _textCategoryName = TextEditingController();
  final _textCode = TextEditingController();
  final _textCalcUnit = TextEditingController();
  final _textDescription = TextEditingController();

  List<int> errorFlag = [0,0,0,0,0,0];

  int _validateCode = 0;
  String _errorMessage = "";
  List<Category> listCategory = [];
  Category? selectCategory;

  Product _product = Product(corpId: HttpApi.corpId);
  int? userId;

  @override
  void dispose() {
    _textName.dispose();
    _textCategoryName.dispose();
    _textCode.dispose();
    _textDescription.dispose();
    _textCalcUnit.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();

    setState(() {
      userId = SpUtil.getInt(Constant.userId);
    });
  }

  Future loadData() async {
    var params = {'corpId': HttpApi.corpId};

    try {
      var retData = await DioUtils().request(
          HttpApi.product_category_findAll, "GET",
          queryParameters: params);

      setState(() {
        listCategory =
            (retData as List).map((e) => Category.fromJson(e)).toList();
      });
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.product_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _product = Product.fromJson(retData);

            _textCalcUnit.text = _product.calcUnit != null ? _product.calcUnit! : '';
            _textName.text = _product.name != null ? _product.name! : '';
            _textCode.text = _product.code != null ? _product.code! : '';
            _textDescription.text = _product.description != null ? _product.description! : '';
            _textCategoryName.text = _product.categoryName != null ? _product.categoryName! : '';
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
    log(_textCategoryName.text);
    if(_textCategoryName.text == ''){
      errorFlag[0] = 1;
      checkError=true;
    }

    if(_textName.text == ''){
      errorFlag[1] = 1;
      checkError=true;
    }

    if(_textCode.text == ''){
      errorFlag[2] = 1;
      checkError=true;
    }

    if(_textCalcUnit.text == ''){
      errorFlag[3] = 1;
      checkError=true;
    }

    if(_textDescription.text == ''){
      errorFlag[4] = 1;
      checkError=true;
    }

    if(checkError){
      return;
    }

    _product.name = _textName.text;
    _product.code = _textCode.text;
    _product.calcUnit = _textCalcUnit.text;
    _product.description = _textDescription.text;

    try {
      var retData = await DioUtils().request(HttpApi.product_add, "POST",
          data: json.encode(_product), isJson: true);
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
        title: const Text('产品编辑'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _textCategoryName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择分类',
                    hintText: '分类',
                    errorText: errorFlag[0] == 1?'请设置产品分类':'',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        int? ret = await showDialog<int>(
                          context: context,
                          builder: (content) {
                            return SimpleDialog(
                                 title: const Text('选择分类'),
                                children:[
                                  Container(
                                  height: 400.0, width: 400.0,
                                    child: ListView.builder(
                                  itemCount: listCategory.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    Category curItem = listCategory[index];
                                    return ListTile(
                                      title: Text("${curItem.pathName}"),
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
                            selectCategory = listCategory[ret];
                            _textCategoryName.text = selectCategory!.pathName!;
                            _product.categoryId = selectCategory!.id!;
                            _product.categoryName = selectCategory!.pathName!;
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
                  controller: _textCode,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '产品编号',
                    hintText: '编号',
                    errorText: errorFlag[1] == 1 ? '产品编号' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '名称',
                    hintText: '输入名称',
                    errorText: errorFlag[2] == 1  ? '名称不能为空' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textCalcUnit,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '统计单位',
                    hintText: '单位',
                    errorText: errorFlag[3] == 1 ? '统计单位不能为空' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
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
                      errorText: errorFlag[4] == 1 ? '描述请填写' : null,
                    ),
                  ),
                ),

                Container(
                  height: kSpacing,
                ),
                Container(
                  child: InkWell(
                    onTap: uploadImage,
                    child: _product.imageUrl != null
                        ?  Image(
                            image: NetworkImage(
                                'http://localhost:8080/open/gridfs/${_product.imageUrl}'),
                          )
                        : Center(
                            child:
                                Image.asset('assets/icons/icon_add_image.png'),
                          ),
                  ),
                  height: 200,
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

  Future uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(withReadStream: true);
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
          'file':  MultipartFile( pFile.readStream as Stream<List<int>>, pFile.size, filename: pFile.name)
        });
      
        var ret = await DioUtils().requestUpload(
          HttpApi.open_gridfs_upload,
          data: formData
        );
      // print(json.encode(ret));
        setState((){
          _product.imageUrl = ret['id'];
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

  String basename(String path){
    return path.substring(path.lastIndexOf('/') + 1);
  }
}
