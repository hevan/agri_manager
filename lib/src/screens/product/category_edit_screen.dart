import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/product/Category.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';

class CategoryEditScreen extends StatefulWidget {
  final Category? editCategory;

  const CategoryEditScreen({Key? key, this.editCategory}) : super(key: key);

  @override
  State<CategoryEditScreen> createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends State<CategoryEditScreen> {
  final _textName = TextEditingController();
  final _textParentName = TextEditingController();
  int _validateCode = 0;
  Category? selectParent;
  List<Category> listCategory = [];
  Category _category = Category(corpId: HttpApi.corpId);

  @override
  void dispose() {
    _textName.dispose();
    _textParentName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();


    if(widget.editCategory != null){
      setState(() {
        _category = widget.editCategory!;
        _textName.text = _category.name!;

        if(_category.name!.lastIndexOf(' ') > 0) {
          _textParentName.text =
              _category.name!.substring(0, _category.name!.lastIndexOf(' '));
        }
      });
    }



    loadCategory();
  }

  Future loadCategory() async {
    var params = {'corpId': HttpApi.corpId};

    try {
      var retData = await DioUtils().request(
          HttpApi.product_category_findAll, "GET", queryParameters: params);

      if(retData != null){
        setState(() {
          listCategory =
              (retData as List).map((e) => Category.fromJson(e)).toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  Future save() async {
    try {
      Category? category;
      if(selectParent != null) {
        category = Category(pathName: _textParentName.text + ' ' + _textName.text , name:  _textName.text, parentId: selectParent!.id!, corpId:HttpApi.corpId);
      }else{
        category = Category(pathName: _textParentName.text + ' ' + _textName.text , name:  _textName.text, corpId:HttpApi.corpId);
      }

      var retData = await DioUtils().request(
          HttpApi.product_category_add, "POST", data: json.encode(category),isJson: true);
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
        title: const Text('产品分类编辑'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
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
                  labelText: '上级分类',
                  hintText: '选择分类',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      int? ret = await showDialog<int>(
                        context: context,
                        builder: (content) {
                          return Dialog(
                              child:
                              Column(
                                children: <Widget>[
                                  const ListTile(title: Text("选择"),),
                                  Expanded(
                                      child: ListView.builder(
                                        itemCount: listCategory.length,
                                        itemBuilder: (context, index) {
                                          Category curItem = listCategory[index];
                                          return ListTile(
                                            title: Text("${curItem.pathName}"),
                                            onTap: () {
                                              Navigator.of(context).pop(index);
                                            },
                                          );
                                        },
                                      )),
                                ],
                              )
                          );
                          //使用AlertDialog会报错
                          //return AlertDialog(content: child);
                        },
                      );
                      if(ret != null) {

                        setState(() {
                          selectParent = listCategory[ret];
                          _textParentName.text = selectParent!.pathName!;
                        });

                      }
                    },
                    icon: const Icon(Icons.search_sharp),
                  ),
                ),
              ),
              Container(height: kSpacing,),
              TextField(
                controller: _textName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: '名称',
                  hintText: '输入分类名称',
                  errorText: _validateCode == 1 ? '名称不能为空' : null,
                ),
              ),
              Container(height: kSpacing,),
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
    );
  }

}
