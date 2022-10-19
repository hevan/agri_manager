import 'dart:convert';
/// id : 1
/// batchId : 1
/// batchName : ""
/// productId : 1
/// cycleName : ""
/// productName : ""
/// riskCategory : ""
/// description : ""
/// solution : ""
/// feeAmount : 9.00
/// occurDate : ""
/// managerId : 1
/// managerName : ""
/// createdAt : ""

BatchRisk batchRiskFromJson(String str) => BatchRisk.fromJson(json.decode(str));
String batchRiskToJson(BatchRisk data) => json.encode(data.toJson());
class BatchRisk {
  BatchRisk({
      int? id,
      String? name,
      int? batchId,
      String? batchName, 
      int? productId, 
      String? cycleName, 
      String? productName, 
      String? riskCategory, 
      String? description, 
      String? solution, 
      double? feeAmount, 
      String? occurDate, 
      int? managerId, 
      String? managerName, 
      String? createdAt,}){
    _id = id;
    _name = name;
    _batchId = batchId;
    _batchName = batchName;
    _productId = productId;
    _cycleName = cycleName;
    _productName = productName;
    _riskCategory = riskCategory;
    _description = description;
    _solution = solution;
    _feeAmount = feeAmount;
    _occurDate = occurDate;
    _managerId = managerId;
    _managerName = managerName;
    _createdAt = createdAt;
}

  BatchRisk.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _batchId = json['batchId'];
    _batchName = json['batchName'];
    _productId = json['productId'];
    _cycleName = json['cycleName'];
    _productName = json['productName'];
    _riskCategory = json['riskCategory'];
    _description = json['description'];
    _solution = json['solution'];
    _feeAmount = json['feeAmount'];
    _occurDate = json['occurDate'];
    _managerId = json['managerId'];
    _managerName = json['managerName'];
    _createdAt = json['createdAt'];
  }
  int? _id;
  String? _name;
  int? _batchId;
  String? _batchName;
  int? _productId;
  String? _cycleName;
  String? _productName;
  String? _riskCategory;
  String? _description;
  String? _solution;
  double? _feeAmount;
  String? _occurDate;
  int? _managerId;
  String? _managerName;
  String? _createdAt;
BatchRisk copyWith({  int? id,
  String? name,
  int? batchId,
  String? batchName,
  int? productId,
  String? cycleName,
  String? productName,
  String? riskCategory,
  String? description,
  String? solution,
  double? feeAmount,
  String? occurDate,
  int? managerId,
  String? managerName,
  String? createdAt,
}) => BatchRisk(  id: id ?? _id,
  name: name ?? _name,
  batchId: batchId ?? _batchId,
  batchName: batchName ?? _batchName,
  productId: productId ?? _productId,
  cycleName: cycleName ?? _cycleName,
  productName: productName ?? _productName,
  riskCategory: riskCategory ?? _riskCategory,
  description: description ?? _description,
  solution: solution ?? _solution,
  feeAmount: feeAmount ?? _feeAmount,
  occurDate: occurDate ?? _occurDate,
  managerId: managerId ?? _managerId,
  managerName: managerName ?? _managerName,
  createdAt: createdAt ?? _createdAt,
);
  int? get id => _id;
  String? get name => _name;
  int? get batchId => _batchId;
  String? get batchName => _batchName;
  int? get productId => _productId;
  String? get cycleName => _cycleName;
  String? get productName => _productName;
  String? get riskCategory => _riskCategory;
  String? get description => _description;
  String? get solution => _solution;
  double? get feeAmount => _feeAmount;
  String? get occurDate => _occurDate;
  int? get managerId => _managerId;
  String? get managerName => _managerName;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['batchId'] = _batchId;
    map['batchName'] = _batchName;
    map['productId'] = _productId;
    map['cycleName'] = _cycleName;
    map['productName'] = _productName;
    map['riskCategory'] = _riskCategory;
    map['description'] = _description;
    map['solution'] = _solution;
    map['feeAmount'] = _feeAmount;
    map['occurDate'] = _occurDate;
    map['managerId'] = _managerId;
    map['managerName'] = _managerName;
    map['createdAt'] = _createdAt;
    return map;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set managerName(String? value) {
    _managerName = value;
  }

  set managerId(int? value) {
    _managerId = value;
  }

  set occurDate(String? value) {
    _occurDate = value;
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

  set productName(String? value) {
    _productName = value;
  }

  set cycleName(String? value) {
    _cycleName = value;
  }

  set productId(int? value) {
    _productId = value;
  }

  set batchName(String? value) {
    _batchName = value;
  }

  set batchId(int? value) {
    _batchId = value;
  }

  set name(String? value) {
    _name = value;
  }

  set id(int? value) {
    _id = value;
  }
}