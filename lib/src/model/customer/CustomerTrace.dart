import 'dart:convert';

import 'package:agri_manager/src/model/customer/Customer.dart';
/// id : 0
/// customerId : 0
/// customer : ""
/// linkName : ""
/// linkMobile : "2022-02-01"
/// createdUserId : 0
/// title : ""
/// description : ""
/// corpId : 2
/// createdAt : "2022-02-01"

CustomerTrace customerTraceFromJson(String str) => CustomerTrace.fromJson(json.decode(str));
String customerTraceToJson(CustomerTrace data) => json.encode(data.toJson());
class CustomerTrace {
  CustomerTrace({
      int? id, 
      int? customerId,
      String? linkName, 
      String? linkMobile, 
      int? createdUserId, 
      String? title, 
      String? description, 
      int? corpId, 
      String? createdAt, String? occurAt, Customer? customer}){
    _id = id;
    _customerId = customerId;
    _customer = customer;
    _linkName = linkName;
    _linkMobile = linkMobile;
    _createdUserId = createdUserId;
    _title = title;
    _description = description;
    _corpId = corpId;
    _createdAt = createdAt;
    _occurAt = occurAt;
}

  CustomerTrace.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customerId'];
    _customer = null != json['customer'] ? Customer.fromJson(json['customer']) : null;
    _linkName = json['linkName'];
    _linkMobile = json['linkMobile'];
    _createdUserId = json['createdUserId'];
    _title = json['title'];
    _description = json['description'];
    _corpId = json['corpId'];
    _createdAt = json['createdAt'];
    _occurAt = json['occurAt'];
  }
  int? _id;
  int? _customerId;
  String? _linkName;
  String? _linkMobile;
  int? _createdUserId;
  String? _title;
  String? _description;
  int? _corpId;
  String? _createdAt;
  String? _occurAt;
  Customer? _customer;

  int? get id => _id;
  int? get customerId => _customerId;
  Customer? get customer => _customer;
  String? get linkName => _linkName;
  String? get linkMobile => _linkMobile;
  int? get createdUserId => _createdUserId;
  String? get title => _title;
  String? get description => _description;
  int? get corpId => _corpId;
  String? get createdAt => _createdAt;
  String? get occurAt => _occurAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customerId'] = _customerId;
    map['customer'] = _customer?.toJson();
    map['linkName'] = _linkName;
    map['linkMobile'] = _linkMobile;
    map['createdUserId'] = _createdUserId;
    map['title'] = _title;
    map['description'] = _description;
    map['corpId'] = _corpId;
    map['occurAt'] = _occurAt;
    map['createdAt'] = _createdAt;
    return map;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set occurAt(String? value) {
    _occurAt = value;
  }

  set corpId(int? value) {
    _corpId = value;
  }

  set description(String? value) {
    _description = value;
  }

  set title(String? value) {
    _title = value;
  }

  set createdUserId(int? value) {
    _createdUserId = value;
  }

  set linkMobile(String? value) {
    _linkMobile = value;
  }

  set linkName(String? value) {
    _linkName = value;
  }

  set customer(Customer? value) {
    _customer = value;
  }

  set customerId(int? value) {
    _customerId = value;
  }

  set id(int? value) {
    _id = value;
  }
}