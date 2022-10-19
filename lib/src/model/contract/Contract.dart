import 'dart:convert';
/// id : 1
/// name : ""
/// code : ""
/// description : ""
/// customerId : 1
/// customerName : ""
/// startAt : ""
/// endAt : ""
/// signAt : ""
/// corpId : 1
/// createdAt : ""

Contract contractFromJson(String str) => Contract.fromJson(json.decode(str));
String contractToJson(Contract data) => json.encode(data.toJson());
class Contract {
  Contract({
      int? id, 
      String? name, 
      String? code, 
      String? description, 
      int? customerId, 
      String? customerName, 
      String? startAt, 
      String? endAt, 
      String? signAt, 
      int? corpId, 
      String? createdAt,}){
    _id = id;
    _name = name;
    _code = code;
    _description = description;
    _customerId = customerId;
    _customerName = customerName;
    _startAt = startAt;
    _endAt = endAt;
    _signAt = signAt;
    _corpId = corpId;
    _createdAt = createdAt;
}

  Contract.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _description = json['description'];
    _customerId = json['customerId'];
    _customerName = json['customerName'];
    _startAt = json['startAt'];
    _endAt = json['endAt'];
    _signAt = json['signAt'];
    _corpId = json['corpId'];
    _createdAt = json['createdAt'];
  }
  int? _id;
  String? _name;
  String? _code;
  String? _description;
  int? _customerId;
  String? _customerName;
  String? _startAt;
  String? _endAt;
  String? _signAt;
  int? _corpId;
  String? _createdAt;
Contract copyWith({  int? id,
  String? name,
  String? code,
  String? description,
  int? customerId,
  String? customerName,
  String? startAt,
  String? endAt,
  String? signAt,
  int? corpId,
  String? createdAt,
}) => Contract(  id: id ?? _id,
  name: name ?? _name,
  code: code ?? _code,
  description: description ?? _description,
  customerId: customerId ?? _customerId,
  customerName: customerName ?? _customerName,
  startAt: startAt ?? _startAt,
  endAt: endAt ?? _endAt,
  signAt: signAt ?? _signAt,
  corpId: corpId ?? _corpId,
  createdAt: createdAt ?? _createdAt,
);
  int? get id => _id;
  String? get name => _name;
  String? get code => _code;
  String? get description => _description;
  int? get customerId => _customerId;
  String? get customerName => _customerName;
  String? get startAt => _startAt;
  String? get endAt => _endAt;
  String? get signAt => _signAt;
  int? get corpId => _corpId;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['description'] = _description;
    map['customerId'] = _customerId;
    map['customerName'] = _customerName;
    map['startAt'] = _startAt;
    map['endAt'] = _endAt;
    map['signAt'] = _signAt;
    map['corpId'] = _corpId;
    map['createdAt'] = _createdAt;
    return map;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set corpId(int? value) {
    _corpId = value;
  }

  set signAt(String? value) {
    _signAt = value;
  }

  set endAt(String? value) {
    _endAt = value;
  }

  set startAt(String? value) {
    _startAt = value;
  }

  set customerName(String? value) {
    _customerName = value;
  }

  set customerId(int? value) {
    _customerId = value;
  }

  set description(String? value) {
    _description = value;
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