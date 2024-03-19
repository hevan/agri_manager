import 'dart:convert';
/// userId : 1
/// nickName : ""
/// headerUrl : ""
/// status : 0

CheckManager checkManagerFromJson(String str) => CheckManager.fromJson(json.decode(str));
String checkManagerToJson(CheckManager data) => json.encode(data.toJson());
class CheckManager {
  CheckManager({
      int? userId, 
      String? nickName, 
      String? headerUrl,
    String? mobile,
    int? status,}){
    _userId = userId;
    _nickName = nickName;
    _mobile = mobile;
    _headerUrl = headerUrl;
    _status = status;
}

  CheckManager.fromJson(dynamic json) {
    _userId = json['userId'];
    _nickName = json['nickName'];
    _headerUrl = json['headerUrl'];
    _mobile = json['mobile'];
    _status = json['status'];
  }
  int? _userId;
  String? _nickName;
  String? _mobile;
  String? _headerUrl;
  int? _status;
CheckManager copyWith({  int? userId,
  String? nickName,
  String? headerUrl,
  String? mobile,
  int? status,
}) => CheckManager(  userId: userId ?? _userId,
  nickName: nickName ?? _nickName,
  mobile: mobile ?? _mobile,
  headerUrl: headerUrl ?? _headerUrl,
  status: status ?? _status,
);
  int? get userId => _userId;
  String? get nickName => _nickName;
  String? get headerUrl => _headerUrl;
  String? get mobile => _mobile;
  int? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    map['nickName'] = _nickName;
    map['mobile'] = _mobile;
    map['headerUrl'] = _headerUrl;
    map['status'] = _status;
    return map;
  }

  set userId(int? value) {
    _userId = value;
  }

  set nickName(String? value) {
    _nickName = value;
  }

  set headerUrl(String? value) {
    _headerUrl = value;
  }

  set mobile(String? value) {
    _mobile = value;
  }

  set status(int? value) {
    _status = value;
  }
}