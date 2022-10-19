import 'dart:convert';
/// id : 1
/// username : ""
/// password : ""
/// mobile : ""
/// nickName : ""
/// headerUrl : ""
/// enabled : true
/// signText : ""
/// corpId : ""
/// createdDate : ""

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));
String userInfoToJson(UserInfo data) => json.encode(data.toJson());
class UserInfo {
  UserInfo({
      int? id, 
      String? username, 
      String? password, 
      String? mobile, 
      String? nickName, 
      String? headerUrl, 
      bool? enabled, 
      String? signText, 
      int? corpId,
      String? createdDate,
      String? depart,
      String? roleDesc,
     }){
    _id = id;
    _username = username;
    _password = password;
    _mobile = mobile;
    _nickName = nickName;
    _headerUrl = headerUrl;
    _enabled = enabled;
    _signText = signText;
    _corpId = corpId;
    _createdDate = createdDate;
    _depart = depart;
    _roleDesc = roleDesc;
}

  UserInfo.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _password = json['password'];
    _mobile = json['mobile'];
    _nickName = json['nickName'];
    _headerUrl = json['headerUrl'];
    _enabled = json['enabled'];
    _signText = json['signText'];
    _corpId = json['corpId'];
    _createdDate = json['createdDate'];
    _depart = json['depart'];
    _roleDesc = json['roleDesc'];
  }
  int? _id;
  String? _username;
  String? _password;
  String? _mobile;
  String? _nickName;
  String? _headerUrl;
  bool? _enabled;
  String? _signText;
  int? _corpId;
  String? _createdDate;
  String? _depart;
  String? _roleDesc;

UserInfo copyWith({  int? id,
  String? username,
  String? password,
  String? mobile,
  String? nickName,
  String? headerUrl,
  bool? enabled,
  String? signText,
  int? corpId,
  String? createdDate,
  String? depart,
  String? roleDesc,
}) => UserInfo(  id: id ?? _id,
  username: username ?? _username,
  password: password ?? _password,
  mobile: mobile ?? _mobile,
  nickName: nickName ?? _nickName,
  headerUrl: headerUrl ?? _headerUrl,
  enabled: enabled ?? _enabled,
  signText: signText ?? _signText,
  corpId: corpId ?? _corpId,
  createdDate: createdDate ?? _createdDate,
  depart: depart ?? _depart,
  roleDesc: roleDesc ?? _roleDesc,
);
  int? get id => _id;
  String? get username => _username;
  String? get password => _password;
  String? get mobile => _mobile;
  String? get nickName => _nickName;
  String? get headerUrl => _headerUrl;
  bool? get enabled => _enabled;
  String? get signText => _signText;
  int? get corpId => _corpId;
  String? get createdDate => _createdDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['password'] = _password;
    map['mobile'] = _mobile;
    map['nickName'] = _nickName;
    map['headerUrl'] = _headerUrl;
    map['enabled'] = _enabled;
    map['signText'] = _signText;
    map['corpId'] = _corpId;
    map['createdDate'] = _createdDate;
    map['depart'] = _depart;
    map['roleDesc'] = _roleDesc;
    return map;
  }

  set createdDate(String? value) {
    _createdDate = value;
  }

  set corpId(int? value) {
    _corpId = value;
  }

  set signText(String? value) {
    _signText = value;
  }

  set enabled(bool? value) {
    _enabled = value;
  }

  set headerUrl(String? value) {
    _headerUrl = value;
  }

  set nickName(String? value) {
    _nickName = value;
  }

  set mobile(String? value) {
    _mobile = value;
  }

  set password(String? value) {
    _password = value;
  }

  set username(String? value) {
    _username = value;
  }

  String? get depart => _depart;

  set depart(String? value) {
    _depart = value;
  }

  set id(int? value) {
    _id = value;
  }

  String? get roleDesc => _roleDesc;

  set roleDesc(String? value) {
    _roleDesc = value;
  }
}