import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/cms/CmsBlog.dart';
import 'package:agri_manager/src/model/cms/CmsCategory.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:intl/intl.dart';


class ManageCmsBlogEditScreen extends StatefulWidget {
  final int? id;

  const ManageCmsBlogEditScreen({Key? key, this.id}) : super(key: key);

  @override
  State<ManageCmsBlogEditScreen> createState() => _ManageCmsBlogEditScreenState();
}

class _ManageCmsBlogEditScreenState extends State<ManageCmsBlogEditScreen> {
  final _textTitle = TextEditingController();
  final _textCategoryName = TextEditingController();
  final _textAuthor = TextEditingController();
  final _textTags = TextEditingController();
  final _textDescription = TextEditingController();
  final _textPublishAt = TextEditingController();

  List<int> errorFlag = [0, 0, 0, 0, 0, 0];

  List<CmsCategory> listCategory = [];
  CmsCategory? selectCategory;

  CmsBlog _cmsBlog = CmsBlog();
  LoginInfoToken? userInfo;
  Corp? curCorp;


  @override
  void dispose() {
    _textTitle.dispose();
    _textCategoryName.dispose();
    _textAuthor.dispose();
    _textDescription.dispose();
    _textTags.dispose();
    _textPublishAt.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    
    setState(() {
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
    });

    loadData();

  }

  Future loadData() async {
    var params = {'corpId': curCorp?.id};

    try {
      var retData = await DioUtils().request(
          HttpApi.cms_category_findAll, "GET",
          queryParameters: params);
      if (retData != null) {
        setState(() {
          listCategory =
              (retData as List).map((e) => CmsCategory.fromJson(e)).toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

    if (widget.id != null) {
      try {
        var retData = await DioUtils()
            .request(HttpApi.cms_blog_find + widget.id!.toString(), "GET");

        if (retData != null) {
          setState(() {
            _cmsBlog = CmsBlog.fromJson(retData);

          
            _textTitle.text = _cmsBlog.title != null ? _cmsBlog.title! : '';
            _textTags.text = _cmsBlog.tags != null ? _cmsBlog.tags! : '';
            _textAuthor.text = _cmsBlog.author != null ? _cmsBlog.author! : '';
            _textDescription.text =
                _cmsBlog.description != null ? _cmsBlog.description! : '';
            _textCategoryName.text =
                _cmsBlog.category!.name != null ? _cmsBlog.category!.name! : '';
          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
        Fluttertoast.showToast(
            msg: customAppException.getMessage(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 6);
      }
    }
  }

  Future save() async {
    bool checkError = false;
    log(_textCategoryName.text);
    if (_textCategoryName.text == '') {
      errorFlag[0] = 1;
      checkError = true;
    }

    if (_textTitle.text == '') {
      errorFlag[1] = 1;
      checkError = true;
    }

    if (_textAuthor.text == '') {
      errorFlag[2] = 1;
      checkError = true;
    }

    if (_textTags.text == '') {
      errorFlag[3] = 1;
      checkError = true;
    }

    if (_textPublishAt.text == '') {
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

    _cmsBlog.title = _textTitle.text;
    _cmsBlog.author = _textAuthor.text;
    _cmsBlog.tags = _textTags.text;
    _cmsBlog.description = _textDescription.text;
    _cmsBlog.corpId = curCorp?.id;
    _cmsBlog.createdUserId = userInfo?.userId;
    _cmsBlog.publishAt = _textPublishAt.text;
    _cmsBlog.status = 1;
    _cmsBlog.checkStatus =1;
    try {
      if(null == widget.id) {
        var retData = await DioUtils().request(HttpApi.cms_blog_add, "POST",
            data: json.encode(_cmsBlog), isJson: true);

      }else{
        var retData = await DioUtils().request('${HttpApi.cms_blog_update}${widget.id}', "PUT",
            data: json.encode(_cmsBlog), isJson: true);
        if (retData != null) {
          Navigator.of(context).pop();
        }
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
        title: const Text('资讯编辑'),
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
                    errorText: errorFlag[0] == 1 ? '请设置分类' : '',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        int? ret = await showDialog<int>(
                          context: context,
                          builder: (content) {
                            return SimpleDialog(
                                title: const Text('选择分类'),
                                children: [
                                  Container(
                                    height: 400.0,
                                    width: 400.0,
                                    child: ListView.builder(
                                      itemCount: listCategory.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        CmsCategory curItem = listCategory[index];
                                        return ListTile(
                                          title: Text("${curItem.name}"),
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
                            selectCategory = listCategory[ret];
                            _textCategoryName.text = selectCategory!.name!;
                            _cmsBlog.categoryId = selectCategory!.id!;
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
                  controller: _textAuthor,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '作者或来源',
                    hintText: '作者或来源',
                    errorText: errorFlag[1] == 1 ? '作者或来源必须输入' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textTitle,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '名称',
                    hintText: '输入名称',
                    errorText: errorFlag[2] == 1 ? '名称不能为空' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textTags,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '标签',
                    hintText: '标签',
                    errorText: errorFlag[3] == 1 ? '标签不能为空' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
                ),
                TextField(
                  controller: _textPublishAt,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '发生日期',
                    hintText: '发生日期',
                    errorText: errorFlag[4] == 1 ? '日期不能为空' : null,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final selected = await showDatePicker(
                          context: context,
                          initialDate: _cmsBlog.publishAt != null
                              ? DateFormat('yyyy-MM-dd')
                              .parse(_cmsBlog.publishAt!)
                              : DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2055),
                        );
                        if (selected != null) {
                          setState(() {
                            _cmsBlog.publishAt =
                                DateFormat('yyyy-MM-dd').format(selected);
                            _textPublishAt.text = _cmsBlog.publishAt!;
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
                  height: kSpacing,
                ),
                Container(
                  child: InkWell(
                    onTap: uploadImage,
                    child: _cmsBlog.imageUrl != null
                        ? Image(
                            image: NetworkImage(
                                '${HttpApi.host_image}${_cmsBlog.imageUrl}'),
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
          'userId': userInfo?.userId,
          'corpId': curCorp?.id,
          'file': MultipartFile(
              pFile.readStream as Stream<List<int>>, pFile.size,
              filename: pFile.name)
        });

        var ret = await DioUtils()
            .requestUpload(HttpApi.open_gridfs_upload, data: formData);
        // print(json.encode(ret));
        setState(() {
          _cmsBlog.imageUrl = ret['id'];
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
