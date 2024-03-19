import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:sp_util/sp_util.dart';

import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/base/ParkBase.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../model/base/Park.dart';

class ParkBaseEditScreen extends StatefulWidget {
  final int? id;
  final int? parkId;
  final String? parkName;
  const ParkBaseEditScreen({Key? key, this.id, this.parkName,this.parkId}) : super(key: key);

  @override
  State<ParkBaseEditScreen> createState() => _ParkBaseEditScreenState();
}

class _ParkBaseEditScreenState extends State<ParkBaseEditScreen> {
  final _textName = TextEditingController();
  final _textArea = TextEditingController();
  final _textAreaUse = TextEditingController();
  final _textDescription = TextEditingController();
  final _textParkName = TextEditingController();
  List<int> errorFlag = [0,0,0,0,0,0];

  int _validateCode = 0;
  String _errorMessage = "";
  List<Park> listPark = [];
  Park? selectPark;

  ParkBase _parkBase = ParkBase();
  Corp?   currentCorp;
  LoginInfoToken? userInfo;


  @override
  void dispose() {
    _textName.dispose();
    _textArea.dispose();
    _textAreaUse.dispose();
    _textDescription.dispose();
    _textParkName.dispose();
    
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {
      currentCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });

    if(widget.parkName != null){
      setState((){
        _parkBase.parkId = widget.parkId;
        _textParkName.text = widget.parkName!;
      });
    }
  }

  Future loadData() async {
    var params = {'corpId': currentCorp?.id};

    try {
      var retData = await DioUtils().request(
          HttpApi.park_findAll, "GET",
          queryParameters: params);

      setState(() {
        listPark =
            (retData as List).map((e) => Park.fromJson(e)).toList();
      });
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.park_base_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _parkBase = ParkBase.fromJson(retData);

            _textName.text = _parkBase.name != null ? _parkBase.name! : '';
            _textAreaUse.text = _parkBase.areaUse != null ? _parkBase.areaUse!.toString() : '';
            _textDescription.text = _parkBase.description != null ? _parkBase.description! : '';
            _textArea.text = _parkBase.area != null ? _parkBase.area!.toString() : '';
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
    log(_textArea.text);
    if(_textArea.text == ''){
      errorFlag[0] = 1;
      checkError=true;
    }

    if(_textParkName.text == ''){
      errorFlag[5] = 1;
      checkError=true;
    }


    if(_textName.text == ''){
      errorFlag[1] = 1;
      checkError=true;
    }

    if(_textAreaUse.text == ''){
      errorFlag[2] = 1;
      checkError=true;
    }

    if(_textDescription.text == ''){
      errorFlag[4] = 1;
      checkError=true;
    }

    if(checkError){
      return;
    }

    _parkBase.name = _textName.text;
    _parkBase.areaUse = double.parse(_textAreaUse.text);
    _parkBase.area = double.parse(_textArea.text);
    _parkBase.description = _textDescription.text;
    _parkBase.corpId = currentCorp?.id;

    try {
      var retData = await DioUtils().request(HttpApi.park_base_add, "POST",
          data: json.encode(_parkBase), isJson: true);
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
        title: const Text('地块编辑'),
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
                  controller: _textParkName,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '选择基地',
                    hintText: '基地',
                    errorText: errorFlag[0] == 1 ? '请选择基地' : '',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        int? ret = await showDialog<int>(
                          context: context,
                          builder: (content) {
                            return SimpleDialog(
                                title: const Text('选择基地'),
                                children: [
                                  SizedBox(
                                    height: 400.0,
                                    width: 400.0,
                                    child: ListView.builder(
                                      itemCount: listPark.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        Park curItem = listPark[index];
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
                            selectPark = listPark[ret];
                            _textParkName.text = selectPark!.name!;
                            _parkBase.parkId = selectPark!.id!;
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
                    errorText: errorFlag[0] == 1  ? '名称不能为空' : null,
                  ),
                ),
                Container(
                  height: kSpacing,
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
                  height: kSpacing,
                ),
                TextField(
                  controller: _textAreaUse,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '实用面积',
                    hintText: '输入实用面积',
                    errorText: errorFlag[2] == 1  ? '实用面积不能为空' : null,
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
                      errorText: errorFlag[3] == 1 ? '描述请填写' : null,
                    ),
                  ),
                ),

                Container(
                  height: kSpacing,
                ),
                Container(
                  child: InkWell(
                    onTap: uploadImage,
                    child: _parkBase.imageUrl != null
                        ?  Image(
                            image: NetworkImage(
                                '${HttpApi.host_image}${_parkBase.imageUrl}'),
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
          'userId': userInfo?.userId,
          'corpId': currentCorp?.id,
          'file':  MultipartFile( pFile.readStream as Stream<List<int>>, pFile.size, filename: pFile.name)
        });
      
        var ret = await DioUtils().requestUpload(
          HttpApi.open_gridfs_upload,
          data: formData
        );
      // print(json.encode(ret));
        setState((){
          _parkBase.imageUrl = ret['id'];
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
