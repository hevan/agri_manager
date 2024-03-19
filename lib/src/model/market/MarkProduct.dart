import 'dart:convert';

import 'package:agri_manager/src/model/market/MarkCategory.dart';
/// id : 1
/// name : ""
/// code : ""
/// categoryId : 1
/// imageUrl : ""
/// calcUnit : ""
/// description : ""
/// markCategory : {}

MarkProduct markProductFromJson(String str) => MarkProduct.fromJson(json.decode(str));
String markProductToJson(MarkProduct data) => json.encode(data.toJson());
class MarkProduct {
  MarkProduct({
      num? id, 
      String? name, 
      String? code, 
      num? categoryId, 
      String? imageUrl, 
      String? calcUnit, 
      String? description, 
      MarkCategory? markCategory,}){
    _id = id;
    _name = name;
    _code = code;
    _categoryId = categoryId;
    _imageUrl = imageUrl;
    _calcUnit = calcUnit;
    _description = description;
    _markCategory = markCategory;
}

  MarkProduct.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _categoryId = json['categoryId'];
    _imageUrl = json['imageUrl'];
    _calcUnit = json['calcUnit'];
    _description = json['description'];
    _markCategory = null != json['markCategory'] ? MarkCategory.fromJson(json['markCategory']) : null;
  }
  num? _id;
  String? _name;
  String? _code;
  num? _categoryId;
  String? _imageUrl;
  String? _calcUnit;
  String? _description;
  MarkCategory? _markCategory;
MarkProduct copyWith({  num? id,
  String? name,
  String? code,
  num? categoryId,
  String? imageUrl,
  String? calcUnit,
  String? description,
  MarkCategory? markCategory,
}) => MarkProduct(  id: id ?? _id,
  name: name ?? _name,
  code: code ?? _code,
  categoryId: categoryId ?? _categoryId,
  imageUrl: imageUrl ?? _imageUrl,
  calcUnit: calcUnit ?? _calcUnit,
  description: description ?? _description,
  markCategory: markCategory ?? _markCategory,
);
  num? get id => _id;
  String? get name => _name;
  String? get code => _code;
  num? get categoryId => _categoryId;
  String? get imageUrl => _imageUrl;
  String? get calcUnit => _calcUnit;
  String? get description => _description;
  MarkCategory? get markCategory => _markCategory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['categoryId'] = _categoryId;
    map['imageUrl'] = _imageUrl;
    map['calcUnit'] = _calcUnit;
    map['description'] = _description;
    map['markCategory'] = null != _markCategory ? _markCategory!.toJson() : null;
    return map;
  }

  set markCategory(MarkCategory? value) {
    _markCategory = value;
  }

  set description(String? value) {
    _description = value;
  }

  set calcUnit(String? value) {
    _calcUnit = value;
  }

  set imageUrl(String? value) {
    _imageUrl = value;
  }

  set categoryId(num? value) {
    _categoryId = value;
  }

  set code(String? value) {
    _code = value;
  }

  set name(String? value) {
    _name = value;
  }

  set id(num? value) {
    _id = value;
  }
}