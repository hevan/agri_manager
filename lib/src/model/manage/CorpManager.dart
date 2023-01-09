import 'dart:convert';

import 'package:znny_manager/src/model/manage/CorpManagerDepart.dart';
import 'package:znny_manager/src/model/manage/CorpManagerRole.dart';
/// id : 1
/// userId : 2
/// corpId : 1
/// createdAt : "2022-12-06 00:00:00"
/// position : "总监"

CorpManager corpManagerFromJson(String str) => CorpManager.fromJson(json.decode(str));
String corpManagerToJson(CorpManager data) => json.encode(data.toJson());
class CorpManager {
  CorpManager({
      int? id, 
      int? userId, 
      int? corpId, 
      String? createdAt, 
      String? position,
    List<CorpManagerDepart>? listManagerDepart,
    List<CorpManagerRole>? listManagerRole,
     }){
    _id = id;
    _userId = userId;
    _corpId = corpId;
    _createdAt = createdAt;
    _position = position;
    _listManagerDepart = listManagerDepart;
    _listManagerRole = listManagerRole;
}

  CorpManager.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _corpId = json['corpId'];
    _createdAt = json['createdAt'];
    _position = json['position'];

    if (json['listManagerDepart'] != null) {
      _listManagerDepart = [];
      json['listManagerDepart'].forEach((v) {
        _listManagerDepart?.add(CorpManagerDepart.fromJson(v));
      });
    }
    if (json['listManagerRole'] != null) {
      _listManagerRole = [];
      json['listManagerRole'].forEach((v) {
        _listManagerRole?.add(CorpManagerRole.fromJson(v));
      });
    }
  }
  int? _id;
  int? _userId;
  int? _corpId;
  String? _createdAt;
  String? _position;
  List<CorpManagerDepart>? _listManagerDepart;
  List<CorpManagerRole>? _listManagerRole;
CorpManager copyWith({  int? id,
  int? userId,
  int? corpId,
  String? createdAt,
  String? position,
  List<CorpManagerDepart>? listManagerDepart,
  List<CorpManagerRole>? listManagerRole,
}) => CorpManager(  id: id ?? _id,
  userId: userId ?? _userId,
  corpId: corpId ?? _corpId,
  createdAt: createdAt ?? _createdAt,
  position: position ?? _position,
  listManagerDepart: listManagerDepart ?? _listManagerDepart,
  listManagerRole: listManagerRole ?? _listManagerRole,
);
  int? get id => _id;
  int? get userId => _userId;
  int? get corpId => _corpId;
  String? get createdAt => _createdAt;
  String? get position => _position;

  List<CorpManagerDepart>? get listManagerDepart => _listManagerDepart;
  List<CorpManagerRole>? get listManagerRole =>  _listManagerRole;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['corpId'] = _corpId;
    map['createdAt'] = _createdAt;
    map['position'] = _position;

    if (_listManagerDepart != null) {
      map['listManagerDepart'] = _listManagerDepart?.map((v) => v.toJson()).toList();
    }
    if (_listManagerRole != null) {
      map['listManagerRole'] = _listManagerRole?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}