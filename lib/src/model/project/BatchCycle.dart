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
      String? startAt, 
      String? endAt, 
      double? investEstimated, 
      double? investReal, 
      int? batchId, 
      String? batchName, 
      int? productId, 
      String? productName, 
      int? status, 
      double? progress, 
      int? parentId,
      String? managerName,
      int?    managerId,
      List<BatchCycle>? children,}){
    _id = id;
    _name = name;
    _description = description;
    _imageUrl = imageUrl;
    _days = days;
    _startAt = startAt;
    _endAt = endAt;
    _investEstimated = investEstimated;
    _investReal = investReal;
    _batchId = batchId;
    _batchName = batchName;
    _productId = productId;
    _productName = productName;
    _status = status;
    _progress = progress;
    _parentId = parentId;
    _children = children;
    _managerId = managerId;
    _managerName = managerName;
}

  BatchCycle.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _imageUrl = json['imageUrl'];
    _days = json['days'];
    _startAt = json['startAt'];
    _endAt = json['endAt'];
    _investEstimated = json['investEstimated'];
    _investReal = json['investReal'];
    _batchId = json['batchId'];
    _batchName = json['batchName'];
    _productId = json['productId'];
    _productName = json['productName'];
    _status = json['status'];
    _progress = json['progress'];
    _parentId = json['parentId'];
    _managerName = json['managerName'];
    _managerId = json['managerId'];
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
  double? _investEstimated;
  double? _investReal;
  int? _batchId;
  String? _batchName;
  int? _productId;
  String? _productName;
  int? _status;
  double? _progress;
  int? _parentId;
  String? _managerName;
  int? _managerId;
  List<BatchCycle>? _children;
BatchCycle copyWith({  int? id,
  String? name,
  String? description,
  String? imageUrl,
  int? days,
  String? startAt,
  String? endAt,
  double? investEstimated,
  double? investReal,
  int? batchId,
  String? batchName,
  int? productId,
  String? productName,
  int? status,
  double? progress,
  int? parentId,
  String? managerName,
  int? managerId,
  List<BatchCycle>? children,
}) => BatchCycle(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  imageUrl: imageUrl ?? _imageUrl,
  days: days ?? _days,
  startAt: startAt ?? _startAt,
  endAt: endAt ?? _endAt,
  investEstimated: investEstimated ?? _investEstimated,
  investReal: investReal ?? _investReal,
  batchId: batchId ?? _batchId,
  batchName: batchName ?? _batchName,
  productId: productId ?? _productId,
  productName: productName ?? _productName,
  status: status ?? _status,
  progress: progress ?? _progress,
  parentId: parentId ?? _parentId,
  managerName: managerName ?? _managerName,
  managerId: managerId ?? _managerId,
  children: children ?? _children,
);
  int? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get imageUrl => _imageUrl;
  int? get days => _days;
  String? get startAt => _startAt;
  String? get endAt => _endAt;
  double? get investEstimated => _investEstimated;
  double? get investReal => _investReal;
  int? get batchId => _batchId;
  String? get batchName => _batchName;
  int? get productId => _productId;
  String? get productName => _productName;
  int? get status => _status;
  double? get progress => _progress;
  int? get parentId => _parentId;
  String? get managerName => _managerName;
  int? get managerId => _managerId;
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
    map['investReal'] = _investReal;
    map['batchId'] = _batchId;
    map['batchName'] = _batchName;
    map['productId'] = _productId;
    map['productName'] = _productName;
    map['status'] = _status;
    map['progress'] = _progress;
    map['parentId'] = _parentId;
    map['managerId'] = _managerId;
    map['managerName'] = _managerName;
    if (_children != null) {
      map['children'] = _children?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  set children(List<BatchCycle>? value) {
    _children = value;
  }

  set managerId(int? value) {
    _managerId = value;
  }

  set managerName(String? value) {
    _managerName = value;
  }

  set parentId(int? value) {
    _parentId = value;
  }

  set progress(double? value) {
    _progress = value;
  }

  set status(int? value) {
    _status = value;
  }

  set productName(String? value) {
    _productName = value;
  }

  set productId(int? value) {
    _productId = value;
  }

  set batchName(String? value) {
    _batchName = value;
  }

  set batchId(int? value) {
    _batchId = value;
  }

  set investReal(double? value) {
    _investReal = value;
  }

  set investEstimated(double? value) {
    _investEstimated = value;
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
}