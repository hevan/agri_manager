import 'dart:convert';

import 'package:agri_manager/src/model/business/CheckManager.dart';
import 'package:agri_manager/src/model/project/BatchCycle.dart';
/// id : 1
/// name : ""
/// description : ""
/// startAt : ""
/// endAt : ""
/// batchId : 1
/// batchCycleId : 2
/// status : 1
/// progress : 0.6
/// createdAt : ""
/// createdUserId : 1
/// corpId : 1

BatchCycleExecute batchCycleExecuteFromJson(String str) => BatchCycleExecute.fromJson(json.decode(str));
String batchCycleExecuteToJson(BatchCycleExecute data) => json.encode(data.toJson());
class BatchCycleExecute {
  BatchCycleExecute({
      int? id, 
      String? name, 
      String? description, 
      String? startAt, 
      String? endAt, 
      int? batchId, 
      int? batchCycleId, 
      int? status, 
      double? progress,
      String? createdAt, 
      int? createdUserId, 
      int? corpId,
      BatchCycle? batchCycle,
      CheckManager? createdUser,
     }){
    _id = id;
    _name = name;
    _description = description;
    _startAt = startAt;
    _endAt = endAt;
    _batchId = batchId;
    _batchCycleId = batchCycleId;
    _status = status;
    _progress = progress;
    _createdAt = createdAt;
    _createdUserId = createdUserId;
    _corpId = corpId;
    _batchCycle = batchCycle;
    _createdUser = createdUser;
}

  BatchCycleExecute.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _startAt = json['startAt'];
    _endAt = json['endAt'];
    _batchId = json['batchId'];
    _batchCycleId = json['batchCycleId'];
    _status = json['status'];
    _progress = json['progress'];
    _createdAt = json['createdAt'];
    _createdUserId = json['createdUserId'];
    _corpId = json['corpId'];
    _batchCycle = null != json['batchCycle'] ? BatchCycle.fromJson(json['batchCycle']) : null;
    _createdUser = null != json['createdUser'] ? CheckManager.fromJson( json['createdUser']) : null;
  }
  int? _id;
  String? _name;
  String? _description;
  String? _startAt;
  String? _endAt;
  int? _batchId;
  int? _batchCycleId;
  int? _status;
  double? _progress;
  String? _createdAt;
  int? _createdUserId;
  int? _corpId;
  BatchCycle? _batchCycle;
  CheckManager? _createdUser;

BatchCycleExecute copyWith({  int? id,
  String? name,
  String? description,
  String? startAt,
  String? endAt,
  int? batchId,
  int? batchCycleId,
  int? status,
  double? progress,
  String? createdAt,
  int? createdUserId,
  int? corpId,
  BatchCycle? batchCycle,
  CheckManager? createdUser,
}) => BatchCycleExecute(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  startAt: startAt ?? _startAt,
  endAt: endAt ?? _endAt,
  batchId: batchId ?? _batchId,
  batchCycleId: batchCycleId ?? _batchCycleId,
  status: status ?? _status,
  progress: progress ?? _progress,
  createdAt: createdAt ?? _createdAt,
  createdUserId: createdUserId ?? _createdUserId,
  corpId: corpId ?? _corpId,
  batchCycle: batchCycle ?? _batchCycle,
  createdUser: createdUser ?? _createdUser,
);
  int? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get startAt => _startAt;
  String? get endAt => _endAt;
  int? get batchId => _batchId;
  int? get batchCycleId => _batchCycleId;
  int? get status => _status;
  double? get progress => _progress;
  String? get createdAt => _createdAt;
  int? get createdUserId => _createdUserId;
  int? get corpId => _corpId;

  BatchCycle? get batchCycle => _batchCycle;
  CheckManager? get createdUser => _createdUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['startAt'] = _startAt;
    map['endAt'] = _endAt;
    map['batchId'] = _batchId;
    map['batchCycleId'] = _batchCycleId;
    map['status'] = _status;
    map['progress'] = _progress;
    map['createdAt'] = _createdAt;
    map['createdUserId'] = _createdUserId;
    map['corpId'] = _corpId;
    map['batchCycle'] = _batchCycle?.toJson();
    map['createdUser'] = _createdUser?.toJson();
    return map;
  }

  set corpId(int? value) {
    _corpId = value;
  }

  set createdUserId(int? value) {
    _createdUserId = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set progress(double? value) {
    _progress = value;
  }

  set status(int? value) {
    _status = value;
  }

  set batchCycleId(int? value) {
    _batchCycleId = value;
  }

  set batchId(int? value) {
    _batchId = value;
  }

  set endAt(String? value) {
    _endAt = value;
  }

  set startAt(String? value) {
    _startAt = value;
  }

  set description(String? value) {
    _description = value;
  }

  set name(String? value) {
    _name = value;
  }

  set id(int? value) {
    _id = value;
  }

  set createdUser(CheckManager? value) {
    _createdUser = value;
  }

  set batchCycle(BatchCycle? value) {
    _batchCycle = value;
  }




}