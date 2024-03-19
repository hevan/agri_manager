import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/base/ParkBase.dart';
import 'package:agri_manager/src/model/project/BatchBase.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:agri_manager/src/utils/constants.dart';

import '../../model/manage/Corp.dart';

class BatchBaseEditScreen extends StatefulWidget {
  final int? id;
  final int batchId;
  final String? batchName;
  final int parkId;
  final String? parkName;
  const BatchBaseEditScreen({Key? key, this.id, required this.batchId,  this.batchName, required this.parkId, this.parkName}) : super(key: key);

  @override
  State<BatchBaseEditScreen> createState() => _BatchBaseEditScreenState();
}

class _BatchBaseEditScreenState extends State<BatchBaseEditScreen> {
  final _textQuantity = TextEditingController();
  final _textBaseName = TextEditingController();
  final _textArea = TextEditingController();
  final _textDescription = TextEditingController();
  final _textBatchName = TextEditingController();
 
  List<int> errorFlag = [0,0,0,0,0,0,0];

  List<ParkBase> listParkBase = [];
  ParkBase? selectBase;

  BatchBase _batchBase = BatchBase();

  Corp? curCorp;
  LoginInfoToken? userInfo;

  @override
  void dispose() {
    _textQuantity.dispose();
    _textBaseName.dispose();
    _textDescription.dispose();
    _textArea.dispose();
    _textBatchName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();

    setState(() {
      _batchBase.batchId = widget.batchId;

    });


      setState(() {
        curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
        userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));

      });

  }

  Future loadData() async {

    var paramsPark = {'parkId': widget.parkId};
    try {
      var retData = await DioUtils().request(
          HttpApi.park_base_findAll, queryParameters: paramsPark, "GET");

      debugPrint(json.encode(retData));

      if(retData != null) {
        setState(() {
           listParkBase = (retData as List).map((e) => ParkBase.fromJson(e)).toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }


    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.batch_base_find + widget.id!.toString(), "GET");

        debugPrint(json.encode(retData));

        if(retData != null) {
          setState(() {
            _batchBase = BatchBase.fromJson(retData);
            _textQuantity.text = _batchBase.quantity != null ?  _batchBase.quantity!.toString() : '';
            _textBaseName.text =  null != _batchBase.parkBaseDto && null != _batchBase.parkBaseDto!.parkBaseName  ? _batchBase.parkBaseDto!.parkBaseName! : '';
            _textBatchName.text = null != _batchBase.batchProductDto && null != _batchBase.batchProductDto!.batchName ? _batchBase.batchProductDto!.batchName ! : '';
            _textArea.text = _batchBase.area != null ? _batchBase.area.toString() : '';
            _textDescription.text = _batchBase.description != null ? _batchBase.description! : '';
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


    if(_textBaseName.text == ''){
      errorFlag[0] = 1;
      checkError=true;
    }

    if(_textArea.text == ''){
      errorFlag[1] = 1;
      checkError=true;
    }

    if(_textQuantity.text == ''){
      errorFlag[2] = 1;
      checkError=true;
    }

    if(_textDescription.text == ''){
      errorFlag[3] = 1;
      checkError=true;
    }

    if(null == _batchBase.imageUrl){
      Fluttertoast.showToast(
          msg: '需要上传地块种植规划图',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
      return ;
    }
    if(checkError){
      return;
    }

    _batchBase.quantity = double.parse(_textQuantity.text);
    _batchBase.area =  double.parse(_textArea.text);
    _batchBase.description = _textDescription.text;
    _batchBase.corpId = curCorp?.id;
    try {
      var retData = await DioUtils().request(HttpApi.batch_base_add, "POST",
          data: json.encode(_batchBase), isJson: true);
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
        title: const Text('项目基地信息'),
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
                  controller: _textBaseName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '地块信息',
                    hintText: '地块',
                    errorText: errorFlag[0] == 1?'选择基地地块信息':'',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        int? ret = await showDialog<int>(
                          context: context,
                          builder: (content) {
                            return SimpleDialog(
                                 title: const Text('选择地块'),
                                children:[
                                  SizedBox(
                                  height: 400.0, width: 400.0,
                                    child: ListView.builder(
                                  itemCount: listParkBase.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    ParkBase parkBaseTemp = listParkBase[index];
                                    return ListTile(
                                      title: Text("${parkBaseTemp.name}"),
                                      subtitle: Text("${parkBaseTemp.description}"),
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
                            selectBase = listParkBase[ret];
                            _textBaseName.text = selectBase!.name!;
                            _batchBase.parkBaseId = selectBase?.id;
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
                  controller: _textArea,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '面积',
                    hintText: '输入面积',
                    errorText: errorFlag[1] == 1  ? '面积不能为空' : null,
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
                    errorText: errorFlag[2] == 1 ? '数量不能为空' : null,

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
                      errorText: errorFlag[3] == 1 ? '描述请填写' : null,
                    ),
                  ),
                ),
                Container(
                  height: defaultPadding,
                ),
                Container(
                  child: InkWell(
                    onTap: uploadImage,
                    child: _batchBase.imageUrl != null
                        ? Image(
                      image: NetworkImage(
                          '${HttpApi.host_image}${_batchBase.imageUrl}'),
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(withReadStream: true);
    if (result != null) {
      //log(result.files.first.name);
      //File file = File(result.files.first.name);
      log('start to load ');
      try {
        //rint('start to upload');r
       PlatformFile pFile = result.files.single;
        var formData = FormData.fromMap({
          'userId': userInfo?.userId,
          'corpId': curCorp?.id,
          'file':  MultipartFile( pFile.readStream as Stream<List<int>>, pFile.size, filename: pFile.name)
        });
        //print('start to upload');
        var ret = await DioUtils().requestUpload(
          HttpApi.open_gridfs_upload,
          data: formData,
        );

        if(null != ret['id']) {
          setState(() {
            _batchBase.imageUrl = ret['id'];
          });
        }
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
