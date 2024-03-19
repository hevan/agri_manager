import 'dart:convert';
/// id : 1
/// code : ""
/// name : ""
/// parentId : ""

CmsCategory cmsCategoryFromJson(String str) => CmsCategory.fromJson(json.decode(str));
String cmsCategoryToJson(CmsCategory data) => json.encode(data.toJson());
class CmsCategory {
  CmsCategory({
      num? id, 
      String? code, 
      String? name, 
      num? parentId,
    num? corpId,}){
    _id = id;
    _code = code;
    _name = name;
    _parentId = parentId;
    _corpId = corpId;
}

  CmsCategory.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _name = json['name'];
    _parentId = json['parentId'];
    _corpId = json['corpId'];
  }
  num? _id;
  String? _code;
  String? _name;
  num? _parentId;
  num? _corpId;

CmsCategory copyWith({  num? id,
  String? code,
  String? name,
  num? parentId,
  num? corpId,
}) => CmsCategory(  id: id ?? _id,
  code: code ?? _code,
  name: name ?? _name,
  parentId: parentId ?? _parentId,
  corpId: corpId ?? _corpId,
);
  num? get id => _id;
  String? get code => _code;
  String? get name => _name;
  num? get parentId => _parentId;
  num? get corpId => _corpId;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['name'] = _name;
    map['parentId'] = _parentId;
    map['corpId'] = _corpId;
    return map;
  }

  set corpId(num? value) {
    _corpId = value;
  }

  set parentId(num? value) {
    _parentId = value;
  }

  set name(String? value) {
    _name = value;
  }

  set code(String? value) {
    _code = value;
  }

  set id(num? value) {
    _id = value;
  }
}