import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:sp_util/sp_util.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.uri.toString().contains('secure')) {
      Map? tokenMap = SpUtil.getObject(Constant.accessToken);
      //debugPrint(tokenMap['token']);
      if (null != tokenMap && null != tokenMap['token']) {
        options.headers['Authorization'] = 'Bearer ${tokenMap['token']}';
        options.headers['Access-Control-Expose-Headers'] = "*";
      }

     // else{
     //   navigatorKey.currentState.pushNamedAndRemoveUntil(
     //       "/login", (Route<dynamic> route) => false);
     //
     // }

      handler.next(options);
    } else {
      handler.next(options);
    }
  }
}
