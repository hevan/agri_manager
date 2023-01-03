import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:znny_manager/src/net/interceptors/AuthInterceptor.dart';

class DioUtils {
  static final DioUtils _singleton = DioUtils._();

  static DioUtils get instance => DioUtils();

  factory DioUtils() => _singleton;

  static Dio? _dio;

  Dio get dio => _dio!;

  DioUtils._() {

    // 不使用http状态码判断状态，需要设置followRedirects， validateStatus
    var options = BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
      responseType: ResponseType.json,
      baseUrl: 'http://localhost:8080',
      contentType: 'application/x-www-form-urlencoded',
    );
    _dio = Dio(options);

    _dio!.interceptors.add(AuthInterceptor());

    /// 刷新Token
    //_dio.interceptors.add(TokenInterceptor());
    /// 打印Log(生产模式去除)
    //if (!Constant.inProduction) {
    _dio!.interceptors.add(LogInterceptor());
    //}
    /// 适配数据(根据自己的数据结构，可自行选择添加)
    //_dio.interceptors.add(AdapterInterceptor());
  }

  // 数据返回格式统一，统一处理异常
  Future request( String url, String method,
      {dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        bool? isJson = false}) async {
    try{
    final Response response = await _dio!.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options, isJson));

      /// 集成测试无法使用 isolate https://github.com/flutter/flutter/issues/24703
      ///
      //Log.e('请求接口： response.data' + response.data.toString());
      //print(response.data);

      log('请求接口： response.data' + response.data.toString());

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch(error){
       log('请求接口： response.data${error.message}');
       rethrow;
    }
  }

  Options _checkOptions(method, options, isJson) {
    if (options == null) {
      options = Options();
      if (isJson) {
        options = Options(contentType: "application/json");
      } else {
        options = Options(contentType: "application/x-www-form-urlencoded");
      }
    }
    options.method = method;
    return options;
  }

  Future requestUpload( String url,
      {dynamic data}) async {
    try{
      var response  = await request(url, "POST",  data: data, options: Options(contentType: 'multipart/form-data', responseType: ResponseType.json));

      return response;
    } on DioError catch(error){
      rethrow;
    }
  }
}