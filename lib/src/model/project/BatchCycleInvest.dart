import 'dart:convert';

import 'package:agri_manager/src/model/product/Product.dart';
import 'package:agri_manager/src/model/project/BatchCycle.dart';
/// id : 1
/// batchCycleId : 1
/// description : ""
/// productId : 1
/// productSku : ""
/// price : 0.00
/// amount : 0.00
/// quantity : 50.0
/// createdAt : ""
/// updatedAt : ""
/// createdUserId : 1
/// batchId : 1
/// corpId : 1
/// product : {}
/// batchCycle : {}

BatchCycleInvest batchCycleInvestFromJson(String str) => BatchCycleInvest.fromJson(json.decode(str));
String batchCycleInvestToJson(BatchCycleInvest data) => json.encode(data.toJson());
class BatchCycleInvest {
  BatchCycleInvest({
      num? id, 
      num? batchCycleId, 
      String? description, 
      num? productId, 
      String? productSku, 
      num? price, 
      num? amount, 
      num? quantity, 
      String? createdAt, 
      String? updatedAt, 
      num? createdUserId, 
      num? batchId, 
      num? corpId, 
      Product? product,
      BatchCycle? batchCycle,}){
    _id = id;
    _batchCycleId = batchCycleId;
    _description = description;
    _productId = productId;
    _productSku = productSku;
    _price = price;
    _amount = amount;
    _quantity = quantity;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _createdUserId = createdUserId;
    _batchId = batchId;
    _corpId = corpId;
    _product = product;
    _batchCycle = batchCycle;
}

  BatchCycleInvest.fromJson(dynamic json) {
    _id = json['id'];
    _batchCycleId = json['batchCycleId'];
    _description = json['description'];
    _productId = json['productId'];
    _productSku = json['productSku'];
    _price = json['price'];
    _amount = json['amount'];
    _quantity = json['quantity'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _createdUserId = json['createdUserId'];
    _batchId = json['batchId'];
    _corpId = json['corpId'];
    _product = null != json['product'] ? Product.fromJson(json['product']) : null;
    _batchCycle = null != json['batchCycle']? BatchCycle.fromJson(json['batchCycle']): null;
  }
  num? _id;
  num? _batchCycleId;
  String? _description;
  num? _productId;
  String? _productSku;
  num? _price;
  num? _amount;
  num? _quantity;
  String? _createdAt;
  String? _updatedAt;
  num? _createdUserId;
  num? _batchId;
  num? _corpId;
  Product? _product;
  BatchCycle? _batchCycle;
BatchCycleInvest copyWith({  num? id,
  num? batchCycleId,
  String? description,
  num? productId,
  String? productSku,
  num? price,
  num? amount,
  num? quantity,
  String? createdAt,
  String? updatedAt,
  num? createdUserId,
  num? batchId,
  num? corpId,
  Product? product,
  BatchCycle? batchCycle,
}) => BatchCycleInvest(  id: id ?? _id,
  batchCycleId: batchCycleId ?? _batchCycleId,
  description: description ?? _description,
  productId: productId ?? _productId,
  productSku: productSku ?? _productSku,
  price: price ?? _price,
  amount: amount ?? _amount,
  quantity: quantity ?? _quantity,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  createdUserId: createdUserId ?? _createdUserId,
  batchId: batchId ?? _batchId,
  corpId: corpId ?? _corpId,
  product: product ?? _product,
  batchCycle: batchCycle ?? _batchCycle,
);
  num? get id => _id;
  num? get batchCycleId => _batchCycleId;
  String? get description => _description;
  num? get productId => _productId;
  String? get productSku => _productSku;
  num? get price => _price;
  num? get amount => _amount;
  num? get quantity => _quantity;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get createdUserId => _createdUserId;
  num? get batchId => _batchId;
  num? get corpId => _corpId;
  Product? get product => _product;
  BatchCycle? get batchCycle => _batchCycle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['batchCycleId'] = _batchCycleId;
    map['description'] = _description;
    map['productId'] = _productId;
    map['productSku'] = _productSku;
    map['price'] = _price;
    map['amount'] = _amount;
    map['quantity'] = _quantity;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['createdUserId'] = _createdUserId;
    map['batchId'] = _batchId;
    map['corpId'] = _corpId;
    map['product'] = _product?.toJson();
    map['batchCycle'] = _batchCycle?.toJson();
    return map;
  }

  set batchCycle(BatchCycle? value) {
    _batchCycle = value;
  }

  set product(Product? value) {
    _product = value;
  }

  set corpId(num? value) {
    _corpId = value;
  }

  set batchId(num? value) {
    _batchId = value;
  }

  set createdUserId(num? value) {
    _createdUserId = value;
  }

  set updatedAt(String? value) {
    _updatedAt = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set quantity(num? value) {
    _quantity = value;
  }

  set amount(num? value) {
    _amount = value;
  }

  set price(num? value) {
    _price = value;
  }

  set productSku(String? value) {
    _productSku = value;
  }

  set productId(num? value) {
    _productId = value;
  }

  set description(String? value) {
    _description = value;
  }

  set batchCycleId(num? value) {
    _batchCycleId = value;
  }

  set id(num? value) {
    _id = value;
  }
}