import 'dart:convert';
/// parkId : 1
/// parkName : ""
/// parkBaseId : 1
/// parkBaseName : ""

ParkBaseDto parkBaseDtoFromJson(String str) => ParkBaseDto.fromJson(json.decode(str));
String parkBaseDtoToJson(ParkBaseDto data) => json.encode(data.toJson());
class ParkBaseDto {
  ParkBaseDto({
      num? parkId, 
      String? parkName, 
      num? parkBaseId, 
      String? parkBaseName,}){
    _parkId = parkId;
    _parkName = parkName;
    _parkBaseId = parkBaseId;
    _parkBaseName = parkBaseName;
}

  ParkBaseDto.fromJson(dynamic json) {
    _parkId = json['parkId'];
    _parkName = json['parkName'];
    _parkBaseId = json['parkBaseId'];
    _parkBaseName = json['parkBaseName'];
  }
  num? _parkId;
  String? _parkName;
  num? _parkBaseId;
  String? _parkBaseName;
ParkBaseDto copyWith({  num? parkId,
  String? parkName,
  num? parkBaseId,
  String? parkBaseName,
}) => ParkBaseDto(  parkId: parkId ?? _parkId,
  parkName: parkName ?? _parkName,
  parkBaseId: parkBaseId ?? _parkBaseId,
  parkBaseName: parkBaseName ?? _parkBaseName,
);
  num? get parkId => _parkId;
  String? get parkName => _parkName;
  num? get parkBaseId => _parkBaseId;
  String? get parkBaseName => _parkBaseName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['parkId'] = _parkId;
    map['parkName'] = _parkName;
    map['parkBaseId'] = _parkBaseId;
    map['parkBaseName'] = _parkBaseName;
    return map;
  }

}