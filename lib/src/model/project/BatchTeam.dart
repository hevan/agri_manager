import 'dart:convert';

import 'package:agri_manager/src/model/business/CheckManager.dart';
/// id : 1
/// batchId : 1
/// userId : 1
/// isManager : true
/// createdAt : ""
/// user : {}

BatchTeam batchTeamFromJson(String str) => BatchTeam.fromJson(json.decode(str));
String batchTeamToJson(BatchTeam data) => json.encode(data.toJson());
class BatchTeam {
  BatchTeam({
      num? id, 
      num? batchId, 
      num? userId, 
      bool? isManager, 
      String? createdAt, 
      CheckManager? user,}){
    _id = id;
    _batchId = batchId;
    _userId = userId;
    _isManager = isManager;
    _createdAt = createdAt;
    _user = user;
}

  BatchTeam.fromJson(dynamic json) {
    _id = json['id'];
    _batchId = json['batchId'];
    _userId = json['userId'];
    _isManager = json['isManager'];
    _createdAt = json['createdAt'];
    _user = null != json['user'] ? CheckManager.fromJson(json['user']): null;
  }
  num? _id;
  num? _batchId;
  num? _userId;
  bool? _isManager;
  String? _createdAt;
  CheckManager? _user;
BatchTeam copyWith({  num? id,
  num? batchId,
  num? userId,
  bool? isManager,
  String? createdAt,
  CheckManager? user,
}) => BatchTeam(  id: id ?? _id,
  batchId: batchId ?? _batchId,
  userId: userId ?? _userId,
  isManager: isManager ?? _isManager,
  createdAt: createdAt ?? _createdAt,
  user: user ?? _user,
);
  num? get id => _id;
  num? get batchId => _batchId;
  num? get userId => _userId;
  bool? get isManager => _isManager;
  String? get createdAt => _createdAt;
  CheckManager? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['batchId'] = _batchId;
    map['userId'] = _userId;
    map['isManager'] = _isManager;
    map['createdAt'] = _createdAt;
    map['user'] = _user?.toJson();
    return map;
  }

  set user(CheckManager? value) {
    _user = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set isManager(bool? value) {
    _isManager = value;
  }

  set userId(num? value) {
    _userId = value;
  }

  set batchId(num? value) {
    _batchId = value;
  }

  set id(num? value) {
    _id = value;
  }
}