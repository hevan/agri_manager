import 'dart:convert';

import 'package:agri_manager/src/model/sys/Address.dart';
/// id : 1
/// name : ""
/// marketType : ""
/// addressId : ""
/// address : {}

MarkMarket markMarketFromJson(String str) => MarkMarket.fromJson(json.decode(str));
String markMarketToJson(MarkMarket data) => json.encode(data.toJson());
class MarkMarket {
  MarkMarket({
      num? id, 
      String? name, 
      String? marketType, 
      num? addressId,
      Address? address,}){
    _id = id;
    _name = name;
    _marketType = marketType;
    _addressId = addressId;
    _address = address;
}

  MarkMarket.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _marketType = json['marketType'];
    _addressId = json['addressId'];
    _address = null != json['address'] ? Address.fromJson(json['address']) : null ;
  }
  num? _id;
  String? _name;
  String? _marketType;
  num? _addressId;
  Address? _address;
MarkMarket copyWith({  num? id,
  String? name,
  String? marketType,
  num? addressId,
  Address? address,
}) => MarkMarket(  id: id ?? _id,
  name: name ?? _name,
  marketType: marketType ?? _marketType,
  addressId: addressId ?? _addressId,
  address: address ?? _address,
);
  num? get id => _id;
  String? get name => _name;
  String? get marketType => _marketType;
  num? get addressId => _addressId;
  Address? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['marketType'] = _marketType;
    map['addressId'] = _addressId;
    map['address'] = _address?.toJson();
    return map;
  }

  set address(Address? value) {
    _address = value;
  }

  set addressId(num? value) {
    _addressId = value;
  }

  set marketType(String? value) {
    _marketType = value;
  }

  set name(String? value) {
    _name = value;
  }

  set id(num? value) {
    _id = value;
  }
}