import 'dart:convert';
/// batchId : 1
/// batchName : ""
/// productId : 1
/// area : 3.45
/// quantity : 3.45
/// estimatedTotal : 3.45
/// estimatedPrice : 3.45
/// estimatedAmount : 3.45
/// estimatedInvest : 3.45
/// realInvest : 3.45
/// realTotal : 3.45
/// realAmount : 3.45

BatchFinanceAnalysis batchFinanceAnalysisFromJson(String str) => BatchFinanceAnalysis.fromJson(json.decode(str));
String batchFinanceAnalysisToJson(BatchFinanceAnalysis data) => json.encode(data.toJson());
class BatchFinanceAnalysis {
  BatchFinanceAnalysis({
      num? batchId, 
      String? batchName, 
      num? productId,
    String? productName,
    num? area,
      num? quantity, 
      num? estimatedTotal, 
      num? estimatedPrice, 
      num? estimatedAmount, 
      num? estimatedInvest, 
      num? realInvest, 
      num? realTotal, 
      num? realAmount,}){
    _batchId = batchId;
    _batchName = batchName;
    _productId = productId;
    _productName = productName;
    _area = area;
    _quantity = quantity;
    _estimatedTotal = estimatedTotal;
    _estimatedPrice = estimatedPrice;
    _estimatedAmount = estimatedAmount;
    _estimatedInvest = estimatedInvest;
    _realInvest = realInvest;
    _realTotal = realTotal;
    _realAmount = realAmount;
}

  BatchFinanceAnalysis.fromJson(dynamic json) {
    _batchId = json['batchId'];
    _batchName = json['batchName'];
    _productId = json['productId'];
    _productName = json['productName'];
    _area = json['area'];
    _quantity = json['quantity'];
    _estimatedTotal = json['estimatedTotal'];
    _estimatedPrice = json['estimatedPrice'];
    _estimatedAmount = json['estimatedAmount'];
    _estimatedInvest = json['estimatedInvest'];
    _realInvest = json['realInvest'];
    _realTotal = json['realTotal'];
    _realAmount = json['realAmount'];
  }
  num? _batchId;
  String? _batchName;
  num? _productId;
  String? _productName;
  num? _area;
  num? _quantity;
  num? _estimatedTotal;
  num? _estimatedPrice;
  num? _estimatedAmount;
  num? _estimatedInvest;
  num? _realInvest;
  num? _realTotal;
  num? _realAmount;
BatchFinanceAnalysis copyWith({  num? batchId,
  String? batchName,
  num? productId,
  String? productName,
  num? area,
  num? quantity,
  num? estimatedTotal,
  num? estimatedPrice,
  num? estimatedAmount,
  num? estimatedInvest,
  num? realInvest,
  num? realTotal,
  num? realAmount,
}) => BatchFinanceAnalysis(  batchId: batchId ?? _batchId,
  batchName: batchName ?? _batchName,
  productId: productId ?? _productId,
  productName: productName ?? _productName,
  area: area ?? _area,
  quantity: quantity ?? _quantity,
  estimatedTotal: estimatedTotal ?? _estimatedTotal,
  estimatedPrice: estimatedPrice ?? _estimatedPrice,
  estimatedAmount: estimatedAmount ?? _estimatedAmount,
  estimatedInvest: estimatedInvest ?? _estimatedInvest,
  realInvest: realInvest ?? _realInvest,
  realTotal: realTotal ?? _realTotal,
  realAmount: realAmount ?? _realAmount,
);
  num? get batchId => _batchId;
  String? get batchName => _batchName;
  num? get productId => _productId;
  String? get productName => _productName;
  num? get area => _area;
  num? get quantity => _quantity;
  num? get estimatedTotal => _estimatedTotal;
  num? get estimatedPrice => _estimatedPrice;
  num? get estimatedAmount => _estimatedAmount;
  num? get estimatedInvest => _estimatedInvest;
  num? get realInvest => _realInvest;
  num? get realTotal => _realTotal;
  num? get realAmount => _realAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['batchId'] = _batchId;
    map['batchName'] = _batchName;
    map['productId'] = _productId;
    map['productName'] = _productName;
    map['area'] = _area;
    map['quantity'] = _quantity;
    map['estimatedTotal'] = _estimatedTotal;
    map['estimatedPrice'] = _estimatedPrice;
    map['estimatedAmount'] = _estimatedAmount;
    map['estimatedInvest'] = _estimatedInvest;
    map['realInvest'] = _realInvest;
    map['realTotal'] = _realTotal;
    map['realAmount'] = _realAmount;
    return map;
  }

}