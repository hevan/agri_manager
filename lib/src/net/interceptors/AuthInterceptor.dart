import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/utils/constants.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.uri.toString().contains('secure')) {
      LoginInfoToken tokenMap = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));


      if (null != tokenMap && null != tokenMap.token) {
        debugPrint(tokenMap.token);
        options.headers['Authorization'] = 'Bearer ${tokenMap.token}';
        options.headers['Access-Control-Expose-Headers'] = "*";

      }

      handler.next(options);

    } else {
      handler.next(options);
    }
  }
}
