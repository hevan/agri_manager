import 'dart:convert';

import 'package:agri_manager/src/model/market/MarkMarket.dart';
import 'package:agri_manager/src/model/market/MarkProduct.dart';
/// id : 1
/// calcUnit : ""
/// priceWholesale : 5.2
/// priceRetal : 5.2
/// productId : 5
/// occurAt : "2022"
/// marketId : 6
/// quantity : 6
/// product : {}
/// market : {}

MarkProductMarket markProductMarketFromJson(String str) => MarkProductMarket.fromJson(json.decode(str));
String markProductMarketToJson(MarkProductMarket data) => json.encode(data.toJson());
class MarkProductMarket {
  MarkProductMarket({
      num? id, 
      String? calcUnit, 
      num? priceWholesale, 
      num? priceRetal, 
      num? productId, 
      String? occurAt, 
      num? marketId, 
      num? quantity, 
      MarkProduct? product,
      MarkMarket? market,}){
    _id = id;
    _calcUnit = calcUnit;
    _priceWholesale = priceWholesale;
    _priceRetal = priceRetal;
    _productId = productId;
    _occurAt = occurAt;
    _marketId = marketId;
    _quantity = quantity;
    _product = product;
    _market = market;
}

  MarkProductMarket.fromJson(dynamic json) {
    _id = json['id'];
    _calcUnit = json['calcUnit'];
    _priceWholesale = json['priceWholesale'];
    _priceRetal = json['priceRetal'];
    _productId = json['productId'];
    _occurAt = json['occurAt'];
    _marketId = json['marketId'];
    _quantity = json['quantity'];
    _product = null != json['product'] ? MarkProduct.fromJson(json['product']) : null;
    _market =  null != json['market'] ? MarkMarket.fromJson(json['market']) : null;
  }
  num? _id;
  String? _calcUnit;
  num? _priceWholesale;
  num? _priceRetal;
  num? _productId;
  String? _occurAt;
  num? _marketId;
  num? _quantity;
  MarkProduct? _product;
  MarkMarket? _market;


MarkProductMarket copyWith({  num? id,
  String? calcUnit,
  num? priceWholesale,
  num? priceRetal,
  num? productId,
  String? occurAt,
  num? marketId,
  num? quantity,
  MarkProduct? product,
  MarkMarket? market,
}) => MarkProductMarket(  id: id ?? _id,
  calcUnit: calcUnit ?? _calcUnit,
  priceWholesale: priceWholesale ?? _priceWholesale,
  priceRetal: priceRetal ?? _priceRetal,
  productId: productId ?? _productId,
  occurAt: occurAt ?? _occurAt,
  marketId: marketId ?? _marketId,
  quantity: quantity ?? _quantity,
  product: product ?? _product,
  market: market ?? _market,
);
  num? get id => _id;
  String? get calcUnit => _calcUnit;
  num? get priceWholesale => _priceWholesale;
  num? get priceRetal => _priceRetal;
  num? get productId => _productId;
  String? get occurAt => _occurAt;
  num? get marketId => _marketId;
  num? get quantity => _quantity;
  MarkProduct? get product => _product;
  MarkMarket? get market => _market;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['calcUnit'] = _calcUnit;
    map['priceWholesale'] = _priceWholesale;
    map['priceRetal'] = _priceRetal;
    map['productId'] = _productId;
    map['occurAt'] = _occurAt;
    map['marketId'] = _marketId;
    map['quantity'] = _quantity;
    map['product'] = _product?.toJson();
    map['market'] = _market?.toJson();
    return map;
  }

  set market(MarkMarket? value) {
    _market = value;
  }

  set product(MarkProduct? value) {
    _product = value;
  }

  set quantity(num? value) {
    _quantity = value;
  }

  set marketId(num? value) {
    _marketId = value;
  }

  set occurAt(String? value) {
    _occurAt = value;
  }

  set productId(num? value) {
    _productId = value;
  }

  set priceRetal(num? value) {
    _priceRetal = value;
  }

  set priceWholesale(num? value) {
    _priceWholesale = value;
  }

  set calcUnit(String? value) {
    _calcUnit = value;
  }

  set id(num? value) {
    _id = value;
  }
}