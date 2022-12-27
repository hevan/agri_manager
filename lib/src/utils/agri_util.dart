
import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/sys/LoginInfoToken.dart';

class AgriUtil{
  static String hideMobile(String? mobile){
    if(mobile == null){
      return '';
    }else {
      String showMobile = '${mobile.substring(0, 3)}*****${mobile.substring(
          mobile.length - 3)}';

      return showMobile;
    }
  }
  
  static checkToken(LoginInfoToken loginInfoToken, BuildContext context){
    if(null != loginInfoToken.expiration) {
      int currentTime = DateTime
          .now()
          .millisecondsSinceEpoch;
      if (currentTime > loginInfoToken.expiration!) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            "/login", ModalRoute.withName('/'));
      }
    }
  }
}