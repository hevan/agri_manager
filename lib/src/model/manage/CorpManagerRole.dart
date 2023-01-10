import 'dart:convert';
/// id : 1
/// managerId : 1
/// roleId : 1

CorpManagerRole corpManagerRoleFromJson(String str) => CorpManagerRole.fromJson(json.decode(str));
String corpManagerRoleToJson(CorpManagerRole data) => json.encode(data.toJson());
class CorpManagerRole {
  CorpManagerRole({
      int? id, 
      int? managerId, 
      int? roleId,}){
    _id = id;
    _managerId = managerId;
    _roleId = roleId;
}

  CorpManagerRole.fromJson(dynamic json) {
    _id = json['id'];
    _managerId = json['managerId'];
    _roleId = json['roleId'];
  }
  int? _id;
  int? _managerId;
  int? _roleId;
CorpManagerRole copyWith({  int? id,
  int? managerId,
  int? roleId,
}) => CorpManagerRole(  id: id ?? _id,
  managerId: managerId ?? _managerId,
  roleId: roleId ?? _roleId,
);
  int? get id => _id;
  int? get managerId => _managerId;
  int? get roleId => _roleId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['managerId'] = _managerId;
    map['roleId'] = _roleId;
    return map;
  }

}