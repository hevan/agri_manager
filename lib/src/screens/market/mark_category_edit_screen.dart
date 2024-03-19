import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/market/MarkCategory.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';

class MarkCategoryEditScreen extends StatefulWidget {
  final MarkCategory? editCategory;
  const MarkCategoryEditScreen({
    Key? key,
    this.editCategory})
      : super(key: key);

  @override
  State<MarkCategoryEditScreen> createState() => _MarkCategoryEditScreenState();
}

 class _MarkCategoryEditScreenState extends State<MarkCategoryEditScreen> {
  final _textName = TextEditingController();
  final _textParentName = TextEditingController();
  int _validateCode = 0;
  MarkCategory? selectParent;
  List<MarkCategory> listCategory = [];
  MarkCategory _category = MarkCategory();

  Corp? curCorp;

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
      });
    }

    setState(() {
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
    });

    loadCategory();
  }

  Future loadCategory() async {
    var params = {'name': '', 'page': 0, 'size': 60};

    try {
      var retData = await DioUtils().request(
          HttpApi.mark_category_query, "GET", queryParameters: params);

      if(retData != null && null != retData['content']){
        setState(() {
          listCategory =
              (retData['content'] as List).map((e) => MarkCategory.fromJson(e)).toList();

          if(null != _category.id && null != _category.parentId){
            for (var element in listCategory) {
              if(element.id == _category.parentId) {
                selectParent = element;
                _textParentName.text = selectParent!.name!;
              }
            }
          }
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }
  }

  Future save() async {
    try {

       _category.name = _textName.text;
       _category.parentId = selectParent?.id;


      if(null == _category!.id) {
        var retData = await DioUtils().request(
            HttpApi.mark_category_add, "POST", data: json.encode(_category),isJson: true);
      }else{
        var retData = await DioUtils().request('${HttpApi.mark_category_update}${_category!.id}', "PUT",
            data: json.encode(_category), isJson: true);
      }

      Navigator.of(context).pop();
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
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
                                          MarkCategory curItem = listCategory[index];
                                          return ListTile(
                                            title: Text("${curItem.name}"),
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
                          _textParentName.text = selectParent!.name!;
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
