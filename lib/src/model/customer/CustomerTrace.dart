import 'dart:convert';
/// id : 0
/// customerId : 0
/// customerName : ""
/// managerName : ""
/// managerMobile : "2022-02-01"
/// managerId : 0
/// title : ""
/// description : ""
/// corpId : 2
/// createdAt : "2022-02-01"

CustomerTrace customerTraceFromJson(String str) => CustomerTrace.fromJson(json.decode(str));
String customerTraceToJson(CustomerTrace data) => json.encode(data.toJson());
class CustomerTrace {
  CustomerTrace({
      int? id, 
      int? customerId, 
      String? customerName, 
      String? managerName, 
      String? managerMobile, 
      int? managerId, 
      String? title, 
      String? description, 
      int? corpId, 
      String? createdAt, String? occurAt}){
    _id = id;
    _customerId = customerId;
    _customerName = customerName;
    _managerName = managerName;
    _managerMobile = managerMobile;
    _managerId = managerId;
    _title = title;
    _description = description;
    _corpId = corpId;
    _createdAt = createdAt;
    _occurAt = occurAt;
}

  CustomerTrace.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customerId'];
    _customerName = json['customerName'];
    _managerName = json['managerName'];
    _managerMobile = json['managerMobile'];
    _managerId = json['managerId'];
    _title = json['title'];
    _description = json['description'];
    _corpId = json['corpId'];
    _createdAt = json['createdAt'];
    _occurAt = json['occurAt'];
  }
  int? _id;
  int? _customerId;
  String? _customerName;
  String? _managerName;
  String? _managerMobile;
  int? _managerId;
  String? _title;
  String? _description;
  int? _corpId;
  String? _createdAt;
  String? _occurAt;

  int? get id => _id;
  int? get customerId => _customerId;
  String? get customerName => _customerName;
  String? get managerName => _managerName;
  String? get managerMobile => _managerMobile;
  int? get managerId => _managerId;
  String? get title => _title;
  String? get description => _description;
  int? get corpId => _corpId;
  String? get createdAt => _createdAt;
  String? get occurAt => _occurAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customerId'] = _customerId;
    map['customerName'] = _customerName;
    map['managerName'] = _managerName;
    map['managerMobile'] = _managerMobile;
    map['managerId'] = _managerId;
    map['title'] = _title;
    map['description'] = _description;
    map['corpId'] = _corpId;
    map['occurAt'] = _occurAt;
    map['createdAt'] = _createdAt;
    return map;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set occurAt(String? value) {
    _occurAt = value;
  }

  set corpId(int? value) {
    _corpId = value;
  }

  set description(String? value) {
    _description = value;
  }

  set title(String? value) {
    _title = value;
  }

  set managerId(int? value) {
    _managerId = value;
  }

  set managerMobile(String? value) {
    _managerMobile = value;
  }

  set managerName(String? value) {
    _managerName = value;
  }

  set customerName(String? value) {
    _customerName = value;
  }

  set customerId(int? value) {
    _customerId = value;
  }

  set id(int? value) {
    _id = value;
  }
}