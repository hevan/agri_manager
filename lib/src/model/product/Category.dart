import 'dart:convert';

/// id : 1
/// name : "test"
/// path : "name"
/// iconUrl : "444"
/// parentId : 1
/// children : [{"id":1,"name":"test","path":"name","iconUrl":"444","parentId":1,"children":[]}]

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));
String categoryToJson(Category data) => json.encode(data.toJson());
class Category {
  Category({
    int? id,
    String? name,
    String? pathName,
    String? imageUrl,
    int? parentId,
    int? corpId,
    List<Category>? children}){
    _id = id;
    _name = name;
    _pathName = pathName;
    _imageUrl = imageUrl;
    _parentId = parentId;
    _corpId = corpId;
    _children = children;
  }

  Category.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _pathName = json['pathName'];
    _imageUrl = json['imageUrl'];
    _parentId = json['parentId'];
    _corpId = json['corpId'];
    if (json['children'] != null) {
      _children = [];
      json['children'].forEach((v) {
        _children?.add(Category.fromJson(v));
      });
    }
  }
  int? _id;
  String? _name;
  String? _pathName;
  String? _imageUrl;
  int? _parentId;
  int? _corpId;
  List<Category>? _children;

  int? get id => _id;
  String? get name => _name;
  String? get pathName => _pathName;
  String? get imageUrl => _imageUrl;
  int? get parentId => _parentId;
  List<Category>? get children => _children;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['pathName'] = _pathName;
    map['imageUrl'] = _imageUrl;
    map['parentId'] = _parentId;
    map['corpId'] = _corpId;
    if (_children != null) {
      map['children'] = _children?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
