import 'dart:convert';
/// id : 1
/// userId : 1
/// blogId : 1
/// createdAt : ""
/// action : ""

CmsUserActive cmsUserActiveFromJson(String str) => CmsUserActive.fromJson(json.decode(str));
String cmsUserActiveToJson(CmsUserActive data) => json.encode(data.toJson());
class CmsUserActive {
  CmsUserActive({
      int? id, 
      int? userId, 
      int? blogId, 
      String? createdAt, 
      String? action,}){
    _id = id;
    _userId = userId;
    _blogId = blogId;
    _createdAt = createdAt;
    _action = action;
}

  CmsUserActive.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _blogId = json['blogId'];
    _createdAt = json['createdAt'];
    _action = json['action'];
  }
  int? _id;
  int? _userId;
  int? _blogId;
  String? _createdAt;
  String? _action;
CmsUserActive copyWith({  int? id,
  int? userId,
  int? blogId,
  String? createdAt,
  String? action,
}) => CmsUserActive(  id: id ?? _id,
  userId: userId ?? _userId,
  blogId: blogId ?? _blogId,
  createdAt: createdAt ?? _createdAt,
  action: action ?? _action,
);
  int? get id => _id;
  int? get userId => _userId;
  int? get blogId => _blogId;
  String? get createdAt => _createdAt;
  String? get action => _action;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['blogId'] = _blogId;
    map['createdAt'] = _createdAt;
    map['action'] = _action;
    return map;
  }

  set action(String? value) {
    _action = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set blogId(int? value) {
    _blogId = value;
  }

  set userId(int? value) {
    _userId = value;
  }

  set id(int? value) {
    _id = value;
  }
}