import 'dart:convert';
/// id : 0
/// province : ""
/// city : ""
/// region : ""
/// addressLine : ""
/// link_name : ""
/// link_mobile : ""

Address addressFromJson(String str) => Address.fromJson(json.decode(str));
String addressToJson(Address data) => json.encode(data.toJson());
class Address {
  Address({
      int? id, 
      String? province, 
      String? city, 
      String? region, 
      String? addressLine, 
      String? linkName, 
      String? linkMobile,}){
    _id = id;
    _province = province;
    _city = city;
    _region = region;
    _addressLine = addressLine;
    _linkName = linkName;
    _linkMobile = linkMobile;
}

  Address.fromJson(dynamic json) {
    _id = json['id'];
    _province = json['province'];
    _city = json['city'];
    _region = json['region'];
    _addressLine = json['addressLine'];
    _linkName = json['linkName'];
    _linkMobile = json['linkMobile'];
  }
  int? _id;
  String? _province;
  String? _city;
  String? _region;
  String? _addressLine;
  String? _linkName;
  String? _linkMobile;

  int? get id => _id;
  String? get province => _province;
  String? get city => _city;
  String? get region => _region;
  String? get addressLine => _addressLine;
  String? get linkName => _linkName;
  String? get linkMobile => _linkMobile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['province'] = _province;
    map['city'] = _city;
    map['region'] = _region;
    map['addressLine'] = _addressLine;
    map['linkName'] = _linkName;
    map['linkMobile'] = _linkMobile;
    return map;
  }

}