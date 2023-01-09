import 'dart:convert';
/// id : 1
/// managerId : 1
/// departId : 1

CorpManagerDepart corpManagerDepartFromJson(String str) => CorpManagerDepart.fromJson(json.decode(str));
String corpManagerDepartToJson(CorpManagerDepart data) => json.encode(data.toJson());
class CorpManagerDepart {
  CorpManagerDepart({
      int? id, 
      int? managerId, 
      int? departId,}){
    _id = id;
    _managerId = managerId;
    _departId = departId;
}

  CorpManagerDepart.fromJson(dynamic json) {
    _id = json['id'];
    _managerId = json['managerId'];
    _departId = json['departId'];
  }
  int? _id;
  int? _managerId;
  int? _departId;
CorpManagerDepart copyWith({  int? id,
  int? managerId,
  int? departId,
}) => CorpManagerDepart(  id: id ?? _id,
  managerId: managerId ?? _managerId,
  departId: departId ?? _departId,
);
  int? get id => _id;
  int? get managerId => _managerId;
  int? get departId => _departId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['managerId'] = _managerId;
    map['departId'] = _departId;
    return map;
  }

}