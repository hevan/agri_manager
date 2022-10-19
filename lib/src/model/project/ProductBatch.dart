import 'dart:convert';
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

ProductBatch productBatchFromJson(String str) => ProductBatch.fromJson(json.decode(str));
String productBatchToJson(ProductBatch data) => json.encode(data.toJson());
class ProductBatch {
  ProductBatch({
      int? id, 
      String? name, 
      String? code, 
      int? productId, 
      String? productName, 
      int? parkId, 
      String? parkName, 
      double? quantity,
      String? startAt, 
      String? endAt, 
      int? days,
      double? estimatedProduction, 
      double? realProduction, 
      double? investEstimated, 
      double? investReal, 
      double? saleEstimated, 
      double? saleReal,
      String? managerName,
      int?    managerId,
      String? unit, 
      int? corpId,
    int? status,
      String? createdAt,
    String? description
  }){
    _id = id;
    _name = name;
    _code = code;
    _productId = productId;
    _productName = productName;
    _parkId = parkId;
    _parkName = parkName;
    _quantity = quantity;
    _startAt = startAt;
    _endAt = endAt;
    _days = days;
    _estimatedProduction = estimatedProduction;
    _realProduction = realProduction;
    _investEstimated = investEstimated;
    _investReal = investReal;
    _saleEstimated = saleEstimated;
    _saleReal = saleReal;
    _unit = unit;
    _status = status;
    _corpId = corpId;
    _managerId = managerId;
    _managerName = managerName;
    _createdAt = createdAt;
    _description = description;
}

  ProductBatch.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _productId = json['productId'];
    _productName = json['productName'];
    _parkId = json['parkId'];
    _parkName = json['parkName'];
    _quantity = json['quantity'];
    _startAt = json['startAt'];
    _endAt = json['endAt'];
    _days = json['days'];
    _estimatedProduction = json['estimatedProduction'];
    _realProduction = json['realProduction'];
    _investEstimated = json['investEstimated'];
    _investReal = json['investReal'];
    _saleEstimated = json['saleEstimated'];
    _saleReal = json['saleReal'];
    _unit = json['unit'];
    _corpId = json['corpId'];
    _status = json['status'];
    _managerName = json['managerName'];
    _managerId = json['managerId'];
    _createdAt = json['createdAt'];
    _description = json['description'];
  }
  int? _id;
  String? _name;
  String? _code;
  int? _productId;
  String? _productName;
  int? _parkId;
  String? _parkName;
  double? _quantity;
  String? _startAt;
  String? _endAt;
  int? _days;
  double? _estimatedProduction;
  double? _realProduction;
  double? _investEstimated;
  double? _investReal;
  double? _saleEstimated;
  double? _saleReal;
  String? _unit;
  int? _status;
  int? _corpId;
  String? _managerName;
  int? _managerId;
  String? _createdAt;
  String? _description;

ProductBatch copyWith({  int? id,
  String? name,
  String? code,
  int? productId,
  String? productName,
  int? parkId,
  String? parkName,
  double? quantity,
  String? startAt,
  String? endAt,
  int? days,
  double? estimatedProduction,
  double? realProduction,
  double? investEstimated,
  double? investReal,
  double? saleEstimated,
  double? saleReal,
  String? managerName,
  int? managerId,
  String? unit,
  int? corpId,
  int? status,
  String? createdAt,
  String? description,
}) => ProductBatch(  id: id ?? _id,
  name: name ?? _name,
  code: code ?? _code,
  productId: productId ?? _productId,
  productName: productName ?? _productName,
  parkId: parkId ?? _parkId,
  parkName: parkName ?? _parkName,
  quantity: quantity ?? _quantity,
  startAt: startAt ?? _startAt,
  endAt: endAt ?? _endAt,
  days: days ?? _days,
  estimatedProduction: estimatedProduction ?? _estimatedProduction,
  realProduction: realProduction ?? _realProduction,
  investEstimated: investEstimated ?? _investEstimated,
  investReal: investReal ?? _investReal,
  saleEstimated: saleEstimated ?? _saleEstimated,
  saleReal: saleReal ?? _saleReal,
  managerName: managerName ?? _managerName,
  managerId: managerId ?? _managerId,
  unit: unit ?? _unit,
  corpId: corpId ?? _corpId,
  status: status ?? _status,
  createdAt: createdAt ?? _createdAt,
  description: description ?? _description,
);
  int? get id => _id;
  String? get name => _name;
  String? get code => _code;
  int? get productId => _productId;
  String? get productName => _productName;
  int? get parkId => _parkId;
  String? get parkName => _parkName;
  double? get quantity => _quantity;
  String? get startAt => _startAt;
  String? get endAt => _endAt;
  int? get days => _days;
  double? get estimatedProduction => _estimatedProduction;
  double? get realProduction => _realProduction;
  double? get investEstimated => _investEstimated;
  double? get investReal => _investReal;
  double? get saleEstimated => _saleEstimated;
  double? get saleReal => _saleReal;
  String? get unit => _unit;
  int? get corpId => _corpId;
  String? get managerName => _managerName;
  int? get managerId => _managerId;
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
    map['productName'] = _productName;
    map['parkId'] = _parkId;
    map['parkName'] = _parkName;
    map['quantity'] = _quantity;
    map['startAt'] = _startAt;
    map['endAt'] = _endAt;
    map['days'] = _days;
    map['estimatedProduction'] = _estimatedProduction;
    map['realProduction'] = _realProduction;
    map['investEstimated'] = _investEstimated;
    map['investReal'] = _investReal;
    map['saleEstimated'] = _saleEstimated;
    map['saleReal'] = _saleReal;
    map['managerId'] = _managerId;
    map['managerName'] = _managerName;
    map['unit'] = _unit;
    map['corpId'] = _corpId;
    map['createdAt'] = _createdAt;
    map['description'] = _description;
    map['status'] = _status;
    return map;
  }



  set description(String? value) {
    _description = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set managerId(int? value) {
    _managerId = value;
  }

  set managerName(String? value) {
    _managerName = value;
  }

  set corpId(int? value) {
    _corpId = value;
  }

  set unit(String? value) {
    _unit = value;
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

  set quantity(double? value) {
    _quantity = value;
  }

  set parkName(String? value) {
    _parkName = value;
  }

  set parkId(int? value) {
    _parkId = value;
  }

  set productName(String? value) {
    _productName = value;
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
}