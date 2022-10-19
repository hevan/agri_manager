import 'dart:convert';
/// id : 1
/// batchId : 1
/// batchName : ""
/// managerId : 1
/// managerName : ""
/// createdAt : ""
/// isManager : true

BatchTeam batchTeamFromJson(String str) => BatchTeam.fromJson(json.decode(str));
String batchTeamToJson(BatchTeam data) => json.encode(data.toJson());
class BatchTeam {
  BatchTeam({
      int? id, 
      int? batchId, 
      String? batchName, 
      int? managerId, 
      String? managerName, 
      String? createdAt, 
      bool? isManager,}){
    _id = id;
    _batchId = batchId;
    _batchName = batchName;
    _managerId = managerId;
    _managerName = managerName;
    _createdAt = createdAt;
    _isManager = isManager;
}

  BatchTeam.fromJson(dynamic json) {
    _id = json['id'];
    _batchId = json['batchId'];
    _batchName = json['batchName'];
    _managerId = json['managerId'];
    _managerName = json['managerName'];
    _createdAt = json['createdAt'];
    _isManager = json['isManager'];
  }
  int? _id;
  int? _batchId;
  String? _batchName;
  int? _managerId;
  String? _managerName;
  String? _createdAt;
  bool? _isManager;
BatchTeam copyWith({  int? id,
  int? batchId,
  String? batchName,
  int? managerId,
  String? managerName,
  String? createdAt,
  bool? isManager,
}) => BatchTeam(  id: id ?? _id,
  batchId: batchId ?? _batchId,
  batchName: batchName ?? _batchName,
  managerId: managerId ?? _managerId,
  managerName: managerName ?? _managerName,
  createdAt: createdAt ?? _createdAt,
  isManager: isManager ?? _isManager,
);
  int? get id => _id;
  int? get batchId => _batchId;
  String? get batchName => _batchName;
  int? get managerId => _managerId;
  String? get managerName => _managerName;
  String? get createdAt => _createdAt;
  bool? get isManager => _isManager;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['batchId'] = _batchId;
    map['batchName'] = _batchName;
    map['managerId'] = _managerId;
    map['managerName'] = _managerName;
    map['createdAt'] = _createdAt;
    map['isManager'] = _isManager;
    return map;
  }

}