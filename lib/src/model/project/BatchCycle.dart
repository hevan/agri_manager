import 'dart:convert';
/// id : 3
/// name : ""
/// description : ""
/// imageUrl : ""
/// days : 20
/// startAt : ""
/// endAt : ""
/// investEstimated : 8.00
/// investReal : 8.99
/// batchId : 1
/// batchName : ""
/// productId : 1
/// productName : ""
/// status : 1
/// progress : 0.8
/// parentId : 1
/// children : []

BatchCycle batchCycleFromJson(String str) => BatchCycle.fromJson(json.decode(str));
String batchCycleToJson(BatchCycle data) => json.encode(data.toJson());
class BatchCycle {
  BatchCycle({
      int? id, 
      String? name, 
      String? description, 
      String? imageUrl, 
      int? days,
    double? investEstimated,
      String? startAt, 
      String? endAt,
      int? batchId,
      int? status, 
      double? progress, 
      int? parentId,
      int?    createdUserId,
    String? createdAt,
    int? cycleType,
    int? corpId,
    List<BatchCycle>? children,}){
    _id = id;
    _name = name;
    _description = description;
    _imageUrl = imageUrl;
    _days = days;
    _startAt = startAt;
    _endAt = endAt;
    _batchId = batchId;
    _status = status;
    _progress = progress;
    _parentId = parentId;
    _investEstimated = investEstimated;
    _children = children;
    _createdUserId = createdUserId;
    _createdAt = createdAt;
    _cycleType = cycleType;
    _corpId = corpId;
}

  BatchCycle.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _imageUrl = json['imageUrl'];
    _days = json['days'];
    _startAt = json['startAt'];
    _endAt = json['endAt'];
    _batchId = json['batchId'];
    _status = json['status'];
    _progress = json['progress'];
    _investEstimated = json['investEstimated'];
    _parentId = json['parentId'];
    _createdAt = json['createdAt'];
    _createdUserId = json['createdUserId'];
    _cycleType = json['cycleType'];
    _corpId = json['corpId'];
    if (json['children'] != null) {
      _children = [];
      json['children'].forEach((v) {
        _children?.add(BatchCycle.fromJson(v));
      });
    }
  }
  int? _id;
  String? _name;
  String? _description;
  String? _imageUrl;
  int? _days;
  String? _startAt;
  String? _endAt;
  int? _batchId;
  int? _status;
  double? _progress;
  double? _investEstimated;
  int? _parentId;
  int? _cycleType;
  String? _createdAt;
  int? _createdUserId;
  int? _corpId;
  List<BatchCycle>? _children;


BatchCycle copyWith({  int? id,
  String? name,
  String? description,
  String? imageUrl,
  int? days,
  String? startAt,
  String? endAt,
  int? batchId,
  int? status,
  double? progress,
  double? investEstimated,
  int? parentId,
  String? createdAt,
  int? createdUserId,
  int? cycleType,
  List<BatchCycle>? children,
}) => BatchCycle(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  imageUrl: imageUrl ?? _imageUrl,
  days: days ?? _days,
  startAt: startAt ?? _startAt,
  endAt: endAt ?? _endAt,
   batchId: batchId ?? _batchId,
    status: status ?? _status,
  progress: progress ?? _progress,
  investEstimated: investEstimated ?? _investEstimated,
  parentId: parentId ?? _parentId,
  createdAt: createdAt ?? _createdAt,
  createdUserId: createdUserId ?? _createdUserId,
  cycleType: cycleType ?? _cycleType,
  children: children ?? _children,
  corpId: corpId ?? _corpId,
);
  int? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get imageUrl => _imageUrl;
  int? get days => _days;
  String? get startAt => _startAt;
  String? get endAt => _endAt;
  int? get batchId => _batchId;
  int? get status => _status;
  double? get progress => _progress;
  int? get parentId => _parentId;
  String? get createdAt => _createdAt;
  int? get createdUserId => _createdUserId;
  int? get cycleType => _cycleType;
  int? get corpId => _corpId;

  double? get investEstimated => _investEstimated;
  List<BatchCycle>? get children => _children;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['imageUrl'] = _imageUrl;
    map['days'] = _days;
    map['startAt'] = _startAt;
    map['endAt'] = _endAt;
    map['investEstimated'] = _investEstimated;
    map['batchId'] = _batchId;
    map['status'] = _status;
    map['progress'] = _progress;
    map['parentId'] = _parentId;
    map['createdUserId'] = _createdUserId;
    map['createdAt'] = _createdAt;
    map['cycleType'] = _cycleType;
    map['corpId'] = _corpId;
    if (_children != null) {
      map['children'] = _children?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  set children(List<BatchCycle>? value) {
    _children = value;
  }

  set createdUserId(int? value) {
    _createdUserId = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set parentId(int? value) {
    _parentId = value;
  }

  set progress(double? value) {
    _progress = value;
  }

  set investEstimated(double? value) {
    _investEstimated = value;
  }

  set status(int? value) {
    _status = value;
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

  set days(int? value) {
    _days = value;
  }

  set imageUrl(String? value) {
    _imageUrl = value;
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

  set cycleType(int? value) {
    _cycleType = value;
  }

  set corpId(int? value) {
    _corpId = value;
  }
}