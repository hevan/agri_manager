import 'dart:convert';

import 'package:agri_manager/src/model/customer/Customer.dart';
import 'package:agri_manager/src/model/manage/UserInfo.dart';
import 'package:agri_manager/src/model/project/BatchProduct.dart';
/// id : 1
/// cycleName : ""
/// name : ""
/// code : ""
/// expenseType : ""
/// amount : 9.00
/// description : ""
/// corpId : 1
/// batchId : 1
/// checkStatus : 1
/// status : 1
/// createdAt : "209393 "
/// createdUserId : 1
/// batchProduct : {}
/// createdUser : {}

PurchaseOrder purchaseOrderFromJson(String str) => PurchaseOrder.fromJson(json.decode(str));
String purchaseOrderToJson(PurchaseOrder data) => json.encode(data.toJson());
class PurchaseOrder {
  PurchaseOrder({
      int? id,
      int? customerId,
      String? name, 
      String? code, 
      double? quantity,
      double? amount, 
      String? description, 
      int? corpId, 
      int? batchId, 
      int? checkStatus, 
      int? status, 
      String? createdAt,
      String? updatedAt,
    int? createdUserId,
      String? occurAt,
    BatchProduct? batchProduct,
      UserInfo? createdUser, Customer? customer}){
    _id = id;
    _customerId = customerId;
    _name = name;
    _code = code;
    _quantity = quantity;
    _amount = amount;
    _description = description;
    _corpId = corpId;
    _batchId = batchId;
    _checkStatus = checkStatus;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _createdUserId = createdUserId;
    _occurAt = occurAt;
    _batchProduct = batchProduct;
    _createdUser = createdUser;
}

  PurchaseOrder.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customerId'];
    _name = json['name'];
    _code = json['code'];
    _quantity = json['quantity'];
    _amount = json['amount'];
    _description = json['description'];
    _corpId = json['corpId'];
    _batchId = json['batchId'];
    _checkStatus = json['checkStatus'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _createdUserId = json['createdUserId'];
    _occurAt = json['occurAt'];
    _batchProduct = null != json['batchProduct'] ? BatchProduct.fromJson(json['batchProduct']) : null;
    _createdUser = null != json['createdUser'] ? UserInfo.fromJson(json['createdUser']) : null;
    _customer = null != json['customer'] ? Customer.fromJson(json['customer']) : null;
  }
  int? _id;
  String? _name;
  String? _code;
  int? _customerId;
  double? _quantity;
  double? _amount;
  String? _description;
  int? _corpId;
  int? _batchId;
  int? _checkStatus;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  int? _createdUserId;
  String? _occurAt;
  BatchProduct? _batchProduct;
  UserInfo? _createdUser;
  Customer? _customer;


PurchaseOrder copyWith({  int? id,
  int? customerId,
  String? name,
  String? code,
  double? quantity,
  double? amount,
  String? description,
  int? corpId,
  int? batchId,
  int? checkStatus,
  int? status,
  String? createdAt,
  String? updatedAt,
  int? createdUserId,
  String? occurAt,
  BatchProduct? batchProduct,
  UserInfo? createdUser,
  Customer? customer,
}) => PurchaseOrder(  id: id ?? _id,
  customerId: customerId ?? _customerId,
  name: name ?? _name,
  code: code ?? _code,
  quantity: quantity ?? _quantity,
  amount: amount ?? _amount,
  description: description ?? _description,
  corpId: corpId ?? _corpId,
  batchId: batchId ?? _batchId,
  checkStatus: checkStatus ?? _checkStatus,
  status: status ?? _status,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  createdUserId: createdUserId ?? _createdUserId,
  occurAt: occurAt ?? _occurAt,
  batchProduct: batchProduct ?? _batchProduct,
  createdUser: createdUser ?? _createdUser,
  customer: customer ?? _customer,
);
  int? get id => _id;
  int? get customerId => _customerId;
  String? get name => _name;
  String? get code => _code;
  double? get quantity => _quantity;
  double? get amount => _amount;
  String? get description => _description;
  int? get corpId => _corpId;
  int? get batchId => _batchId;
  int? get checkStatus => _checkStatus;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get createdUserId => _createdUserId;
  String? get occurAt => _occurAt;
  BatchProduct? get batchProduct => _batchProduct;
  UserInfo? get createdUser => _createdUser;
  Customer? get customer => _customer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customerId'] = _customerId;
    map['name'] = _name;
    map['code'] = _code;
    map['quantity'] = _quantity;
    map['amount'] = _amount;
    map['description'] = _description;
    map['corpId'] = _corpId;
    map['batchId'] = _batchId;
    map['checkStatus'] = _checkStatus;
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['createdUserId'] = _createdUserId;
    map['occurAt'] = _occurAt;
    map['batchProduct'] = _batchProduct?.toJson();
    map['createdUser'] = _createdUser?.toJson();
    map['customer'] = _customer?.toJson();
    return map;
  }

  set createdUser(UserInfo? value) {
    _createdUser = value;
  }

  set batchProduct(BatchProduct? value) {
    _batchProduct = value;
  }

  set customer(Customer? value) {
    _customer = value;
  }

  set createdUserId(int? value) {
    _createdUserId = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set status(int? value) {
    _status = value;
  }

  set checkStatus(int? value) {
    _checkStatus = value;
  }

  set batchId(int? value) {
    _batchId = value;
  }

  set corpId(int? value) {
    _corpId = value;
  }

  set description(String? value) {
    _description = value;
  }

  set amount(double? value) {
    _amount = value;
  }

  set quantity(double? value) {
    _quantity = value;
  }



  set code(String? value) {
    _code = value;
  }

  set name(String? value) {
    _name = value;
  }

  set customerId(int? value) {
    _customerId = value;
  }

  set occurAt(String? value) {
    _occurAt = value;
  }

  set id(int? value) {
    _id = value;
  }

  set updatedAt(String? value) {
    _updatedAt = value;
  }
}