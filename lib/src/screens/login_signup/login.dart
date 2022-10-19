import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phoneNumber = '';
  String password = '';
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  bool _showPassword = true;

  Future login(BuildContext context) async {
    if('' == phoneController.text){
      Fluttertoast.showToast(
        msg:'请输入手机号码',
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 18.0,
      );

      return;
    }

    if('' == passwordController.text){
      Fluttertoast.showToast(
        msg:'请输入密码',
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 18.0,
      );

      return;
    }

    try {
      EasyLoading.show(status: 'loading...');
      var data = {
        'mobile': phoneController.text,
        'password': passwordController.text,
        'corpId': HttpApi.corpId.toString()
      };

      var retData = await DioUtils().request(
          HttpApi.user_login, 'POST', data: json.encode(data), isJson: true);

      EasyLoading.dismiss();

      if (retData['token'] != null) {
        SpUtil.putObject(Constant.accessToken, retData);
        SpUtil.putInt(Constant.userId, retData['userId']);
        Navigator.of(context).popAndPushNamed("/home");
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(1.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: WillPopScope(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                    ),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: <Widget>[
                        const SizedBox(height: 30.0),
                        const Padding(
                          padding: EdgeInsets.only(top: 20.0, left: 20.0),
                          child: Text(
                            '欢迎回来',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            '账号登录',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 70.0),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            padding: const EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200]?.withOpacity(0.3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: TextField(
                              focusNode: phoneFocus,
                              controller: phoneController,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(18.0),
                                border: InputBorder.none,
                                hintText: '手机号码'
                              ),
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(passwordFocus);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            padding: const EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200]?.withOpacity(0.3),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: TextField(
                              obscureText: _showPassword,
                              focusNode: passwordFocus,
                              controller: passwordController,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              keyboardType: TextInputType.number,
                              decoration:  InputDecoration(
                                  contentPadding: const EdgeInsets.all(18.0),
                                  border: InputBorder.none,
                                  hintText: '密码',
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
                            onTap: () {
                              login(context);
                            },
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
                                    Colors.red[300]!.withOpacity(0.8),
                                    Colors.red[500]!.withOpacity(0.8),
                                    Colors.red[800]!.withOpacity(0.8),
                                  ],
                                ),
                              ),
                              child: const Text(
                                '登录',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          '没有账号请联系管理员',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                      ],
                    ),
                  ),
                ),
              ),
              onWillPop: () async {
                bool exitStatus = onWillPop();
                if (exitStatus) {
                  exit(0);
                }
                return false;
              },
            ),
          ),
        ],
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  onWillPop() {
    return true;
  }
}
