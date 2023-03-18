import 'dart:convert';

import 'package:znny_manager/src/model/base/Park.dart';
import 'package:znny_manager/src/model/manage/Corp.dart';
import 'package:znny_manager/src/model/product/Product.dart';
/// id : 1
/// name : ""
/// code : ""
/// productId : 1
/// productName : ""
/// parkId : 1
/// parkName : ""
/// quantity : ""
/// startAt : ""
/// endAt : ""
/// days : ""
/// estimatedProduction : 999999.00
/// realProduction : 9999.88
/// investEstimated : 9993.00
/// investReal : 9999.00
/// saleEstimated : 909090.00
/// saleReal : 909090.00
/// unit : ""
/// corpId : 5

BatchProduct productBatchFromJson(String str) => BatchProduct.fromJson(json.decode(str));
String productBatchToJson(BatchProduct data) => json.encode(data.toJson());
class BatchProduct {
  BatchProduct({
      int? id, 
      String? name, 
      String? code, 
      int? productId,
      int? parkId,
      String? startAt, 
      String? endAt, 
      int? days,
      double? estimatedProduction, 
      double? realProduction, 
      double? investEstimated, 
      double? investReal,
      int?    createdUserId,
      String? calcUnit,
      int? corpId,
      int? status,
      String? createdAt,
      String? description,
      Corp? corp,
      Park? park,
      Product? product
  }){
    _id = id;
    _name = name;
    _code = code;
    _productId = productId;
    _parkId = parkId;
    _startAt = startAt;
    _endAt = endAt;
    _days = days;
    _estimatedProduction = estimatedProduction;
    _realProduction = realProduction;
    _investEstimated = investEstimated;
    _investReal = investReal;
    _calcUnit = calcUnit;
    _status = status;
    _corpId = corpId;
    _createdUserId = createdUserId;
    _createdAt = createdAt;
    _description = description;

    _product = product;
    _park = park;
    _corp = corp;
}

  BatchProduct.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _productId = json['productId'];
    _parkId = json['parkId'];
    _startAt = json['startAt'];
    _endAt = json['endAt'];
    _days = json['days'];
    _estimatedProduction = json['estimatedProduction'];
    _realProduction = json['realProduction'];
    _investEstimated = json['investEstimated'];
    _investReal = json['investReal'];
    _calcUnit = json['calcUnit'];
    _corpId = json['corpId'];
    _status = json['status'];
    _createdUserId = json['createdUserId'];
    _createdAt = json['createdAt'];
    _description = json['description'];
    _park = null != json['park'] ? Park.fromJson(json['park']) : null;
    _corp = null != json['corp'] ? Corp.fromJson(json['corp']) : null;
    _product = null != json['product'] ? Product.fromJson(json['product']) : null;
  }
  int? _id;
  String? _name;
  String? _code;
  int? _productId;
  int? _parkId;
  String? _startAt;
  String? _endAt;
  int? _days;
  double? _estimatedProduction;
  double? _realProduction;
  double? _investEstimated;
  double? _investReal;
  double? _saleEstimated;
  double? _saleReal;
  String? _calcUnit;
  int? _status;
  int? _corpId;
  int? _createdUserId;
  String? _createdAt;
  String? _description;

  Corp? _corp;
  Park? _park;
  Product? _product;

BatchProduct copyWith({  int? id,
  String? name,
  String? code,
  int? productId,
  int? parkId,
  String? startAt,
  String? endAt,
  int? days,
  double? estimatedProduction,
  double? realProduction,
  double? investEstimated,
  double? investReal,
  int? createdUserId,
  String? calcUnit,
  int? corpId,
  int? status,
  String? createdAt,
  String? description,

  Corp? corp,
  Park? park,
  Product? product,
}) => BatchProduct(  id: id ?? _id,
  name: name ?? _name,
  code: code ?? _code,
  productId: productId ?? _productId,
  parkId: parkId ?? _parkId,
  startAt: startAt ?? _startAt,
  endAt: endAt ?? _endAt,
  days: days ?? _days,
  estimatedProduction: estimatedProduction ?? _estimatedProduction,
  realProduction: realProduction ?? _realProduction,
  investEstimated: investEstimated ?? _investEstimated,
  investReal: investReal ?? _investReal,
  createdUserId: createdUserId ?? _createdUserId,
  calcUnit: calcUnit ?? _calcUnit,
  corpId: corpId ?? _corpId,
  status: status ?? _status,
  createdAt: createdAt ?? _createdAt,
  description: description ?? _description,
  corp: corp ?? _corp,
  park: park ?? _park,
  product: product ?? _product,
);
  int? get id => _id;
  String? get name => _name;
  String? get code => _code;
  int? get productId => _productId;
  int? get parkId => _parkId;
  String? get startAt => _startAt;
  String? get endAt => _endAt;
  int? get days => _days;
  double? get estimatedProduction => _estimatedProduction;
  double? get realProduction => _realProduction;
  double? get investEstimated => _investEstimated;
  double? get investReal => _investReal;
  String? get calcUnit => _calcUnit;
  int? get corpId => _corpId;
  int? get createdUserId => _createdUserId;
  String? get createdAt => _createdAt;
  String? get description => _description;

  int? get status => _status;

  set status(int? value) {
    _status = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['productId'] = _productId;
    map['parkId'] = _parkId;

    map['startAt'] = _startAt;
    map['endAt'] = _endAt;
    map['days'] = _days;
    map['estimatedProduction'] = _estimatedProduction;
    map['realProduction'] = _realProduction;
    map['investEstimated'] = _investEstimated;
    map['investReal'] = _investReal;

    map['createdUserId'] = _createdUserId;

    map['calcUnit'] = _calcUnit;
    map['corpId'] = _corpId;
    map['createdAt'] = _createdAt;
    map['description'] = _description;
    map['status'] = _status;

    // ignore: prefer_null_aware_operators
    map['corp'] = _corp?.toJson();
    map['park'] = _park?.toJson();
    map['product'] =  _product?.toJson();
    return map;
  }



  set description(String? value) {
    _description = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set createdUserId(int? value) {
    _createdUserId= value;
  }


  set corpId(int? value) {
    _corpId = value;
  }

  set calcUnit(String? value) {
    _calcUnit = value;
  }

  set saleReal(double? value) {
    _saleReal = value;
  }

  set saleEstimated(double? value) {
    _saleEstimated = value;
  }

  set investReal(double? value) {
    _investReal = value;
  }

  set investEstimated(double? value) {
    _investEstimated = value;
  }

  set realProduction(double? value) {
    _realProduction = value;
  }

  set estimatedProduction(double? value) {
    _estimatedProduction = value;
  }

  set days(int? value) {
    _days = value;
  }

  set endAt(String? value) {
    _endAt = value;
  }

  set startAt(String? value) {
    _startAt = value;
  }

  set parkId(int? value) {
    _parkId = value;
  }

  set productId(int? value) {
    _productId = value;
  }

  set code(String? value) {
    _code = value;
  }

  set name(String? value) {
    _name = value;
  }

  set id(int? value) {
    _id = value;
  }

  Product? get product => _product;

  set product(Product? value) {
    _product = value;
  }

  Park? get park => _park;

  set park(Park? value) {
    _park = value;
  }

  Corp? get corp => _corp;

  set corp(Corp? value) {
    _corp = value;
  }
}