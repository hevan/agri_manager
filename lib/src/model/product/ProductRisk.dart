import 'dart:convert';
/// id : 1
/// name : "ddd"
/// productId : 1
/// productName : "hu"
/// cycleName : "hu"
/// riskCategory : "hu"
/// description : "hu"
/// solution : "hu"
/// feeAmount : 502.00
/// corpId : 1

ProductRisk productRiskFromJson(String str) => ProductRisk.fromJson(json.decode(str));
String productRiskToJson(ProductRisk data) => json.encode(data.toJson());
class ProductRisk {
  ProductRisk({
      int? id, 
      String? name, 
      int? productId, 
      String? productName, 
      String? cycleName, 
      String? riskCategory, 
      String? description, 
      String? solution, 
      double? feeAmount, 
      int? corpId,}){
    _id = id;
    _name = name;
    _productId = productId;
    _productName = productName;
    _cycleName = cycleName;
    _riskCategory = riskCategory;
    _description = description;
    _solution = solution;
    _feeAmount = feeAmount;
    _corpId = corpId;
}

  ProductRisk.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _productId = json['productId'];
    _productName = json['productName'];
    _cycleName = json['cycleName'];
    _riskCategory = json['riskCategory'];
    _description = json['description'];
    _solution = json['solution'];
    _feeAmount = json['feeAmount'];
    _corpId = json['corpId'];
  }
  int? _id;
  String? _name;
  int? _productId;
  String? _productName;
  String? _cycleName;
  String? _riskCategory;
  String? _description;
  String? _solution;
  double? _feeAmount;
  int? _corpId;
ProductRisk copyWith({  int? id,
  String? name,
  int? productId,
  String? productName,
  String? cycleName,
  String? riskCategory,
  String? description,
  String? solution,
  double? feeAmount,
  int? corpId,
}) => ProductRisk(  id: id ?? _id,
  name: name ?? _name,
  productId: productId ?? _productId,
  productName: productName ?? _productName,
  cycleName: cycleName ?? _cycleName,
  riskCategory: riskCategory ?? _riskCategory,
  description: description ?? _description,
  solution: solution ?? _solution,
  feeAmount: feeAmount ?? _feeAmount,
  corpId: corpId ?? _corpId,
);
  int? get id => _id;
  String? get name => _name;
  int? get productId => _productId;
  String? get productName => _productName;
  String? get cycleName => _cycleName;
  String? get riskCategory => _riskCategory;
  String? get description => _description;
  String? get solution => _solution;
  double? get feeAmount => _feeAmount;
  int? get corpId => _corpId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['productId'] = _productId;
    map['productName'] = _productName;
    map['cycleName'] = _cycleName;
    map['riskCategory'] = _riskCategory;
    map['description'] = _description;
    map['solution'] = _solution;
    map['feeAmount'] = _feeAmount;
    map['corpId'] = _corpId;
    return map;
  }

  set corpId(int? value) {
    _corpId = value;
  }

  set feeAmount(double? value) {
    _feeAmount = value;
  }

  set solution(String? value) {
    _solution = value;
  }

  set description(String? value) {
    _description = value;
  }

  set riskCategory(String? value) {
    _riskCategory = value;
  }

  set cycleName(String? value) {
    _cycleName = value;
  }

  set productName(String? value) {
    _productName = value;
  }

  set productId(int? value) {
    _productId = value;
  }

  set name(String? value) {
    _name = value;
  }

  set id(int? value) {
    _id = value;
  }
}