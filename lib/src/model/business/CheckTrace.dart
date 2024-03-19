import 'dart:convert';

import 'package:agri_manager/src/model/manage/UserInfo.dart';
/// id : 1
/// entityName : ""
/// entityId : ""
/// userId : 1
/// status : 1
/// corpId : 1
/// createdAt : ""
/// updatedAt : ""
/// title : ""
/// description : ""
/// createdUser : null

CheckTrace checkTraceFromJson(String str) => CheckTrace.fromJson(json.decode(str));
String checkTraceToJson(CheckTrace data) => json.encode(data.toJson());
class CheckTrace {
  CheckTrace({
      int? id, 
      String? entityName, 
      int? entityId,
      int? userId, 
      int? status, 
      int? corpId, 
      String? createdAt, 
      String? updatedAt, 
      String? title, 
      String? description, 
      UserInfo? createdUser,}){
    _id = id;
    _entityName = entityName;
    _entityId = entityId;
    _userId = userId;
    _status = status;
    _corpId = corpId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _title = title;
    _description = description;
    _createdUser = createdUser;
}

  CheckTrace.fromJson(dynamic json) {
    _id = json['id'];
    _entityName = json['entityName'];
    _entityId = json['entityId'];
    _userId = json['userId'];
    _status = json['status'];
    _corpId = json['corpId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _title = json['title'];
    _description = json['description'];
    _createdUser = null != json['createdUser']? UserInfo.fromJson(json["createdUser"]) : null;
  }
  int? _id;
  String? _entityName;
  int? _entityId;
  int? _userId;
  int? _status;
  int? _corpId;
  String? _createdAt;
  String? _updatedAt;
  String? _title;
  String? _description;
  UserInfo? _createdUser;
CheckTrace copyWith({  int? id,
  String? entityName,
  int? entityId,
  int? userId,
  int? status,
  int? corpId,
  String? createdAt,
  String? updatedAt,
  String? title,
  String? description,
  UserInfo? createdUser,
}) => CheckTrace(  id: id ?? _id,
  entityName: entityName ?? _entityName,
  entityId: entityId ?? _entityId,
  userId: userId ?? _userId,
  status: status ?? _status,
  corpId: corpId ?? _corpId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  title: title ?? _title,
  description: description ?? _description,
  createdUser: createdUser ?? _createdUser,
);
  int? get id => _id;
  String? get entityName => _entityName;
  int? get entityId => _entityId;
  int? get userId => _userId;
  int? get status => _status;
  int? get corpId => _corpId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get title => _title;
  String? get description => _description;
  UserInfo? get createdUser => _createdUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['entityName'] = _entityName;
    map['entityId'] = _entityId;
    map['userId'] = _userId;
    map['status'] = _status;
    map['corpId'] = _corpId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['title'] = _title;
    map['description'] = _description;
    map['createdUser'] = _createdUser?.toJson();
    return map;
  }

}