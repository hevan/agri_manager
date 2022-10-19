import 'dart:convert';
/// id : 1
/// name : "test"
/// path : "name"
/// iconUrl : "444"
/// parentId : 1
/// children : [{"id":1,"name":"test","path":"name","iconUrl":"444","parentId":1,"children":[]}]

SysMenu sysMenuFromJson(String str) => SysMenu.fromJson(json.decode(str));
String sysMenuToJson(SysMenu data) => json.encode(data.toJson());
class SysMenu {
  SysMenu({
    int? id,
    String? name,
    String? path,
    String? iconUrl,
    int? parentId,
    int? corpId,
    List<SysMenu>? children}){
    _id = id;
    _name = name;
    _path = path;
    _iconUrl = iconUrl;
    _parentId = parentId;
    _corpId = corpId;
    _children = children;
  }

  SysMenu.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _path = json['path'];
    _iconUrl = json['iconUrl'];
    _parentId = json['parentId'];
    _corpId = json['corpId'];
    if (json['children'] != null) {
      _children = [];
      json['children'].forEach((v) {
        _children?.add(SysMenu.fromJson(v));
      });
    }
  }
  int? _id;
  String? _name;
  String? _path;
  String? _iconUrl;
  int? _parentId;
  int? _corpId;
  List<SysMenu>? _children;

  int? get id => _id;
  String? get name => _name;
  String? get path => _path;
  String? get iconUrl => _iconUrl;
  int? get parentId => _parentId;
  int? get corpId => _corpId;
  List<SysMenu>? get children => _children;

  void addChild(SysMenu sysMenu){
    if(_children == null){
      _children = [];
      _children!.add(sysMenu);
    }else{
      _children!.add(sysMenu);
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['path'] = _path;
    map['iconUrl'] = _iconUrl;
    map['parentId'] = _parentId;
    map['corpId'] = _corpId;
    if (_children != null) {
      map['children'] = _children?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  set children(List<SysMenu>? value) {
    _children = value;
  }

  set parentId(int? value) {
    _parentId = value;
  }

  set iconUrl(String? value) {
    _iconUrl = value;
  }

  set path(String? value) {
    _path = value;
  }

  set name(String? value) {
    _name = value;
  }

  set id(int? value) {
    _id = value;
  }

  set corpId(int? value) {
    _corpId = value;
  }
}
