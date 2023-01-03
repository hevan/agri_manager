import 'dart:convert';

import 'package:znny_manager/src/model/sys/Address.dart';
/// id : 1
/// name : "农业产业研究院"
/// code : "1001"
/// description : "农业，产业园，研发"
/// addressId : 1
/// createdAt : "2022-12-06 00:00:00"
/// address : {"id":1,"province":"广东省","city":"广州市","region":"天河区","lineDetail":"汇彩路8号","linkName":"王海文","linkMobile":"18688868390","location":null,"createdAt":"2022-12-06 00:00:00"}

Corp corpFromJson(String str) => Corp.fromJson(json.decode(str));
String corpToJson(Corp data) => json.encode(data.toJson());
class Corp {
  Corp({
      int? id,
      String? name, 
      String? code, 
      String? description, 
      int? addressId,
      String? createdAt, 
      Address? address,}){
    _id = id;
    _name = name;
    _code = code;
    _description = description;
    _addressId = addressId;
    _createdAt = createdAt;
    _address = address;
}

  Corp.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _description = json['description'];
    _addressId = json['addressId'];
    _createdAt = json['createdAt'];
    _address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }
  int? _id;
  String? _name;
  String? _code;
  String? _description;
  int? _addressId;
  String? _createdAt;
  Address? _address;
Corp copyWith({  int? id,
  String? name,
  String? code,
  String? description,
  int? addressId,
  String? createdAt,
  Address? address,
}) => Corp(  id: id ?? _id,
  name: name ?? _name,
  code: code ?? _code,
  description: description ?? _description,
  addressId: addressId ?? _addressId,
  createdAt: createdAt ?? _createdAt,
  address: address ?? _address,
);
  int? get id => _id;
  String? get name => _name;
  String? get code => _code;
  String? get description => _description;
  int? get addressId => _addressId;
  String? get createdAt => _createdAt;
  Address? get address => _address;


  set id(int? value) {
    _id = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['description'] = _description;
    map['addressId'] = _addressId;
    map['createdAt'] = _createdAt;
    if (_address != null) {
      map['address'] = _address?.toJson();
    }
    return map;
  }

  set name(String? value) {
    _name = value;
  }

  set code(String? value) {
    _code = value;
  }

  set description(String? value) {
    _description = value;
  }

  set addressId(int? value) {
    _addressId = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set address(Address? value) {
    _address = value;
  }
}

