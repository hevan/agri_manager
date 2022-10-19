import 'dart:convert';
/// id : 1
/// productCycleId : 1
/// productCycleName : "11"
/// productId : 1
/// productName : "11"
/// investProductId : 1
/// investProductName : "11"
/// amount : 1.0
/// price : 2.0
/// quantity : 2

ProductCycleExpense productCycleExpenseFromJson(String str) => ProductCycleExpense.fromJson(json.decode(str));
String productCycleExpenseToJson(ProductCycleExpense data) => json.encode(data.toJson());
class ProductCycleExpense {
  ProductCycleExpense({
      int? id, 
      int? cycleId,
      String? cycleName,
      int? productId, 
      String? productName, 
      int? investProductId, 
      String? investProductName, 
      double? amount, 
      double? price, 
      int? quantity,}){
    _id = id;
    _cycleId = cycleId;
    _cycleName = cycleName;
    _productId = productId;
    _productName = productName;
    _investProductId = investProductId;
    _investProductName = investProductName;
    _amount = amount;
    _price = price;
    _quantity = quantity;
}

  ProductCycleExpense.fromJson(dynamic json) {
    _id = json['id'];
    _cycleId = json['cycleId'];
    _cycleName = json['cycleName'];
    _productId = json['productId'];
    _productName = json['productName'];
    _investProductId = json['investProductId'];
    _investProductName = json['investProductName'];
    _amount = json['amount'];
    _price = json['price'];
    _quantity = json['quantity'];
  }
  int? _id;
  int? _cycleId;
  String? _cycleName;
  int? _productId;
  String? _productName;
  int? _investProductId;
  String? _investProductName;
  double? _amount;
  double? _price;
  int? _quantity;
ProductCycleExpense copyWith({  int? id,
  int? cycleId,
  String? cycleName,
  int? productId,
  String? productName,
  int? investProductId,
  String? investProductName,
  double? amount,
  double? price,
  int? quantity,
}) => ProductCycleExpense(  id: id ?? _id,
  cycleId: cycleId ?? cycleId,
  cycleName: cycleName ?? _cycleName,
  productId: productId ?? _productId,
  productName: productName ?? _productName,
  investProductId: investProductId ?? _investProductId,
  investProductName: investProductName ?? _investProductName,
  amount: amount ?? _amount,
  price: price ?? _price,
  quantity: quantity ?? _quantity,
);
  int? get id => _id;
  int? get cycleId => _cycleId;
  String? get cycleName => _cycleName;
  int? get productId => _productId;
  String? get productName => _productName;
  int? get investProductId => _investProductId;
  String? get investProductName => _investProductName;
  double? get amount => _amount;
  double? get price => _price;
  int? get quantity => _quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['cycleId'] = _cycleId;
    map['cycleName'] = _cycleName;
    map['productId'] = _productId;
    map['productName'] = _productName;
    map['investProductId'] = _investProductId;
    map['investProductName'] = _investProductName;
    map['amount'] = _amount;
    map['price'] = _price;
    map['quantity'] = _quantity;
    return map;
  }

  set quantity(int? value) {
    _quantity = value;
  }

  set price(double? value) {
    _price = value;
  }

  set amount(double? value) {
    _amount = value;
  }

  set investProductName(String? value) {
    _investProductName = value;
  }

  set investProductId(int? value) {
    _investProductId = value;
  }

  set productName(String? value) {
    _productName = value;
  }

  set productId(int? value) {
    _productId = value;
  }

  set cycleName(String? value) {
    _cycleName = value;
  }

  set cycleId(int? value) {
    _cycleId = value;
  }

  set id(int? value) {
    _id = value;
  }
}