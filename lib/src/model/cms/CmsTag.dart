import 'dart:convert';
/// id : 1
/// name : ""
/// corpId : ""

CmsTag cmsTagFromJson(String str) => CmsTag.fromJson(json.decode(str));
String cmsTagToJson(CmsTag data) => json.encode(data.toJson());
class CmsTag {
  CmsTag({
      num? id, 
      String? name, 
      String? corpId,}){
    _id = id;
    _name = name;
    _corpId = corpId;
}

  CmsTag.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _corpId = json['corpId'];
  }
  num? _id;
  String? _name;
  String? _corpId;
CmsTag copyWith({  num? id,
  String? name,
  String? corpId,
}) => CmsTag(  id: id ?? _id,
  name: name ?? _name,
  corpId: corpId ?? _corpId,
);
  num? get id => _id;
  String? get name => _name;
  String? get corpId => _corpId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['corpId'] = _corpId;
    return map;
  }

}