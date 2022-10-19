import 'dart:convert';
/// id : 1
/// name : ""
/// area : ""
/// province : ""
/// city : ""
/// address : ""
/// location : ""
/// corpId : 1

Market marketFromJson(String str) => Market.fromJson(json.decode(str));
String marketToJson(Market data) => json.encode(data.toJson());
class Market {
  Market({
      int? id, 
      String? name, 
      String? area, 
      String? province, 
      String? city, 
      String? address, 
      String? location, 
      int? corpId,}){
    _id = id;
    _name = name;
    _area = area;
    _province = province;
    _city = city;
    _address = address;
    _location = location;
    _corpId = corpId;
}

  Market.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _area = json['area'];
    _province = json['province'];
    _city = json['city'];
    _address = json['address'];
    _location = json['location'];
    _corpId = json['corpId'];
  }
  int? _id;
  String? _name;
  String? _area;
  String? _province;
  String? _city;
  String? _address;
  String? _location;
  int? _corpId;
Market copyWith({  int? id,
  String? name,
  String? area,
  String? province,
  String? city,
  String? address,
  String? location,
  int? corpId,
}) => Market(  id: id ?? _id,
  name: name ?? _name,
  area: area ?? _area,
  province: province ?? _province,
  city: city ?? _city,
  address: address ?? _address,
  location: location ?? _location,
  corpId: corpId ?? _corpId,
);
  int? get id => _id;
  String? get name => _name;
  String? get area => _area;
  String? get province => _province;
  String? get city => _city;
  String? get address => _address;
  String? get location => _location;
  int? get corpId => _corpId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['area'] = _area;
    map['province'] = _province;
    map['city'] = _city;
    map['address'] = _address;
    map['location'] = _location;
    map['corpId'] = _corpId;
    return map;
  }

  set corpId(int? value) {
    _corpId = value;
  }

  set location(String? value) {
    _location = value;
  }

  set address(String? value) {
    _address = value;
  }

  set city(String? value) {
    _city = value;
  }

  set province(String? value) {
    _province = value;
  }

  set area(String? value) {
    _area = value;
  }

  set name(String? value) {
    _name = value;
  }

  set id(int? value) {
    _id = value;
  }
}