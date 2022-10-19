import 'dart:convert';
/// id : 1
/// name : ""
/// code : ""
/// description : ""
/// addressId : 2
/// category : ""
/// corpId : ""
/// createdAt : ""

Store storeFromJson(String str) => Store.fromJson(json.decode(str));
String storeToJson(Store data) => json.encode(data.toJson());
class Store {
  Store({
      int? id, 
      String? name, 
      String? code, 
      String? description, 
      int? addressId, 
      String? category, 
      String? corpId, 
      String? createdAt,}){
    _id = id;
    _name = name;
    _code = code;
    _description = description;
    _addressId = addressId;
    _category = category;
    _corpId = corpId;
    _createdAt = createdAt;
}

  Store.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _description = json['description'];
    _addressId = json['addressId'];
    _category = json['category'];
    _corpId = json['corpId'];
    _createdAt = json['createdAt'];
  }
  int? _id;
  String? _name;
  String? _code;
  String? _description;
  int? _addressId;
  String? _category;
  String? _corpId;
  String? _createdAt;
Store copyWith({  int? id,
  String? name,
  String? code,
  String? description,
  int? addressId,
  String? category,
  String? corpId,
  String? createdAt,
}) => Store(  id: id ?? _id,
  name: name ?? _name,
  code: code ?? _code,
  description: description ?? _description,
  addressId: addressId ?? _addressId,
  category: category ?? _category,
  corpId: corpId ?? _corpId,
  createdAt: createdAt ?? _createdAt,
);
  int? get id => _id;
  String? get name => _name;
  String? get code => _code;
  String? get description => _description;
  int? get addressId => _addressId;
  String? get category => _category;
  String? get corpId => _corpId;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['description'] = _description;
    map['addressId'] = _addressId;
    map['category'] = _category;
    map['corpId'] = _corpId;
    map['createdAt'] = _createdAt;
    return map;
  }

}