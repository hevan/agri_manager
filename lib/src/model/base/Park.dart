import 'dart:convert';
/// id : 1
/// name : ""
/// area : ""
/// areaUse : ""
/// description : ""
/// imageUrl : ""
/// addressId : 1
/// createdAt : ""

Park parkFromJson(String str) => Park.fromJson(json.decode(str));
String parkToJson(Park data) => json.encode(data.toJson());
class Park {
  Park({
      int? id, 
      String? name, 
      double? area,
      double? areaUse,
      String? description, 
      String? imageUrl, 
      int? addressId,
    int? corpId,
    String? createdAt,}){
    _id = id;
    _name = name;
    _area = area;
    _areaUse = areaUse;
    _description = description;
    _imageUrl = imageUrl;
    _addressId = addressId;
    _corpId = corpId;
    _createdAt = createdAt;
}

  Park.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _area = json['area'];
    _areaUse = json['areaUse'];
    _description = json['description'];
    _imageUrl = json['imageUrl'];
    _addressId = json['addressId'];
    _corpId = json['corpId'];
    _createdAt = json['createdAt'];
  }
  int? _id;
  String? _name;
  double? _area;
  double? _areaUse;
  String? _description;
  String? _imageUrl;
  int? _addressId;
  int? _corpId;
  String? _createdAt;
Park copyWith({  int? id,
  String? name,
  double? area,
  double? areaUse,
  String? description,
  String? imageUrl,
  int? addressId,
  int? corpId,
  String? createdAt,
}) => Park(  id: id ?? _id,
  name: name ?? _name,
  area: area ?? _area,
  areaUse: areaUse ?? _areaUse,
  description: description ?? _description,
  imageUrl: imageUrl ?? _imageUrl,
  addressId: addressId ?? _addressId,
  corpId: corpId ?? corpId,
  createdAt: createdAt ?? _createdAt,
);
  int? get id => _id;
  String? get name => _name;
  double? get area => _area;
  double? get areaUse => _areaUse;
  String? get description => _description;
  String? get imageUrl => _imageUrl;
  int? get addressId => _addressId;
  String? get createdAt => _createdAt;
  int? get corpId => _corpId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['area'] = _area;
    map['areaUse'] = _areaUse;
    map['description'] = _description;
    map['imageUrl'] = _imageUrl;
    map['addressId'] = _addressId;
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

  set addressId(int? value) {
    _addressId = value;
  }

  set imageUrl(String? value) {
    _imageUrl = value;
  }

  set description(String? value) {
    _description = value;
  }

  set areaUse(double? value) {
    _areaUse = value;
  }

  set area(double? value) {
    _area = value;
  }

  set name(String? value) {
    _name = value;
  }

  set id(int? value) {
    _id = value;
  }
}