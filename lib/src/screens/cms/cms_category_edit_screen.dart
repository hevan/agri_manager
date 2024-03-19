import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/cms/CmsCategory.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CmsCategoryEditScreen extends StatefulWidget {
  final CmsCategory? editCategory;
  const CmsCategoryEditScreen({
    Key? key,
    this.editCategory})
      : super(key: key);

  @override
  State<CmsCategoryEditScreen> createState() => _CmsCategoryEditScreenState();
}

 class _CmsCategoryEditScreenState extends State<CmsCategoryEditScreen> {
  final _textName = TextEditingController();
  final _textParentName = TextEditingController();
  final _textCode = TextEditingController();
  List<int> errorFlag = [0, 0, 0, 0, 0, 0];
  CmsCategory? selectParent;
  List<CmsCategory> listCategory = [];
  CmsCategory _category = CmsCategory();

  Corp? curCorp;
  @override
  void dispose() {
    _textName.dispose();
    _textParentName.dispose();
    _textCode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
    });

    if(widget.editCategory != null){
      setState(() {
        _category = widget.editCategory!;
        _textName.text = _category.name!;
        _textCode.text = _category.code!;
      });
    }
    loadCategory();
  }

  Future loadCategory() async {
    var params = {'corpId': curCorp?.id};

    try {
      var retData = await DioUtils().request(
          HttpApi.cms_category_findAll, "GET", queryParameters: params);

      if(retData != null){
        setState(() {
          listCategory =
              (retData as List).map((e) => CmsCategory.fromJson(e)).toList();
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

    bool checkError = false;

    if (_textName.text == '') {
      errorFlag[1] = 1;
      checkError = true;
    }

    if (_textCode.text == '') {
      errorFlag[2] = 1;
      checkError = true;
    }

    if(checkError){
      return;
    }

    try {
      _category.name = _textName.text;
      _category.code = _textCode.text;
      _category.corpId = curCorp?.id;

      if(null == _category!.id) {
        var retData = await DioUtils().request(
            HttpApi.cms_category_add, "POST", data: json.encode(_category),isJson: true);
      }else{
        var retData = await DioUtils().request('${HttpApi.cms_category_update}${_category!.id}', "PUT",
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
        title: const Text('资讯分类编辑'),
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
                                          CmsCategory curItem = listCategory[index];
                                          return ListTile(
                                            title: Text("${curItem.name}"),
                                            subtitle: Text("${curItem.code}"),
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
                  errorText: errorFlag[1] == 1 ? '名称不能为空' : null,
                ),
              ),
              Container(height: kSpacing,),
              TextField(
                controller: _textCode,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: '分类编码',
                  hintText: '分类编码',
                  errorText:  errorFlag[2] == 1 ? '编码不能为控' : null,
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
