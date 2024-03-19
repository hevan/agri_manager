import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:agri_manager/src/model/manage/UserInfo.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:file_picker/file_picker.dart';

class UserProfileUpdate extends StatefulWidget {
  const UserProfileUpdate({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  State<UserProfileUpdate> createState() => _UserProfileUpdateState();
}

class _UserProfileUpdateState extends State<UserProfileUpdate> {

  final TextEditingController nickNameController = TextEditingController();

  final FocusNode nickNameFocus = FocusNode();

  String headerUrl = '';

  UserInfo userInfo = new UserInfo();

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future loadData() async{
    try {
      var retData = await DioUtils()
          .request('${HttpApi.user_find}${widget.userId}', "GET", isJson:true);
      debugPrint(json.encode(retData));
      if (retData != null) {
        debugPrint(json.encode(retData));
        setState(() {
          userInfo = UserInfo.fromJson(retData);

          nickNameController.text = userInfo.nickName!;
          if(userInfo.headerUrl != null) {
            headerUrl = userInfo.headerUrl!;
          }
        });
        debugPrint(json.encode(retData));
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
        title: const Text('设置个人信息'),
    ),
    body: SingleChildScrollView(
    child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10.0),
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  '修改个人信息',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  decoration: const BoxDecoration(
                    borderRadius:
                     BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: TextField(
                    focusNode: nickNameFocus,
                    controller: nickNameController,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration:  const InputDecoration(
                        contentPadding:  EdgeInsets.all(18.0),
                        border:  OutlineInputBorder(),
                        hintText: '用户名',
                        labelText: '用户名'
                      ),
                    )
                  ),
                ),

      Container(
        child: InkWell(
          onTap: uploadImage,
          child: headerUrl != ''
              ?  Image(
            image: NetworkImage(
                '${HttpApi.host_image}${headerUrl}'),
          )
              : Center(
            child:
            Image.asset('assets/icons/icon_add_image.png'),
          ),
        ),
        height: 200,
      ),

              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30.0),
                  onTap: toUpdate,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue[300]!.withOpacity(0.8),
                          Colors.blue[500]!.withOpacity(0.8),
                          Colors.blue[800]!.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: const Text(
                      '确认修改',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
  Future toUpdate() async {
    if('' == nickNameController.text){
      Fluttertoast.showToast(
        msg:'请输入用户名',
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 18.0,
      );

      return;
    }

    if('' == headerUrl){
      Fluttertoast.showToast(
        msg:'请上传您的头像',
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 18.0,
      );

      return;
    }


    try {
      EasyLoading.show(status: '正在处理...');

      userInfo.nickName = nickNameController.text;
      if(headerUrl != '') {
        userInfo.headerUrl = headerUrl;
      }
      log(json.encode(userInfo));

      var retData = await DioUtils().request(
          '${HttpApi.user_profile_update}${widget.userId}', 'PUT', data:json.encode(userInfo), isJson: true);

       EasyLoading.dismiss();

       if(retData != null) {
         Navigator.of(context).pop(jsonEncode(retData));
       }


    }on DioError catch (error) {
      EasyLoading.dismiss();
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
    }

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
          'userId': widget.userId,
          'corpId': 1,
          'file':  MultipartFile( pFile.readStream as Stream<List<int>>, pFile.size, filename: pFile.name)
        });

        var ret = await DioUtils().requestUpload(
            HttpApi.open_gridfs_upload,
            data: formData
        );
        // print(json.encode(ret));
        setState((){
          headerUrl = ret['id'];
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