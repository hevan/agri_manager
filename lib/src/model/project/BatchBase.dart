import 'dart:convert';

import 'package:agri_manager/src/model/base/Park.dart';
import 'package:agri_manager/src/model/base/ParkBaseDto.dart';
import 'package:agri_manager/src/model/project/BatchProductDto.dart';
/// id : 1
/// batchId : 1
/// parkBaseId : 1
/// area : 1.0
/// quantity : 1.0
/// description : ""
/// createdAt : ""
/// corpId : 1
/// imageUrl : ""
/// parkBaseDto : {}
/// batchProductDto : {}

BatchBase batchBaseFromJson(String str) => BatchBase.fromJson(json.decode(str));
String batchBaseToJson(BatchBase data) => json.encode(data.toJson());
class BatchBase {
  BatchBase({
      num? id, 
      num? batchId, 
      num? parkBaseId, 
      num? area, 
      num? quantity, 
      String? description, 
      String? createdAt, 
      num? corpId, 
      String? imageUrl, 
      ParkBaseDto? parkBaseDto, 
      BatchProductDto? batchProductDto,}){
    _id = id;
    _batchId = batchId;
    _parkBaseId = parkBaseId;
    _area = area;
    _quantity = quantity;
    _description = description;
    _createdAt = createdAt;
    _corpId = corpId;
    _imageUrl = imageUrl;
    _parkBaseDto = parkBaseDto;
    _batchProductDto = batchProductDto;
}

  BatchBase.fromJson(dynamic json) {
    _id = json['id'];
    _batchId = json['batchId'];
    _parkBaseId = json['parkBaseId'];
    _area = json['area'];
    _quantity = json['quantity'];
    _description = json['description'];
    _createdAt = json['createdAt'];
    _corpId = json['corpId'];
    _imageUrl = json['imageUrl'];
    _parkBaseDto = null != json['parkBaseDto'] ? ParkBaseDto.fromJson(json['parkBaseDto']) : null;
    _batchProductDto = null !=  json['batchProductDto'] ? BatchProductDto.fromJson(json['batchProductDto']) : null;
  }
  num? _id;
  num? _batchId;
  num? _parkBaseId;
  num? _area;
  num? _quantity;
  String? _description;
  String? _createdAt;
  num? _corpId;
  String? _imageUrl;
  ParkBaseDto? _parkBaseDto;
  BatchProductDto? _batchProductDto;
BatchBase copyWith({  num? id,
  num? batchId,
  num? parkBaseId,
  num? area,
  num? quantity,
  String? description,
  String? createdAt,
  num? corpId,
  String? imageUrl,
  ParkBaseDto? parkBaseDto,
  BatchProductDto? batchProductDto,
}) => BatchBase(  id: id ?? _id,
  batchId: batchId ?? _batchId,
  parkBaseId: parkBaseId ?? _parkBaseId,
  area: area ?? _area,
  quantity: quantity ?? _quantity,
  description: description ?? _description,
  createdAt: createdAt ?? _createdAt,
  corpId: corpId ?? _corpId,
  imageUrl: imageUrl ?? _imageUrl,
  parkBaseDto: parkBaseDto ?? _parkBaseDto,
  batchProductDto: batchProductDto ?? _batchProductDto,
);
  num? get id => _id;
  num? get batchId => _batchId;
  num? get parkBaseId => _parkBaseId;
  num? get area => _area;
  num? get quantity => _quantity;
  String? get description => _description;
  String? get createdAt => _createdAt;
  num? get corpId => _corpId;
  String? get imageUrl => _imageUrl;
  ParkBaseDto? get parkBaseDto => _parkBaseDto;
  BatchProductDto? get batchProductDto => _batchProductDto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['batchId'] = _batchId;
    map['parkBaseId'] = _parkBaseId;
    map['area'] = _area;
    map['quantity'] = _quantity;
    map['description'] = _description;
    map['createdAt'] = _createdAt;
    map['corpId'] = _corpId;
    map['imageUrl'] = _imageUrl;
    map['parkBaseDto'] = _parkBaseDto?.toJson();
    map['batchProductDto'] = _batchProductDto?.toJson();
    return map;
  }

  set batchProductDto(BatchProductDto? value) {
    _batchProductDto = value;
  }

  set parkBaseDto(ParkBaseDto? value) {
    _parkBaseDto = value;
  }

  set imageUrl(String? value) {
    _imageUrl = value;
  }

  set corpId(num? value) {
    _corpId = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set description(String? value) {
    _description = value;
  }

  set quantity(num? value) {
    _quantity = value;
  }

  set area(num? value) {
    _area = value;
  }

  set parkBaseId(num? value) {
    _parkBaseId = value;
  }

  set batchId(num? value) {
    _batchId = value;
  }

  set id(num? value) {
    _id = value;
  }
}