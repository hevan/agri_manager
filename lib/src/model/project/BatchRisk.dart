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
/// createdUserId : 1
/// createdBy : ""
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
      int? createdUserId, 
      String? createdBy, 
      String? createdAt,int? corpId}){
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
    _createdUserId = createdUserId;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _corpId = corpId;
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
    _createdUserId = json['createdUserId'];
    _createdBy = json['createdBy'];
    _createdAt = json['createdAt'];
    _corpId = json['corpId'];
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
  int? _createdUserId;
  String? _createdBy;
  String? _createdAt;
  int? _corpId;
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
  int? createdUserId,
  String? createdBy,
  String? createdAt,
  int? corpId,
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
  createdUserId: createdUserId ?? _createdUserId,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  corpId: corpId ?? _corpId,
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
  int? get createdUserId => _createdUserId;
  String? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  int? get corpId => _corpId;

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
    map['createdUserId'] = _createdUserId;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['corpId'] = _corpId;
    return map;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set createdBy(String? value) {
    _createdBy = value;
  }

  set createdUserId(int? value) {
    _createdUserId = value;
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

  set corpId(int? value) {
    _corpId = value;
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