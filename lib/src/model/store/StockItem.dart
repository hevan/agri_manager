import 'dart:convert';
/// id : 1
/// productName : ""
/// productSku : ""
/// productId : 1
/// quantity : 99.0
/// price : 6.00
/// amount : 19.00
/// direction : 1
/// storeName : ""
/// storeId : 1
/// stockId : 1
/// stockName : ""
/// occurAt : ""
/// createdBy : ""
/// createdAt : ""
/// updatedBy : ""
/// updatedAt : ""
/// corpId : 1

StockItem stockItemFromJson(String str) => StockItem.fromJson(json.decode(str));
String stockItemToJson(StockItem data) => json.encode(data.toJson());
class StockItem {
  StockItem({
      int? id, 
      String? productName, 
      String? productSku, 
      int? productId, 
      double? quantity, 
      double? price, 
      double? amount, 
      int? direction, 
      String? storeName, 
      int? storeId, 
      int? stockId, 
      String? stockName, 
      String? occurAt, 
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
    _direction = direction;
    _storeName = storeName;
    _storeId = storeId;
    _stockId = stockId;
    _stockName = stockName;
    _occurAt = occurAt;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
    _corpId = corpId;
}

  StockItem.fromJson(dynamic json) {
    _id = json['id'];
    _productName = json['productName'];
    _productSku = json['productSku'];
    _productId = json['productId'];
    _quantity = json['quantity'];
    _price = json['price'];
    _amount = json['amount'];
    _direction = json['direction'];
    _storeName = json['storeName'];
    _storeId = json['storeId'];
    _stockId = json['stockId'];
    _stockName = json['stockName'];
    _occurAt = json['occurAt'];
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
  int? _direction;
  String? _storeName;
  int? _storeId;
  int? _stockId;
  String? _stockName;
  String? _occurAt;
  String? _createdBy;
  String? _createdAt;
  String? _updatedBy;
  String? _updatedAt;
  int? _corpId;
StockItem copyWith({  int? id,
  String? productName,
  String? productSku,
  int? productId,
  double? quantity,
  double? price,
  double? amount,
  int? direction,
  String? storeName,
  int? storeId,
  int? stockId,
  String? stockName,
  String? occurAt,
  String? createdBy,
  String? createdAt,
  String? updatedBy,
  String? updatedAt,
  int? corpId,
}) => StockItem(  id: id ?? _id,
  productName: productName ?? _productName,
  productSku: productSku ?? _productSku,
  productId: productId ?? _productId,
  quantity: quantity ?? _quantity,
  price: price ?? _price,
  amount: amount ?? _amount,
  direction: direction ?? _direction,
  storeName: storeName ?? _storeName,
  storeId: storeId ?? _storeId,
  stockId: stockId ?? _stockId,
  stockName: stockName ?? _stockName,
  occurAt: occurAt ?? _occurAt,
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
  int? get direction => _direction;
  String? get storeName => _storeName;
  int? get storeId => _storeId;
  int? get stockId => _stockId;
  String? get stockName => _stockName;
  String? get occurAt => _occurAt;
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
    map['direction'] = _direction;
    map['storeName'] = _storeName;
    map['storeId'] = _storeId;
    map['stockId'] = _stockId;
    map['stockName'] = _stockName;
    map['occurAt'] = _occurAt;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['updatedBy'] = _updatedBy;
    map['updatedAt'] = _updatedAt;
    map['corpId'] = _corpId;
    return map;
  }

}