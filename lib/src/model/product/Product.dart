import 'dart:convert';

import 'package:znny_manager/src/model/product/Category.dart';

/// id : 1
/// name : "方成"
/// code : "54s5d4as5d45"
/// categoryId : 2
/// imageUrl : "63bbc03ea527a37a958899f8"
/// calcUnit : "元"
/// corpId : 1
/// createdAt : "2022-12-13 11:09:47"
/// createdBy : "1"
/// updatedAt : "2023-01-02 11:09:33"
/// updatedBy : "21"
/// description : "方成方成方成方成方成"
/// category : {"id":2,"pathName":"/img/","name":"食用","imageUrl":"/img/sdjiasjdi.jpg","parentId":0,"corpId":1}

Product productFromJson(String str) => Product.fromJson(json.decode(str));
String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    int? id,
    String? name,
    String? code,
    int? categoryId,
    String? imageUrl,
    String? calcUnit,
    int? corpId,
    String? createdAt,
    String? createdBy,
    String? updatedAt,
    String? updatedBy,
    String? description,
    Category? category,
  }) {
    _id = id;
    _name = name;
    _code = code;
    _categoryId = categoryId;
    _imageUrl = imageUrl;
    _calcUnit = calcUnit;
    _corpId = corpId;
    _createdAt = createdAt;
    _createdBy = createdBy;
    _updatedAt = updatedAt;
    _updatedBy = updatedBy;
    _description = description;
    _category = category;
  }

  Product.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _categoryId = json['categoryId'];
    _imageUrl = json['imageUrl'];
    _calcUnit = json['calcUnit'];
    _corpId = json['corpId'];
    _createdAt = json['createdAt'];
    _createdBy = json['createdBy'];
    _updatedAt = json['updatedAt'];
    _updatedBy = json['updatedBy'];
    _description = json['description'];
    _category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }
  int? _id;
  String? _name;
  String? _code;
  int? _categoryId;
  String? _imageUrl;
  String? _calcUnit;
  int? _corpId;
  String? _createdAt;
  String? _createdBy;
  String? _updatedAt;
  String? _updatedBy;
  String? _description;
  Category? _category;
  Product copyWith({
    int? id,
    String? name,
    String? code,
    int? categoryId,
    String? imageUrl,
    String? calcUnit,
    int? corpId,
    String? createdAt,
    String? createdBy,
    String? updatedAt,
    String? updatedBy,
    String? description,
    Category? category,
  }) =>
      Product(
        id: id ?? _id,
        name: name ?? _name,
        code: code ?? _code,
        categoryId: categoryId ?? _categoryId,
        imageUrl: imageUrl ?? _imageUrl,
        calcUnit: calcUnit ?? _calcUnit,
        corpId: corpId ?? _corpId,
        createdAt: createdAt ?? _createdAt,
        createdBy: createdBy ?? _createdBy,
        updatedAt: updatedAt ?? _updatedAt,
        updatedBy: updatedBy ?? _updatedBy,
        description: description ?? _description,
        category: category ?? _category,
      );
  int? get id => _id;
  String? get name => _name;
  String? get code => _code;
  int? get categoryId => _categoryId;
  String? get imageUrl => _imageUrl;
  String? get calcUnit => _calcUnit;
  int? get corpId => _corpId;
  String? get createdAt => _createdAt;
  String? get createdBy => _createdBy;
  String? get updatedAt => _updatedAt;
  String? get updatedBy => _updatedBy;
  String? get description => _description;
  Category? get category => _category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['categoryId'] = _categoryId;
    map['imageUrl'] = _imageUrl;
    map['calcUnit'] = _calcUnit;
    map['corpId'] = _corpId;
    map['createdAt'] = _createdAt;
    map['createdBy'] = _createdBy;
    map['updatedAt'] = _updatedAt;
    map['updatedBy'] = _updatedBy;
    map['description'] = _description;
    if (_category != null) {
      map['category'] = _category?.toJson();
    }
    return map;
  }

  set category(Category? value) {
    _category = value;
  }

  set description(String? value) {
    _description = value;
  }

  set updatedBy(String? value) {
    _updatedBy = value;
  }

  set updatedAt(String? value) {
    _updatedAt = value;
  }

  set createdBy(String? value) {
    _createdBy = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set corpId(int? value) {
    _corpId = value;
  }

  set calcUnit(String? value) {
    _calcUnit = value;
  }

  set imageUrl(String? value) {
    _imageUrl = value;
  }

  set categoryId(int? value) {
    _categoryId = value;
  }

  set code(String? value) {
    _code = value;
  }

  set name(String? value) {
    _name = value;
  }

  set id(int? value) {
    _id = value;
  }
}
