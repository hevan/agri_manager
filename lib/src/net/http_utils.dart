import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sp_util/sp_util.dart';
import 'package:znny_manager/src/utils/constants.dart';

typedef onError = void Function(int statusCode, Object error);
typedef onSuccess = void Function(dynamic data);
// typedef onTransform = dynamic Function(dynamic body);
const statusErrorCode = -200;

class HttpUtils {
  ///get request
  static Future requestGet(String url, onSuccess success,
      {bool isJson = false, Map<String, String>? params,  onError? error}) async {
    if(params != null) {
      url = joinParams(params, url);
    }
    try {
      Uri uri = Uri.parse(url);
      Map<String,String> headers = genRequestHeaders(url, isJson);
      http.Response response = await http.get(uri, headers: headers);
      checkResponseData(response,  success, error);
    } catch (e) {
      print("package:net/network.dart error get data:$e");
      if (error != null) {
        error(statusErrorCode, e.toString());
      }
    }
  }

  ///Stitching parameters(拼接参数)
  static String joinParams(Map<String, String>? params, String url) {
    if (params != null && params.isNotEmpty) {
      StringBuffer stringBuffer = StringBuffer('?');
      params.forEach((key, value) {
        stringBuffer.write('$key=$value&');
      });
      String paramStr = stringBuffer.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url = url + paramStr;
      debugPrint(url);
    }
    return url;
  }

  ///post request
  static Future<dynamic> requestPost(String url, onSuccess success,
      {bool isJson = true, Object? data, Map<String, String>? params, onError? error}) async {

    if(params != null) {
      url = joinParams(params, url);
    }
    try {
      Uri uri = Uri.parse(url);
      Map<String,String> headers = genRequestHeaders(url, isJson);
      http.Response response = await http.post(
        uri,
        body: data,
        headers: headers
      );
      checkResponseData(response, success, error);
    } catch (e) {
      print("package:net/network.dart error post data:$e");
      if (error != null) {
        error(statusErrorCode, e.toString());
      }
    }
  }

  static Future<dynamic> requestPut(String url, onSuccess success,
      {bool isJson = true, Object? data, Map<String, String>? params, onError? error}) async {

    if(params != null) {
      url = joinParams(params, url);
    }
    try {
      Uri uri = Uri.parse(url);
      Map<String,String> headers = genRequestHeaders(url, isJson);
      http.Response response = await http.put(
          uri,
          body: data,
          headers: headers
      );
      checkResponseData(response, success, error);
    } catch (e) {
      print("package:net/network.dart error post data:$e");
      if (error != null) {
        error(statusErrorCode, e.toString());
      }
    }
  }

  static Future<dynamic> requestDelete(String url, onSuccess success,
      {bool isJson = true, Object? data, Map<String, String>? params, onError? error}) async {

    if(params != null) {
      url = joinParams(params, url);
    }
    try {
      Uri uri = Uri.parse(url);
      Map<String,String> headers = genRequestHeaders(url, isJson);
      http.Response response = await http.delete(
          uri,
          body: data,
          headers: headers
      );
      checkResponseData(response, success, error);
    } catch (e) {
      print("package:net/network.dart error delete data:$e");
      if (error != null) {
        error(statusErrorCode, e.toString());
      }
    }
  }

  ///处理response
  static void checkResponseData(http.Response response,
      onSuccess success, onError? error) {
    if (response.statusCode == 200) {
      dynamic data = response.body;
      print("success get data:$data");
      success(json.encode(data));
    } else {
      print('Request get failed with status: ${response.statusCode}');
      if (error != null) {
        error(response.statusCode, "fail get data");
      }
    }
  }
  static Map<String, String> genRequestHeaders(String url, bool isJson){

    Map<String, String> requestHeaders = {
      'Accept': 'application/json'
    };

    if(isJson){
      requestHeaders['Content-Type'] = 'application/json';
    }
    if(url.contains("secure")) {
      String? accessToken = SpUtil.getString(Constant.accessToken);
      debugPrint(accessToken);
      if (accessToken != null) {
        requestHeaders[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
        requestHeaders['Authorization'] = 'Bearer $accessToken';
        requestHeaders["Access-Control-Allow-Credentials"] = 'true';
      }
    }

    debugPrint(requestHeaders.toString());
    return requestHeaders;
  }
}