import 'dart:convert';
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

BatchCycleExpenseItem batchCycleExpenseItemFromJson(String str) => BatchCycleExpenseItem.fromJson(json.decode(str));
String batchCycleExpenseItemToJson(BatchCycleExpenseItem data) => json.encode(data.toJson());
class BatchCycleExpenseItem {
  BatchCycleExpenseItem({
      num? id, 
      num? expenseId, 
      num? productId, 
      String? productSku, 
      String? description, 
      num? amount, 
      num? price, 
      num? quantity, 
      String? createdAt, 
      dynamic product,}){
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

  BatchCycleExpenseItem.fromJson(dynamic json) {
    _id = json['id'];
    _expenseId = json['expenseId'];
    _productId = json['productId'];
    _productSku = json['productSku'];
    _description = json['description'];
    _amount = json['amount'];
    _price = json['price'];
    _quantity = json['quantity'];
    _createdAt = json['createdAt'];
    _product = json['product'];
  }
  num? _id;
  num? _expenseId;
  num? _productId;
  String? _productSku;
  String? _description;
  num? _amount;
  num? _price;
  num? _quantity;
  String? _createdAt;
  dynamic _product;
BatchCycleExpenseItem copyWith({  num? id,
  num? expenseId,
  num? productId,
  String? productSku,
  String? description,
  num? amount,
  num? price,
  num? quantity,
  String? createdAt,
  dynamic product,
}) => BatchCycleExpenseItem(  id: id ?? _id,
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
  num? get id => _id;
  num? get expenseId => _expenseId;
  num? get productId => _productId;
  String? get productSku => _productSku;
  String? get description => _description;
  num? get amount => _amount;
  num? get price => _price;
  num? get quantity => _quantity;
  String? get createdAt => _createdAt;
  dynamic get product => _product;

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
    map['product'] = _product;
    return map;
  }

}