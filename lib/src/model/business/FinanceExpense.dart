import 'dart:convert';

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

FinanceExpense batchCycleExpenseFromJson(String str) => FinanceExpense.fromJson(json.decode(str));
String batchCycleExpenseToJson(FinanceExpense data) => json.encode(data.toJson());
class FinanceExpense {
  FinanceExpense({
      int? id,
      String? cycleName, 
      String? name, 
      String? code, 
      String? expenseType,
      int? foundDirect,
      double? amount, 
      String? description, 
      int? corpId, 
      int? batchId, 
      int? checkStatus, 
      int? status, 
      String? createdAt, 
      int? createdUserId,
      String? occurAt,
    BatchProduct? batchProduct,
      UserInfo? createdUser,}){
    _id = id;
    _cycleName = cycleName;
    _name = name;
    _code = code;
    _expenseType = expenseType;
    _foundDirect = foundDirect;
    _amount = amount;
    _description = description;
    _corpId = corpId;
    _batchId = batchId;
    _checkStatus = checkStatus;
    _status = status;
    _createdAt = createdAt;
    _createdUserId = createdUserId;
    _occurAt = occurAt;
    _batchProduct = batchProduct;
    _createdUser = createdUser;
}

  FinanceExpense.fromJson(dynamic json) {
    _id = json['id'];
    _cycleName = json['cycleName'];
    _name = json['name'];
    _code = json['code'];
    _expenseType = json['expenseType'];
    _foundDirect = json['foundDirect'];
    _amount = json['amount'];
    _description = json['description'];
    _corpId = json['corpId'];
    _batchId = json['batchId'];
    _checkStatus = json['checkStatus'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _createdUserId = json['createdUserId'];
    _occurAt = json['occurAt'];
    _batchProduct = null != json['batchProduct'] ? BatchProduct.fromJson(json['batchProduct'] ):null;
    _createdUser = null != json['createdUser'] ? UserInfo.fromJson(json['createdUser'] ):null;
  }
  int? _id;
  String? _cycleName;
  String? _name;
  String? _code;
  String? _expenseType;
  double? _amount;
  String? _description;
  int? _foundDirect;
  int? _corpId;
  int? _batchId;
  int? _checkStatus;
  int? _status;
  String? _createdAt;
  int? _createdUserId;
  String? _occurAt;
  BatchProduct? _batchProduct;
  UserInfo? _createdUser;


FinanceExpense copyWith({  int? id,
  String? cycleName,
  String? name,
  String? code,
  String? expenseType,
  int? foundDirect,
  double? amount,
  String? description,
  int? corpId,
  int? batchId,
  int? checkStatus,
  int? status,
  String? createdAt,
  int? createdUserId,
  String? occurAt,
  BatchProduct? batchProduct,
  UserInfo? createdUser,
}) => FinanceExpense(  id: id ?? _id,
  cycleName: cycleName ?? _cycleName,
  name: name ?? _name,
  code: code ?? _code,
  expenseType: expenseType ?? _expenseType,
  foundDirect: foundDirect ?? _foundDirect,
  amount: amount ?? _amount,
  description: description ?? _description,
  corpId: corpId ?? _corpId,
  batchId: batchId ?? _batchId,
  checkStatus: checkStatus ?? _checkStatus,
  status: status ?? _status,
  createdAt: createdAt ?? _createdAt,
  createdUserId: createdUserId ?? _createdUserId,
  occurAt: occurAt ?? _occurAt,
  batchProduct: batchProduct ?? _batchProduct,
  createdUser: createdUser ?? _createdUser,
);
  int? get id => _id;
  String? get cycleName => _cycleName;
  String? get name => _name;
  String? get code => _code;
  String? get expenseType => _expenseType;
  int? get foundDirect => _foundDirect;
  double? get amount => _amount;
  String? get description => _description;
  int? get corpId => _corpId;
  int? get batchId => _batchId;
  int? get checkStatus => _checkStatus;
  int? get status => _status;
  String? get createdAt => _createdAt;
  int? get createdUserId => _createdUserId;
  String? get occurAt => _occurAt;
  BatchProduct? get batchProduct => _batchProduct;
  UserInfo? get createdUser => _createdUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['cycleName'] = _cycleName;
    map['name'] = _name;
    map['code'] = _code;
    map['expenseType'] = _expenseType;
    map['foundDirect'] = _foundDirect;
    map['amount'] = _amount;
    map['description'] = _description;
    map['corpId'] = _corpId;
    map['batchId'] = _batchId;
    map['checkStatus'] = _checkStatus;
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['createdUserId'] = _createdUserId;
    map['occurAt'] = _occurAt;
    map['batchProduct'] = _batchProduct?.toJson();
    map['createdUser'] = _createdUser?.toJson();
    return map;
  }

  set createdUser(UserInfo? value) {
    _createdUser = value;
  }

  set batchProduct(BatchProduct? value) {
    _batchProduct = value;
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

  set expenseType(String? value) {
    _expenseType = value;
  }

  set foundDirect(int? value) {
    _foundDirect = value;
  }

  set code(String? value) {
    _code = value;
  }

  set name(String? value) {
    _name = value;
  }

  set cycleName(String? value) {
    _cycleName = value;
  }

  set occurAt(String? value) {
    _occurAt = value;
  }

  set id(int? value) {
    _id = value;
  }
}