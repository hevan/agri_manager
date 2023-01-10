import 'dart:convert';

import 'package:znny_manager/src/model/manage/CorpDepart.dart';
import 'package:znny_manager/src/model/manage/CorpRole.dart';
/// corpId : 1
/// userId : 2
/// position : "总监"
/// nickName : "Hevan wang"
/// mobile : "18688868390"
/// headerUrl : "631aa4f543586e4a4d5b850b"
/// description : null
/// listCorpDepart : []
/// listCorpRole : []

CorpManagerInfo corpManagerInfoFromJson(String str) => CorpManagerInfo.fromJson(json.decode(str));
String corpManagerInfoToJson(CorpManagerInfo data) => json.encode(data.toJson());
class CorpManagerInfo {
  CorpManagerInfo({
    int? id,
    int? corpId,
      int? userId, 
      String? position,
      String? nickName, 
      String? mobile, 
      String? headerUrl, 
      String? description,
      List<CorpDepart>? listCorpDepart,
      List<CorpRole>? listCorpRole,}){
    _id = id;
    _corpId = corpId;
    _userId = userId;
    _position = position;
    _nickName = nickName;
    _mobile = mobile;
    _headerUrl = headerUrl;
    _description = description;
    _listCorpDepart = listCorpDepart;
    _listCorpRole = listCorpRole;
}

  CorpManagerInfo.fromJson(dynamic json) {
    _id = json['id'];
    _corpId = json['corpId'];
    _userId = json['userId'];
    _position = json['position'];
    _nickName = json['nickName'];
    _mobile = json['mobile'];
    _headerUrl = json['headerUrl'];
    _description = json['description'];
    if (json['listCorpDepart'] != null) {
      _listCorpDepart = [];
      json['listCorpDepart'].forEach((v) {
        _listCorpDepart?.add(CorpDepart.fromJson(v));
      });
    }
    if (json['listCorpRole'] != null) {
      _listCorpRole = [];
      json['listCorpRole'].forEach((v) {
        _listCorpRole?.add(CorpRole.fromJson(v));
      });
    }
  }
  int? _id;
  int? _corpId;
  int? _userId;
  String? _position;
  String? _nickName;
  String? _mobile;
  String? _headerUrl;
  String? _description;
  List<CorpDepart>? _listCorpDepart;
  List<CorpRole>? _listCorpRole;
CorpManagerInfo copyWith({ int? id, int? corpId,
  int? userId,
  String? position,
  bool? isManager,
  String? nickName,
  String? mobile,
  String? headerUrl,
  String? description,
  List<CorpDepart>? listCorpDepart,
  List<CorpRole>? listCorpRole,
}) => CorpManagerInfo(
  id: id ?? _id,
  corpId: corpId ?? _corpId,
  userId: userId ?? _userId,
  position: position ?? _position,
  nickName: nickName ?? _nickName,
  mobile: mobile ?? _mobile,
  headerUrl: headerUrl ?? _headerUrl,
  description: description ?? _description,
  listCorpDepart: listCorpDepart ?? _listCorpDepart,
  listCorpRole: listCorpRole ?? _listCorpRole,
);
  int? get id => _id;
  int? get corpId => _corpId;
  int? get userId => _userId;
  String? get position => _position;
  String? get nickName => _nickName;
  String? get mobile => _mobile;
  String? get headerUrl => _headerUrl;
  String? get description => _description;
  List<CorpDepart>? get listCorpDepart => _listCorpDepart;
  List<CorpRole>? get listCorpRole => _listCorpRole;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['corpId'] = _corpId;
    map['userId'] = _userId;
    map['position'] = _position;
    map['nickName'] = _nickName;
    map['mobile'] = _mobile;
    map['headerUrl'] = _headerUrl;
    map['description'] = _description;
    if (_listCorpDepart != null) {
      map['listCorpDepart'] = _listCorpDepart?.map((v) => v.toJson()).toList();
    }
    if (_listCorpRole != null) {
      map['listCorpRole'] = _listCorpRole?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  set listCorpRole(List<CorpRole>? value) {
    _listCorpRole = value;
  }

  set listCorpDepart(List<CorpDepart>? value) {
    _listCorpDepart = value;
  }

  set description(String? value) {
    _description = value;
  }

  set headerUrl(String? value) {
    _headerUrl = value;
  }

  set mobile(String? value) {
    _mobile = value;
  }

  set nickName(String? value) {
    _nickName = value;
  }


  set position(String? value) {
    _position = value;
  }

  set userId(int? value) {
    _userId = value;
  }

  set corpId(int? value) {
    _corpId = value;
  }

  set id(int? value) {
    _id = value;
  }
}