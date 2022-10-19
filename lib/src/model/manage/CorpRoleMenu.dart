import 'dart:convert';
/// id : 1
/// roleId : 1
/// menuId : 1

CorpRoleMenu corpRoleMenuFromJson(String str) => CorpRoleMenu.fromJson(json.decode(str));
String corpRoleMenuToJson(CorpRoleMenu data) => json.encode(data.toJson());
class CorpRoleMenu {
  CorpRoleMenu({
      int? id, 
      int? roleId, 
      int? menuId,}){
    _id = id;
    _roleId = roleId;
    _menuId = menuId;
}

  CorpRoleMenu.fromJson(dynamic json) {
    _id = json['id'];
    _roleId = json['roleId'];
    _menuId = json['menuId'];
  }
  int? _id;
  int? _roleId;
  int? _menuId;
CorpRoleMenu copyWith({  int? id,
  int? roleId,
  int? menuId,
}) => CorpRoleMenu(  id: id ?? _id,
  roleId: roleId ?? _roleId,
  menuId: menuId ?? _menuId,
);
  int? get id => _id;
  int? get roleId => _roleId;
  int? get menuId => _menuId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['roleId'] = _roleId;
    map['menuId'] = _menuId;
    return map;
  }

}