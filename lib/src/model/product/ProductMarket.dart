import 'dart:convert';
/// id : 1
/// productId : 1
/// productName : ""
/// marketId : 1
/// marketName : ""
/// priceWholesale : 60.6
/// priceRetal : 55.00
/// unit : "2020-01-01"
/// occurAt : "2020-01-01"
/// corpId : 1

ProductMarket productMarketFromJson(String str) => ProductMarket.fromJson(json.decode(str));
String productMarketToJson(ProductMarket data) => json.encode(data.toJson());
class ProductMarket {
  ProductMarket({
      int? id, 
      int? productId, 
      String? productName, 
      int? marketId, 
      String? marketName, 
      double? priceWholesale, 
      double? priceRetal, 
      String? unit, 
      String? occurAt,
      int? corpId,}){
    _id = id;
    _productId = productId;
    _productName = productName;
    _marketId = marketId;
    _marketName = marketName;
    _priceWholesale = priceWholesale;
    _priceRetal = priceRetal;
    _unit = unit;
    _occurAt = occurAt;
    _corpId = corpId;
}

  set id(int? value) {
    _id = value;
  }

  ProductMarket.fromJson(dynamic json) {
    _id = json['id'];
    _productId = json['productId'];
    _productName = json['productName'];
    _marketId = json['marketId'];
    _marketName = json['marketName'];
    _priceWholesale = json['priceWholesale'];
    _priceRetal = json['priceRetal'];
    _unit = json['unit'];
    _occurAt = json['occurAt'];
    _corpId = json['corpId'];
  }
  int? _id;
  int? _productId;
  String? _productName;
  int? _marketId;
  String? _marketName;
  double? _priceWholesale;
  double? _priceRetal;
  String? _unit;
  String? _occurAt;
  int? _corpId;
ProductMarket copyWith({  int? id,
  int? productId,
  String? productName,
  int? marketId,
  String? marketName,
  double? priceWholesale,
  double? priceRetal,
  String? unit,
  String? occurAt,
  int? corpId,
}) => ProductMarket(  id: id ?? _id,
  productId: productId ?? _productId,
  productName: productName ?? _productName,
  marketId: marketId ?? _marketId,
  marketName: marketName ?? _marketName,
  priceWholesale: priceWholesale ?? _priceWholesale,
  priceRetal: priceRetal ?? _priceRetal,
  unit: unit ?? _unit,
  occurAt: occurAt ?? _occurAt,
  corpId: corpId ?? _corpId,
);
  int? get id => _id;
  int? get productId => _productId;
  String? get productName => _productName;
  int? get marketId => _marketId;
  String? get marketName => _marketName;
  double? get priceWholesale => _priceWholesale;
  double? get priceRetal => _priceRetal;
  String? get unit => _unit;
  String? get occurAt => _occurAt;
  int? get corpId => _corpId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['productId'] = _productId;
    map['productName'] = _productName;
    map['marketId'] = _marketId;
    map['marketName'] = _marketName;
    map['priceWholesale'] = _priceWholesale;
    map['priceRetal'] = _priceRetal;
    map['unit'] = _unit;
    map['occurAt'] = _occurAt;
    map['corpId'] = _corpId;
    return map;
  }

  set productId(int? value) {
    _productId = value;
  }

  set productName(String? value) {
    _productName = value;
  }

  set marketId(int? value) {
    _marketId = value;
  }

  set marketName(String? value) {
    _marketName = value;
  }

  set priceWholesale(double? value) {
    _priceWholesale = value;
  }

  set priceRetal(double? value) {
    _priceRetal = value;
  }

  set unit(String? value) {
    _unit = value;
  }

  set occurAt(String? value) {
    _occurAt = value;
  }

  set corpId(int? value) {
    _corpId = value;
  }
}