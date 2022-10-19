import 'dart:convert';
/// id : 5
/// productName : ""
/// productSku : ""
/// productId : 6
/// quantity : 10.0
/// price : 5.2
/// amount : 88.00
/// storeId : 10
/// createdBy : ""
/// createdAt : ""
/// updatedBy : ""
/// updatedAt : ""
/// corpId : 5

StoreItem storeItemFromJson(String str) => StoreItem.fromJson(json.decode(str));
String storeItemToJson(StoreItem data) => json.encode(data.toJson());
class StoreItem {
  StoreItem({
      int? id, 
      String? productName, 
      String? productSku, 
      int? productId, 
      double? quantity, 
      double? price, 
      double? amount, 
      int? storeId,
      String? storeName,
      String? createdBy,
      String? createdAt, 
      String? updatedBy, 
      String? updatedAt, 
      int? corpId,}){
    _id = id;
    _productName = productName;
    _productSku = productSku;
    _productId = productId;
    _quantity = quantity;
    _price = price;
    _amount = amount;
    _storeId = storeId;
    _storeName = storeName;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
    _corpId = corpId;
}

  StoreItem.fromJson(dynamic json) {
    _id = json['id'];
    _productName = json['productName'];
    _productSku = json['productSku'];
    _productId = json['productId'];
    _quantity = json['quantity'];
    _price = json['price'];
    _amount = json['amount'];
    _storeId = json['storeId'];
    _storeName = json['storeName'];
    _createdBy = json['createdBy'];
    _createdAt = json['createdAt'];
    _updatedBy = json['updatedBy'];
    _updatedAt = json['updatedAt'];
    _corpId = json['corpId'];
  }
  int? _id;
  String? _productName;
  String? _productSku;
  int? _productId;
  double? _quantity;
  double? _price;
  double? _amount;
  int? _storeId;
  String? _storeName;
  String? _createdBy;
  String? _createdAt;
  String? _updatedBy;
  String? _updatedAt;
  int? _corpId;
StoreItem copyWith({  int? id,
  String? productName,
  String? productSku,
  int? productId,
  double? quantity,
  double? price,
  double? amount,
  int? storeId,
  String? storeName,
  String? createdBy,
  String? createdAt,
  String? updatedBy,
  String? updatedAt,
  int? corpId,
}) => StoreItem(  id: id ?? _id,
  productName: productName ?? _productName,
  productSku: productSku ?? _productSku,
  productId: productId ?? _productId,
  quantity: quantity ?? _quantity,
  price: price ?? _price,
  amount: amount ?? _amount,
  storeId: storeId ?? _storeId,
  storeName: storeName ?? _storeName,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
  corpId: corpId ?? _corpId,
);
  int? get id => _id;
  String? get productName => _productName;
  String? get productSku => _productSku;
  int? get productId => _productId;
  double? get quantity => _quantity;
  double? get price => _price;
  double? get amount => _amount;
  int? get storeId => _storeId;
  String? get storeName => _storeName;
  String? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  String? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;
  int? get corpId => _corpId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['productName'] = _productName;
    map['productSku'] = _productSku;
    map['productId'] = _productId;
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['amount'] = _amount;
    map['storeId'] = _storeId;
    map['storeName'] = _storeName;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['updatedBy'] = _updatedBy;
    map['updatedAt'] = _updatedAt;
    map['corpId'] = _corpId;
    return map;
  }

}