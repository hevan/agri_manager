import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  String oldPwd = '';
  String newPwd = '';
  String confirmPwd = '';
  final TextEditingController oldPwdController = TextEditingController();
  final TextEditingController newPwdController = TextEditingController();
  final TextEditingController confirmPwdController = TextEditingController();

  final FocusNode oldPwdFocus = FocusNode();
  final FocusNode newPwdFocus = FocusNode();
  final FocusNode confirmPwdFocus = FocusNode();


  bool _showPassword = true;

  @override
  void initState() {
    super.initState();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        title: const Text('重设密码'),
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
                  '重设密码',
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
                    obscureText: _showPassword,
                    focusNode: oldPwdFocus,
                    controller: oldPwdController,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration:  InputDecoration(
                        contentPadding: const EdgeInsets.all(18.0),
                        border: const OutlineInputBorder(),
                        hintText: '原密码',
                        labelText: '原密码',
                        suffixIcon: GestureDetector(
                        onTap: _togglePasswordVisibility,
                        child: _showPassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      ),
                    ),
                    onEditingComplete: () {
                      FocusScope.of(context)
                          .requestFocus(newPwdFocus);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  decoration: const BoxDecoration(
                    borderRadius:
                     BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: TextField(
                    obscureText: _showPassword,
                    focusNode: newPwdFocus,
                    controller: newPwdController,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration:  InputDecoration(
                      contentPadding: const EdgeInsets.all(18.0),
                      border: const OutlineInputBorder(),
                      hintText: '新密码',
                      labelText: '新密码',
                      suffixIcon: GestureDetector(
                        onTap: _togglePasswordVisibility,
                        child: _showPassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      ),

                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  decoration: const BoxDecoration(
                    borderRadius:
                     BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: TextField(
                    obscureText: _showPassword,
                    focusNode: confirmPwdFocus,
                    controller: confirmPwdController,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration:  InputDecoration(
                      contentPadding: const EdgeInsets.all(18.0),
                      border: const OutlineInputBorder(),
                      hintText: '确认新密码',
                      labelText: '确认新密码',
                      suffixIcon: GestureDetector(
                        onTap: _togglePasswordVisibility,
                        child: _showPassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      ),

                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30.0),
                  onTap: resetPassword,
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
                      '确定',
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
  Future resetPassword() async {
    if('' == oldPwdController.text){
      Fluttertoast.showToast(
        msg:'请输入原密码',
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 18.0,
      );

      return;
    }

    if('' == newPwdController.text){
      Fluttertoast.showToast(
        msg:'请输入新密码',
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 18.0,
      );

      return;
    }

    if('' == confirmPwdController.text){
      Fluttertoast.showToast(
        msg:'请确认新密码',
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 18.0,
      );

      return;
    }

    if(confirmPwdController.text != newPwdController.text){
      Fluttertoast.showToast(
        msg:'新密码和确认输入不一致',
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 18.0,
      );
      return;
    }

    try {
      EasyLoading.show(status: '正在处理...');
      var data = {
        'userId': widget.userId,
        'oldPassword': oldPwdController.text,
        'newPassword': newPwdController.text
      };

      var retData = await DioUtils().request(
          HttpApi.user_reset_pwd, 'PUT', data:json.encode(data), isJson: true);

      EasyLoading.dismiss();


        Navigator.of(context).pop();


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
}