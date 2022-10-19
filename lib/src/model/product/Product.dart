import 'dart:convert';
/// id : 0
/// name : ""
/// code : ""
/// imageUrl : ""
/// calcUnit : ""
/// description : ""
/// corpId : 0
/// categoryId : 1
/// createdAt : ""
/// createdBy : ""
/// updatedAt : ""
/// updatedBy : ""

Product productFromJson(String str) => Product.fromJson(json.decode(str));
String productToJson(Product data) => json.encode(data.toJson());
class Product {
  Product({
      int? id, 
      String? name, 
      String? code, 
      String? imageUrl, 
      String? calcUnit, 
      String? description, 
      int? corpId, 
      int? categoryId, 
      DateTime? createdAt,
      String? createdBy, 
      DateTime? updatedAt,
      String? updatedBy,
      String? categoryName,
  }){
    _id = id;
    _name = name;
    _code = code;
    _imageUrl = imageUrl;
    _calcUnit = calcUnit;
    _description = description;
    _corpId = corpId;
    _categoryId = categoryId;
    _createdAt = createdAt;
    _createdBy = createdBy;
    _updatedAt = updatedAt;
    _updatedBy = updatedBy;
}

  Product.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _imageUrl = json['imageUrl'];
    _calcUnit = json['calcUnit'];
    _description = json['description'];
    _corpId = json['corpId'];
    _categoryId = json['categoryId'];
    _categoryName = json['categoryName'];
    _createdAt = json['createdAt'];
    _createdBy = json['createdBy'];
    _updatedAt = json['updatedAt'];
    _updatedBy = json['updatedBy'];
  }
  int? _id;
  String? _name;
  String? _code;
  String? _imageUrl;
  String? _calcUnit;
  String? _description;
  int? _corpId;
  int? _categoryId;
  String? _categoryName;
  DateTime? _createdAt;
  String? _createdBy;
  DateTime? _updatedAt;
  String? _updatedBy;

  int? get id => _id;
  String? get name => _name;
  String? get code => _code;
  String? get imageUrl => _imageUrl;
  String? get calcUnit => _calcUnit;
  String? get description => _description;
  int? get corpId => _corpId;
  int? get categoryId => _categoryId;
  DateTime? get createdAt => _createdAt;
  String? get createdBy => _createdBy;
  DateTime? get updatedAt => _updatedAt;
  String? get updatedBy => _updatedBy;
  String? get categoryName => _categoryName;




  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['imageUrl'] = _imageUrl;
    map['calcUnit'] = _calcUnit;
    map['description'] = _description;
    map['corpId'] = _corpId;
    map['categoryId'] = _categoryId;
    map['createdAt'] = _createdAt;
    map['createdBy'] = _createdBy;
    map['updatedAt'] = _updatedAt;
    map['updatedBy'] = _updatedBy;
    map['categoryName'] = _categoryName;
    return map;
  }

  set id(int? id) {
    _id = id;
  }

  set name(String? name) {
    _name = name;
  }

  set code(String? code) {
    _code = code;
  }

  set imageUrl(String? imageUrl) {
    _imageUrl = imageUrl;
  }

  set calcUnit(String? calcUnit) {
    _calcUnit = calcUnit;
  }

  set description(String? description) {
    _description = description;
  }

  set corpId(int? corpId) {
    _corpId = corpId;
  }

  set categoryId(int? categoryId) {
    _categoryId = categoryId;
  }

  set createdAt(DateTime? createdAt) {
    _createdAt = createdAt;
  }

  set createdBy(String? createdBy) {
    _createdBy = createdBy;
  }

  set updatedAt(DateTime? updatedAt) {
    _updatedAt = updatedAt;
  }

  set updatedBy(String? updatedBy) {
    _updatedBy = updatedBy;
  }

  set categoryName(String? categoryName) {
    _categoryName = categoryName;
  }
}