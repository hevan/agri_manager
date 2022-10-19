import 'dart:convert';
/// id : 0
/// name : ""
/// docType : ""
/// docUrl : ""
/// showImage : ""
/// category : ""
/// entityId : 0
/// entityName : ""
/// corpId : 0
/// createdAt : "2022-01-01"

DocResource docResourceFromJson(String str) => DocResource.fromJson(json.decode(str));
String docResourceToJson(DocResource data) => json.encode(data.toJson());
class DocResource {
  DocResource({
      int? id, 
      String? name, 
      String? docType,
      String? docExt,
      String? docUrl,
      String? showImage, 
      String? category, 
      int? entityId, 
      String? entityName, 
      int? corpId,
    int? userId,
    String? createdAt,}){
    _id = id;
    _name = name;
    _docType = docType;
    _docType = docExt;
    _docUrl = docUrl;
    _showImage = showImage;
    _category = category;
    _entityId = entityId;
    _entityName = entityName;
    _corpId = corpId;
    _userId = userId;
    _createdAt = createdAt;
}

  DocResource.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _docType = json['docType'];
    _docExt = json['docExt'];
    _docUrl = json['docUrl'];
    _showImage = json['showImage'];
    _category = json['category'];
    _entityId = json['entityId'];
    _entityName = json['entityName'];
    _corpId = json['corpId'];
    _createdAt = json['createdAt'];
  }
  int? _id;
  String? _name;
  String? _docType;
  String? _docExt;
  String? _docUrl;
  String? _showImage;
  String? _category;
  int? _entityId;
  String? _entityName;
  int? _corpId;
  int? _userId;
  String? _createdAt;

  int? get id => _id;
  String? get name => _name;
  String? get docExt => _docExt;
  String? get docType => _docType;
  String? get docUrl => _docUrl;
  String? get showImage => _showImage;
  String? get category => _category;
  int? get entityId => _entityId;
  String? get entityName => _entityName;
  int? get corpId => _corpId;
  int? get userId => _userId;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['docExt'] = _docExt;
    map['docType'] = _docType;
    map['docUrl'] = _docUrl;
    map['showImage'] = _showImage;
    map['category'] = _category;
    map['entityId'] = _entityId;
    map['entityName'] = _entityName;
    map['corpId'] = _corpId;
    map['userId'] = _userId;
    map['createdAt'] = _createdAt;
    return map;
  }

}