import 'dart:convert';
/// id : 1
/// name : ""
/// code : ""
/// description : ""
/// category : ""
/// direction : 1
/// parentId : 1
/// corpId : 1

AccountTitle accountTitleFromJson(String str) => AccountTitle.fromJson(json.decode(str));
String accountTitleToJson(AccountTitle data) => json.encode(data.toJson());
class AccountTitle {
  AccountTitle({
      int? id, 
      String? name, 
      String? code, 
      String? description, 
      String? category, 
      int? direction, 
      int? parentId, 
      int? corpId,}){
    _id = id;
    _name = name;
    _code = code;
    _description = description;
    _category = category;
    _direction = direction;
    _parentId = parentId;
    _corpId = corpId;
}

  AccountTitle.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _description = json['description'];
    _category = json['category'];
    _direction = json['direction'];
    _parentId = json['parentId'];
    _corpId = json['corpId'];
  }
  int? _id;
  String? _name;
  String? _code;
  String? _description;
  String? _category;
  int? _direction;
  int? _parentId;
  int? _corpId;
AccountTitle copyWith({  int? id,
  String? name,
  String? code,
  String? description,
  String? category,
  int? direction,
  int? parentId,
  int? corpId,
}) => AccountTitle(  id: id ?? _id,
  name: name ?? _name,
  code: code ?? _code,
  description: description ?? _description,
  category: category ?? _category,
  direction: direction ?? _direction,
  parentId: parentId ?? _parentId,
  corpId: corpId ?? _corpId,
);
  int? get id => _id;
  String? get name => _name;
  String? get code => _code;
  String? get description => _description;
  String? get category => _category;
  int? get direction => _direction;
  int? get parentId => _parentId;
  int? get corpId => _corpId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['description'] = _description;
    map['category'] = _category;
    map['direction'] = _direction;
    map['parentId'] = _parentId;
    map['corpId'] = _corpId;
    return map;
  }

}