import 'dart:convert';
/// token : ""

LoginInfoToken loginInfoTokenFromJson(String str) => LoginInfoToken.fromJson(json.decode(str));
String loginInfoTokenToJson(LoginInfoToken data) => json.encode(data.toJson());
class LoginInfoToken {
  LoginInfoToken({
      String? token, int? userId, String? nickName, String? mobile, String? headerUrl, int? expiration}){
    _token = token;
    _userId = userId;
    _nickName = nickName;
    _mobile = mobile;
    _headerUrl = headerUrl;
    _expiration = expiration;
}

  LoginInfoToken.fromJson(dynamic json) {
    _token = json['token'];
    _userId = json['userId'];
    _nickName = json['nickName'];
    _mobile = json['mobile'];
    _headerUrl = json['headerUrl'];
    _expiration = json['expiration'];
  }

  String? _token;
  int? _userId;
  String? _nickName;
  String? _mobile;
  String? _headerUrl;
  int? _expiration;

  String? get token => _token;

  set token(String? value) {
    _token = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['userId'] = _userId;
    map['nickName'] = _nickName;
    map['mobile'] = _mobile;
    map['headerUrl'] = _headerUrl;
    map['expiration'] = _expiration;
    return map;
  }

  int? get userId => _userId;

  set userId(int? value) {
    _userId = value;
  }

  String? get nickName => _nickName;

  set nickName(String? value) {
    _nickName = value;
  }

  String? get mobile => _mobile;

  set mobile(String? value) {
    _mobile = value;
  }

  String? get headerUrl => _headerUrl;

  set headerUrl(String? value) {
    _headerUrl = value;
  }

  int? get expiration => _expiration;

  set expiration(int? value) {
    _expiration = value;
  }
}