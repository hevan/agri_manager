import 'dart:convert';
/// id : 0
/// customerId : 0
/// linkName : ""
/// linkMobile : ""
/// createdAt : "2022-02-01"

CustomerLink customerLinkFromJson(String str) => CustomerLink.fromJson(json.decode(str));
String customerLinkToJson(CustomerLink data) => json.encode(data.toJson());
class CustomerLink {
  CustomerLink({
      int? id, 
      int? customerId, 
      String? linkName, 
      String? linkMobile,
      String? description,
    String? position,
    String? createdAt,}){
    _id = id;
    _customerId = customerId;
    _linkName = linkName;
    _linkMobile = linkMobile;
    _description = description;
    _position = position;
    _createdAt = createdAt;
}

  CustomerLink.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customerId'];
    _linkName = json['linkName'];
    _linkMobile = json['linkMobile'];
    _description = json['description'];
    _position = json['position'];
    _createdAt = json['createdAt'];
  }
  int? _id;
  int? _customerId;
  String? _linkName;
  String? _linkMobile;
  String? _description;
  String? _position;
  String? _createdAt;

  int? get id => _id;
  int? get customerId => _customerId;
  String? get linkName => _linkName;
  String? get linkMobile => _linkMobile;
  String? get description => _description;
  String? get createdAt => _createdAt;
  String? get position => _position;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customerId'] = _customerId;
    map['linkName'] = _linkName;
    map['linkMobile'] = _linkMobile;
    map['description'] = _description;
    map['createdAt'] = _createdAt;
    map['position'] = _position;
    return map;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set description(String? value) {
    _description = value;
  }

  set linkMobile(String? value) {
    _linkMobile = value;
  }

  set linkName(String? value) {
    _linkName = value;
  }

  set customerId(int? value) {
    _customerId = value;
  }

  set position(String? value) {
    _position = value;
  }

  set id(int? value) {
    _id = value;
  }
}