import 'dart:convert';

import 'package:agri_manager/src/model/product/Product.dart';
/// id : 1
/// orderId : 1
/// productId : 1
/// productSku : ""
/// description : ""
/// amount : 9.00
/// price : 9.00
/// quantity : 9.00
/// createdAt : ""
/// product : {}

SaleOrderItem saleOrderItemFromJson(String str) => SaleOrderItem.fromJson(json.decode(str));
String saleOrderItemToJson(SaleOrderItem data) => json.encode(data.toJson());
class SaleOrderItem {
  SaleOrderItem({
      int? id,
      int? orderId,
      int? productId,
      int? corpId,
      String? productSku, 
      String? description, 
      double? amount,
      double? price,
      double? quantity,
      String? createdAt, 
      Product? product,}){
    _id = id;
    _orderId = orderId;
    _productId = productId;
    _corpId = corpId;
    _productSku = productSku;
    _description = description;
    _amount = amount;
    _price = price;
    _quantity = quantity;
    _createdAt = createdAt;
    _product = product;
}

  SaleOrderItem.fromJson(dynamic json) {
    _id = json['id'];
    _orderId = json['orderId'];
    _productId = json['productId'];
    _corpId = json['corpId'];
    _productSku = json['productSku'];
    _description = json['description'];
    _amount = json['amount'];
    _price = json['price'];
    _quantity = json['quantity'];
    _createdAt = json['createdAt'];
    _product = null != json['product'] ? Product.fromJson(json['product']) : null;
  }
  int? _id;
  int? _orderId;
  int? _productId;
  int? _corpId;
  String? _productSku;
  String? _description;
  double? _amount;
  double? _price;
  double? _quantity;
  String? _createdAt;
  Product? _product;
SaleOrderItem copyWith({  int? id,
  int? orderId,
  int? productId,
  int? corpId,
  String? productSku,
  String? description,
  double? amount,
  double? price,
  double? quantity,
  String? createdAt,
  Product? product,
}) => SaleOrderItem(  id: id ?? _id,
  orderId: orderId ?? _orderId,
  productId: productId ?? _productId,
  corpId: corpId ?? _corpId,
  productSku: productSku ?? _productSku,
  description: description ?? _description,
  amount: amount ?? _amount,
  price: price ?? _price,
  quantity: quantity ?? _quantity,
  createdAt: createdAt ?? _createdAt,
  product: product ?? _product,
);
  int? get id => _id;
  int? get orderId => _orderId;
  int? get productId => _productId;
  int? get corpId => _corpId;
  String? get productSku => _productSku;
  String? get description => _description;
  double? get amount => _amount;
  double? get price => _price;
  double? get quantity => _quantity;
  String? get createdAt => _createdAt;
  Product? get product => _product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['orderId'] = _orderId;
    map['productId'] = _productId;
    map['corpId'] = _corpId;
    map['productSku'] = _productSku;
    map['description'] = _description;
    map['amount'] = _amount;
    map['price'] = _price;
    map['quantity'] = _quantity;
    map['createdAt'] = _createdAt;
    map['product'] = _product?.toJson();
    return map;
  }

  set product(Product? value) {
    _product = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set quantity(double? value) {
    _quantity = value;
  }

  set price(double? value) {
    _price = value;
  }

  set amount(double? value) {
    _amount = value;
  }

  set description(String? value) {
    _description = value;
  }

  set productSku(String? value) {
    _productSku = value;
  }

  set productId(int? value) {
    _productId = value;
  }

  set orderId(int? value) {
    _orderId = value;
  }

  set id(int? value) {
    _id = value;
  }

  set corpId(int? value) {
    _corpId = value;
  }
}