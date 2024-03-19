import 'dart:convert';

import 'package:agri_manager/src/model/manage/UserInfo.dart';
/// id : 0
/// name : ""
/// docType : ""
/// docUrl : ""
/// showImage : ""
/// groupName : ""
/// entityId : 0
/// entityName : ""
/// corpId : 0
/// createdAt : "2022-01-01"

DocResource docResourceFromJson(String str) => DocResource.fromJson(json.decode(str));
String docResourceToJson(DocResource data) => json.encode(data.toJson());
class DocResource {
  DocResource({
      int? id, 
      String? name, 
      String? docType,
      String? docExt,
      String? docUrl,
      String? showImage, 
      String? groupName, 
      int? entityId, 
      String? entityName, 
      int? corpId,
    int? createdUserId,
    String? createdAt,UserInfo? createdUser}){
    _id = id;
    _name = name;
    _docType = docType;
    _docType = docExt;
    _docUrl = docUrl;
    _showImage = showImage;
    _groupName = groupName;
    _entityId = entityId;
    _entityName = entityName;
    _corpId = corpId;
    _createdUserId = createdUserId;
    _createdAt = createdAt;
    _createdUser = createdUser;
}

  DocResource.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _docType = json['docType'];
    _docExt = json['docExt'];
    _docUrl = json['docUrl'];
    _showImage = json['showImage'];
    _groupName = json['groupName'];
    _entityId = json['entityId'];
    _entityName = json['entityName'];
    _corpId = json['corpId'];
    _createdUserId = json['createdUserId'];
    _createdAt = json['createdAt'];
    _createdUser = null != json['createdUser'] ? UserInfo.fromJson(json['createdUser']): null;
  }
  int? _id;
  String? _name;
  String? _docType;
  String? _docExt;
  String? _docUrl;
  String? _showImage;
  String? _groupName;
  int? _entityId;
  String? _entityName;
  int? _corpId;
  int? _createdUserId;
  String? _createdAt;
  UserInfo? _createdUser;

  int? get id => _id;
  String? get name => _name;
  String? get docExt => _docExt;
  String? get docType => _docType;
  String? get docUrl => _docUrl;
  String? get showImage => _showImage;
  String? get groupName => _groupName;
  int? get entityId => _entityId;
  String? get entityName => _entityName;
  int? get corpId => _corpId;
  int? get createdUserId => _createdUserId;
  String? get createdAt => _createdAt;
  UserInfo? get createdUser => _createdUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['docExt'] = _docExt;
    map['docType'] = _docType;
    map['docUrl'] = _docUrl;
    map['showImage'] = _showImage;
    map['groupName'] = _groupName;
    map['entityId'] = _entityId;
    map['entityName'] = _entityName;
    map['corpId'] = _corpId;
    map['createdUserId'] = _createdUserId;
    map['createdAt'] = _createdAt;
    map['createdUser'] = _createdUser?.toJson();
    return map;
  }

}