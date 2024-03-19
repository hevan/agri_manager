import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_number/mobile_number.dart';



class LoginAuto extends StatefulWidget {
  const LoginAuto({Key? key}) : super(key: key);

  @override
  State<LoginAuto> createState() => _LoginAutoState();
}

class _LoginAutoState extends State<LoginAuto> {
  String phoneNumber = '';


  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      phoneNumber = (await MobileNumber.mobileNumber)!;

    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }

  @override
  void initState(){
    super.initState();

    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });

    initMobileNumberState();

  }


  Future login(BuildContext context) async {

    if(phoneNumber.length > 5){

    }else{
      return;
    }

    try {
      EasyLoading.show(status: '正在登录...');
      var data = {
        'mobile': phoneNumber
      };

      var retData = await DioUtils().request(
          HttpApi.user_login_mobile, 'POST', data: json.encode(data), isJson: true);

      EasyLoading.dismiss();

      if (retData['token'] != null) {
        debugPrint(json.encode(retData));
        SpUtil.putObject(Constant.accessToken, retData)?.then((value) => Navigator.of(context).popAndPushNamed("/home"));

      }
    }on DioError catch (error) {
      EasyLoading.dismiss();
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/bg_start.jpeg'), fit: BoxFit.cover),
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

                        SizedBox(height: height / 3 ),
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
                              child:  Text(
                                '手机号${phoneNumber}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
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
                              Navigator.of(context).pushNamed('/login');
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
                                    Colors.red[200]!.withOpacity(0.8),
                                    Colors.red[300]!.withOpacity(0.8),
                                    Colors.red[600]!.withOpacity(0.8),
                                  ],
                                ),
                              ),
                              child: const Text(
                                '账号密码登录',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
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

  onWillPop() {
    return true;
  }
}
