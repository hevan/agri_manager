import 'dart:convert';

import 'package:agri_manager/src/model/product/Product.dart';
/// id : 1
/// expenseId : 1
/// productId : 1
/// productSku : ""
/// description : ""
/// amount : 9.00
/// price : 9.00
/// quantity : 9.00
/// createdAt : ""
/// product : {}

FinanceExpenseItem batchCycleExpenseItemFromJson(String str) => FinanceExpenseItem.fromJson(json.decode(str));
String batchCycleExpenseItemToJson(FinanceExpenseItem data) => json.encode(data.toJson());
class FinanceExpenseItem {
  FinanceExpenseItem({
      int? id,
      int? expenseId,
      int? productId,
      String? productSku, 
      String? description, 
      double? amount,
      double? price,
      double? quantity,
      String? createdAt, 
      Product? product,}){
    _id = id;
    _expenseId = expenseId;
    _productId = productId;
    _productSku = productSku;
    _description = description;
    _amount = amount;
    _price = price;
    _quantity = quantity;
    _createdAt = createdAt;
    _product = product;
}

  FinanceExpenseItem.fromJson(dynamic json) {
    _id = json['id'];
    _expenseId = json['expenseId'];
    _productId = json['productId'];
    _productSku = json['productSku'];
    _description = json['description'];
    _amount = json['amount'];
    _price = json['price'];
    _quantity = json['quantity'];
    _createdAt = json['createdAt'];
    _product = null != json['product'] ? Product.fromJson(json['product']) : null;
  }
  int? _id;
  int? _expenseId;
  int? _productId;
  String? _productSku;
  String? _description;
  double? _amount;
  double? _price;
  double? _quantity;
  String? _createdAt;
  Product? _product;
FinanceExpenseItem copyWith({  int? id,
  int? expenseId,
  int? productId,
  String? productSku,
  String? description,
  double? amount,
  double? price,
  double? quantity,
  String? createdAt,
  Product? product,
}) => FinanceExpenseItem(  id: id ?? _id,
  expenseId: expenseId ?? _expenseId,
  productId: productId ?? _productId,
  productSku: productSku ?? _productSku,
  description: description ?? _description,
  amount: amount ?? _amount,
  price: price ?? _price,
  quantity: quantity ?? _quantity,
  createdAt: createdAt ?? _createdAt,
  product: product ?? _product,
);
  int? get id => _id;
  int? get expenseId => _expenseId;
  int? get productId => _productId;
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
    map['expenseId'] = _expenseId;
    map['productId'] = _productId;
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

  set expenseId(int? value) {
    _expenseId = value;
  }

  set id(int? value) {
    _id = value;
  }
}