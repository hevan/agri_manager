import 'dart:convert';
/// token : ""

TokenBean tokenBeanFromJson(String str) => TokenBean.fromJson(json.decode(str));
String tokenBeanToJson(TokenBean data) => json.encode(data.toJson());
class TokenBean {
  TokenBean({
      String? token,}){
    _token = token;
}

  TokenBean.fromJson(dynamic json) {
    _token = json['token'];
  }
  String? _token;

  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    return map;
  }

}