import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class DioSocketException extends SocketException {
    late String message;

    DioSocketException(
        message, {
          osError,
          address,
          port,
        }) : super(
      message,
      osError: osError,
      address: address,
      port: port,
    );
  }

class CustomAppException{
  final String _message;
  final int _code;
  CustomAppException(
      this._code,
      this._message,
      );

  String toString() {
    return "$_code$_message";
  }

  String getMessage() {
    return _message;
  }

  Future isConnected()  async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  factory CustomAppException.create(DioError err)  {
    if (err.error is SocketException) {
      err.error = DioSocketException(
        err.message,
        osError: err.error?.osError,
        address: err.error?.address,
        port: err.error?.port,
      );
    }
    // dio默认的错误实例，如果是没有网络，只能得到一个未知错误，无法精准的得知是否是无网络的情况
    if (err.type == DioErrorType.other) {
      //bool isConnectNetWork = await isConnected();
     // if (!isConnectNetWork && err.error is DioSocketException) {
        err.error.message = "当前网络不可用，请检查您的网络";
     // }
    }
    int  code=-1;
    String showError = "";
    switch (err.type) {
      case DioErrorType.cancel:
        {
          showError = "请求取消";
          break;
        }
      case DioErrorType.connectTimeout:
        {
          showError = "链接超时";
          break;
        }
      case DioErrorType.sendTimeout:
        {
          showError = '请求超时';
          break;
        }
      case DioErrorType.receiveTimeout:
        {
          showError = '响应超时';
          break;
        }
      case DioErrorType.response:
        {
          try {
            int? errCode = 10000;


            if(err.response != null){
              errCode = err.response!.statusCode;
            }

            print(err);

            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
            code = errCode!;

            print(errCode);
            switch (errCode) {
              case 400:
                {
                  showError = "请求参数语法错误";
                  break;
                }
              case 401:
                {
                  showError = "访问接口权限错误";
                  break;
                }
              case 403:
                {
                  showError = "访问接口权限错误";
                  break;
                }
              case 404:
                {
                  showError= "没有发现数据";
                  break;
                }
              case 405:
                {
                  showError= "请求方法被禁止";
                  break;
                }
              case 500:
                {
                  showError= "服务器内部错误";
                  break;
                }
              case 502:
                {
                  showError =  "无效的请求";
                  break;
                }
              case 503:
                {
                  showError =  "服务器挂了";
                  break;
                }
              case 505:
                {
                  showError =  "不支持HTTP协议请求";
                   break;
                }
              case 10000:
                {
                  showError =  "服务器无法访问";
                  break;
                }
              default:
                {
                  // return ErrorEntity(code: errCode, message: "未知错误");
                  showError = err.response!.statusMessage!;
                }
            }
          } on Exception catch (_) {
            showError = "未知错误";
          }
          break;
        }
      default:
        {
          showError =  err.error.message;
        }
    }
    return  CustomAppException(code, showError);
  }
}
