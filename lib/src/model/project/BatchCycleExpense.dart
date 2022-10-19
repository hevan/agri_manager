import 'dart:convert';
/// id : 1
/// batchId : 1
/// batchName : ""
/// batchCycleId : 1
/// batchCycleName : ""
/// productId : 1
/// productName : ""
/// investProductId : 1
/// investProductName : ""
/// description : ""
/// investAmount : 8.00
/// investPrice : 8.00
/// investQuantity : 9.00
/// realAmount : 9.00
/// realPrice : 10.0
/// realQuantity : 11.00
/// corpId : 1

BatchCycleExpense batchCycleExpenseFromJson(String str) => BatchCycleExpense.fromJson(json.decode(str));
String batchCycleExpenseToJson(BatchCycleExpense data) => json.encode(data.toJson());
class BatchCycleExpense {
  BatchCycleExpense({
      int? id, 
      int? batchId, 
      String? batchName, 
      int? batchCycleId, 
      String? batchCycleName, 
      int? productId, 
      String? productName, 
      int? investProductId, 
      String? investProductName, 
      String? description, 
      double? investAmount, 
      double? investPrice, 
      double? investQuantity, 
      double? realAmount, 
      double? realPrice, 
      double? realQuantity, 
      int? corpId,}){
    _id = id;
    _batchId = batchId;
    _batchName = batchName;
    _batchCycleId = batchCycleId;
    _batchCycleName = batchCycleName;
    _productId = productId;
    _productName = productName;
    _investProductId = investProductId;
    _investProductName = investProductName;
    _description = description;
    _investAmount = investAmount;
    _investPrice = investPrice;
    _investQuantity = investQuantity;
    _realAmount = realAmount;
    _realPrice = realPrice;
    _realQuantity = realQuantity;
    _corpId = corpId;
}

  BatchCycleExpense.fromJson(dynamic json) {
    _id = json['id'];
    _batchId = json['batchId'];
    _batchName = json['batchName'];
    _batchCycleId = json['batchCycleId'];
    _batchCycleName = json['batchCycleName'];
    _productId = json['productId'];
    _productName = json['productName'];
    _investProductId = json['investProductId'];
    _investProductName = json['investProductName'];
    _description = json['description'];
    _investAmount = json['investAmount'];
    _investPrice = json['investPrice'];
    _investQuantity = json['investQuantity'];
    _realAmount = json['realAmount'];
    _realPrice = json['realPrice'];
    _realQuantity = json['realQuantity'];
    _corpId = json['corpId'];
  }
  int? _id;
  int? _batchId;
  String? _batchName;
  int? _batchCycleId;
  String? _batchCycleName;
  int? _productId;
  String? _productName;
  int? _investProductId;
  String? _investProductName;
  String? _description;
  double? _investAmount;
  double? _investPrice;
  double? _investQuantity;
  double? _realAmount;
  double? _realPrice;
  double? _realQuantity;
  int? _corpId;
BatchCycleExpense copyWith({  int? id,
  int? batchId,
  String? batchName,
  int? batchCycleId,
  String? batchCycleName,
  int? productId,
  String? productName,
  int? investProductId,
  String? investProductName,
  String? description,
  double? investAmount,
  double? investPrice,
  double? investQuantity,
  double? realAmount,
  double? realPrice,
  double? realQuantity,
  int? corpId,
}) => BatchCycleExpense(  id: id ?? _id,
  batchId: batchId ?? _batchId,
  batchName: batchName ?? _batchName,
  batchCycleId: batchCycleId ?? _batchCycleId,
  batchCycleName: batchCycleName ?? _batchCycleName,
  productId: productId ?? _productId,
  productName: productName ?? _productName,
  investProductId: investProductId ?? _investProductId,
  investProductName: investProductName ?? _investProductName,
  description: description ?? _description,
  investAmount: investAmount ?? _investAmount,
  investPrice: investPrice ?? _investPrice,
  investQuantity: investQuantity ?? _investQuantity,
  realAmount: realAmount ?? _realAmount,
  realPrice: realPrice ?? _realPrice,
  realQuantity: realQuantity ?? _realQuantity,
  corpId: corpId ?? _corpId,
);
  int? get id => _id;
  int? get batchId => _batchId;
  String? get batchName => _batchName;
  int? get batchCycleId => _batchCycleId;
  String? get batchCycleName => _batchCycleName;
  int? get productId => _productId;
  String? get productName => _productName;
  int? get investProductId => _investProductId;
  String? get investProductName => _investProductName;
  String? get description => _description;
  double? get investAmount => _investAmount;
  double? get investPrice => _investPrice;
  double? get investQuantity => _investQuantity;
  double? get realAmount => _realAmount;
  double? get realPrice => _realPrice;
  double? get realQuantity => _realQuantity;
  int? get corpId => _corpId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['batchId'] = _batchId;
    map['batchName'] = _batchName;
    map['batchCycleId'] = _batchCycleId;
    map['batchCycleName'] = _batchCycleName;
    map['productId'] = _productId;
    map['productName'] = _productName;
    map['investProductId'] = _investProductId;
    map['investProductName'] = _investProductName;
    map['description'] = _description;
    map['investAmount'] = _investAmount;
    map['investPrice'] = _investPrice;
    map['investQuantity'] = _investQuantity;
    map['realAmount'] = _realAmount;
    map['realPrice'] = _realPrice;
    map['realQuantity'] = _realQuantity;
    map['corpId'] = _corpId;
    return map;
  }

  set corpId(int? value) {
    _corpId = value;
  }

  set realQuantity(double? value) {
    _realQuantity = value;
  }

  set realPrice(double? value) {
    _realPrice = value;
  }

  set realAmount(double? value) {
    _realAmount = value;
  }

  set investQuantity(double? value) {
    _investQuantity = value;
  }

  set investPrice(double? value) {
    _investPrice = value;
  }

  set investAmount(double? value) {
    _investAmount = value;
  }

  set description(String? value) {
    _description = value;
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

  set batchCycleName(String? value) {
    _batchCycleName = value;
  }

  set batchCycleId(int? value) {
    _batchCycleId = value;
  }

  set batchName(String? value) {
    _batchName = value;
  }

  set batchId(int? value) {
    _batchId = value;
  }

  set id(int? value) {
    _id = value;
  }
}