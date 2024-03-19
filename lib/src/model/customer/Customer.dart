import 'dart:convert';

import 'package:agri_manager/src/model/sys/Address.dart';
/// id : 0
/// name : ""
/// code : ""
/// isCustomer : 1
/// createdAt : "2022-01-05"
/// corpId : 1
/// managerName : ""
/// managerMobile : ""

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));
String customerToJson(Customer data) => json.encode(data.toJson());
class Customer {
  Customer({
      int? id, 
      String? name, 
      String? code, 
      bool? isCustomer,
      bool? isSupply,
      int? addressId,
      Address? address,
      String? createdAt,
      int? corpId,
    String? description,
    String? managerName,
      String? managerMobile}){
    _id = id;
    _name = name;
    _code = code;
    _isCustomer = isCustomer;
    _isSupply = isSupply;
    _addressId = addressId;
    _address = address;
    _createdAt = createdAt;
    _corpId = corpId;
    _managerName = managerName;
    _managerMobile = managerMobile;
}

  Customer.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _isCustomer = json['isCustomer'];
    _isSupply = json['isSupply'];
    _createdAt = json['createdAt'];
    _corpId = json['corpId'];
    _addressId = json['addressId'];
    _address = json['address'] != null ? Address.fromJson(json['address']) : null;
    _description = json['description'];
    _managerName = json['managerName'];
    _managerMobile = json['managerMobile'];
  }
  int? _id;
  String? _name;
  String? _code;
  bool? _isCustomer;
  bool? _isSupply;
  String? _createdAt;
  int? _corpId;
  int? _addressId;
  String? _description;
  String? _managerName;
  String? _managerMobile;
  Address? _address;

  int? get id => _id;
  String? get name => _name;
  String? get code => _code;
  bool? get isCustomer => _isCustomer;
  bool? get isSupply => _isSupply;
  int? get addressId => _addressId;
  String? get createdAt => _createdAt;
  int? get corpId => _corpId;
  Address? get address => _address;
  String? get description => _description;
  String? get managerName => _managerName;
  String? get managerMobile => _managerMobile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['isCustomer'] = _isCustomer;
    map['isSupply'] = _isSupply;
    map['createdAt'] = _createdAt;
    map['corpId'] = _corpId;
    map['addressId'] = _addressId;
    if(_address != null) {
      map['address'] = json.encode(_address?.toJson());
    }
    map['description'] = _description;
    map['managerName'] = _managerName;
    map['managerMobile'] = _managerMobile;
    return map;
  }

  set address(Address? value) {
    _address = value;
  }

  set managerMobile(String? value) {
    _managerMobile = value;
  }

  set managerName(String? value) {
    _managerName = value;
  }

  set description(String? value) {
    _description = value;
  }

  set addressId(int? value) {
    _addressId = value;
  }

  set corpId(int? value) {
    _corpId = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set isSupply(bool? value) {
    _isSupply = value;
  }

  set isCustomer(bool? value) {
    _isCustomer = value;
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