import 'dart:convert';
/// id : 1
/// name : ""
/// area : ""
/// areaUse : ""
/// description : ""
/// imageUrl : ""

ParkBase parkBaseFromJson(String str) => ParkBase.fromJson(json.decode(str));
String parkBaseToJson(ParkBase data) => json.encode(data.toJson());
class ParkBase {
  ParkBase({
      int? id, 
      String? name, 
      double? area,
      double? areaUse,
      String? description, 
      String? imageUrl,
      int? corpId,
      int? parkId,
  }){
    _id = id;
    _name = name;
    _area = area;
    _areaUse = areaUse;
    _description = description;
    _imageUrl = imageUrl;
    _corpId = corpId;
    _parkId = parkId;
}

  ParkBase.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _area = json['area'];
    _areaUse = json['areaUse'];
    _description = json['description'];
    _imageUrl = json['imageUrl'];
    _corpId = json['corpId'];
    _parkId = json['parkId'];
  }
  int? _id;
  String? _name;
  double? _area;
  double? _areaUse;
  String? _description;
  String? _imageUrl;
  int? _corpId;
  int? _parkId;

ParkBase copyWith({  int? id,
  String? name,
  double? area,
  double? areaUse,
  String? description,
  String? imageUrl,
  int? corpId,
  int? parkId,
}) => ParkBase(  id: id ?? _id,
  name: name ?? _name,
  area: area ?? _area,
  areaUse: areaUse ?? _areaUse,
  description: description ?? _description,
  imageUrl: imageUrl ?? _imageUrl,
  corpId: corpId ?? _corpId,
  parkId: parkId ?? _parkId,
);
  int? get id => _id;
  String? get name => _name;
  double? get area => _area;
  double? get areaUse => _areaUse;
  String? get description => _description;
  String? get imageUrl => _imageUrl;
  int? get corpId => _corpId;
  int? get parkId => _parkId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['area'] = _area;
    map['areaUse'] = _areaUse;
    map['description'] = _description;
    map['imageUrl'] = _imageUrl;
    map['corpId'] = _corpId;
    map['parkId'] = _parkId;
    return map;
  }

  set corpId(int? value) {
    _corpId = value;
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

  set parkId(int? value) {
    _parkId = value;
  }
}