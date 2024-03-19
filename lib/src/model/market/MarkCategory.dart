import 'dart:convert';
/// id : 1
/// name : "test"
/// imageUrl : "444"
/// parentId : 1

MarkCategory markCategoryFromJson(String str) => MarkCategory.fromJson(json.decode(str));
String markCategoryToJson(MarkCategory data) => json.encode(data.toJson());
class MarkCategory {
  MarkCategory({
      num? id, 
      String? name, 
      String? imageUrl, 
      num? parentId,}){
    _id = id;
    _name = name;
    _imageUrl = imageUrl;
    _parentId = parentId;
}

  MarkCategory.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _imageUrl = json['imageUrl'];
    _parentId = json['parentId'];
  }
  num? _id;
  String? _name;
  String? _imageUrl;
  num? _parentId;
MarkCategory copyWith({  num? id,
  String? name,
  String? imageUrl,
  num? parentId,
}) => MarkCategory(  id: id ?? _id,
  name: name ?? _name,
  imageUrl: imageUrl ?? _imageUrl,
  parentId: parentId ?? _parentId,
);
  num? get id => _id;
  String? get name => _name;
  String? get imageUrl => _imageUrl;
  num? get parentId => _parentId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['imageUrl'] = _imageUrl;
    map['parentId'] = _parentId;
    return map;
  }

  set parentId(num? value) {
    _parentId = value;
  }

  set imageUrl(String? value) {
    _imageUrl = value;
  }

  set name(String? value) {
    _name = value;
  }

  set id(num? value) {
    _id = value;
  }
}