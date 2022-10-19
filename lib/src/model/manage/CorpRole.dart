import 'dart:convert';
/// id : 1
/// name : ""
/// corpId : 2

CorpRole corpRoleFromJson(String str) => CorpRole.fromJson(json.decode(str));
String corpRoleToJson(CorpRole data) => json.encode(data.toJson());
class CorpRole {
  CorpRole({
      int? id, 
      String? name, 
      int? corpId,}){
    _id = id;
    _name = name;
    _corpId = corpId;
}

  CorpRole.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _corpId = json['corpId'];
  }
  int? _id;
  String? _name;
  int? _corpId;
CorpRole copyWith({  int? id,
  String? name,
  int? corpId,
}) => CorpRole(  id: id ?? _id,
  name: name ?? _name,
  corpId: corpId ?? _corpId,
);
  int? get id => _id;
  String? get name => _name;
  int? get corpId => _corpId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['corpId'] = _corpId;
    return map;
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CorpRole &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _name == other._name &&
          _corpId == other._corpId;

  @override
  int get hashCode => _id.hashCode ^ _name.hashCode ^ _corpId.hashCode;

  set corpId(int? value) {
    _corpId = value;
  }

  set name(String? value) {
    _name = value;
  }

  set id(int? value) {
    _id = value;
  }
}