import 'dart:convert';

/// id : 1
/// province : "广东省"
/// city : "广州市"
/// region : "天河区"
/// lineDetail : "汇彩路8号"
/// linkName : "王海文"
/// linkMobile : "18688868390"
/// location : null
/// createdAt : "2022-12-06 00:00:00"

Address addressFromJson(String str) => Address.fromJson(json.decode(str));
String addressToJson(Address data) => json.encode(data.toJson());
class Address {
  Address({
    int? id,
    String? province,
    String? city,
    String? region,
    String? lineDetail,
    String? linkName,
    String? linkMobile,
    String? createdAt,}){
    _id = id;
    _province = province;
    _city = city;
    _region = region;
    _lineDetail = lineDetail;
    _linkName = linkName;
    _linkMobile = linkMobile;
    _createdAt = createdAt;
  }

  Address.fromJson(dynamic json) {
    _id = json['id'];
    _province = json['province'];
    _city = json['city'];
    _region = json['region'];
    _lineDetail = json['lineDetail'];
    _linkName = json['linkName'];
    _linkMobile = json['linkMobile'];
    _createdAt = json['createdAt'];
  }
  int? _id;
  String? _province;
  String? _city;
  String? _region;
  String? _lineDetail;
  String? _linkName;
  String? _linkMobile;
  String? _createdAt;

  Address copyWith({  int? id,
    String? province,
    String? city,
    String? region,
    String? lineDetail,
    String? linkName,
    String? linkMobile,
    String? createdAt,
  }) => Address(  id: id ?? _id,
    province: province ?? _province,
    city: city ?? _city,
    region: region ?? _region,
    lineDetail: lineDetail ?? _lineDetail,
    linkName: linkName ?? _linkName,
    linkMobile: linkMobile ?? _linkMobile,
    createdAt: createdAt ?? _createdAt,
  );
  int? get id => _id;
  String? get province => _province;
  String? get city => _city;
  String? get region => _region;
  String? get lineDetail => _lineDetail;
  String? get linkName => _linkName;
  String? get linkMobile => _linkMobile;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['province'] = _province;
    map['city'] = _city;
    map['region'] = _region;
    map['lineDetail'] = _lineDetail;
    map['linkName'] = _linkName;
    map['linkMobile'] = _linkMobile;
    map['createdAt'] = _createdAt;
    return map;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set linkMobile(String? value) {
    _linkMobile = value;
  }

  set linkName(String? value) {
    _linkName = value;
  }

  set lineDetail(String? value) {
    _lineDetail = value;
  }

  set region(String? value) {
    _region = value;
  }

  set city(String? value) {
    _city = value;
  }

  set province(String? value) {
    _province = value;
  }

  set id(int? value) {
    _id = value;
  }
}