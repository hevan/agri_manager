import 'dart:convert';
/// id : 1
/// name : ""
/// orderNo : ""
/// quantity : 66.00
/// amount : 899.00
/// originId : 1
/// originType : ""
/// originNo : ""
/// storeId : 1
/// storeName : ""
/// direction : 1
/// checkStatus : 1
/// status : 1
/// occurAt : ""
/// createdBy : ""
/// createdAt : ""
/// updatedBy : ""
/// updatedAt : ""
/// corpId : 1

Stock stockFromJson(String str) => Stock.fromJson(json.decode(str));
String stockToJson(Stock data) => json.encode(data.toJson());
class Stock {
  Stock({
      int? id, 
      String? name, 
      String? orderNo, 
      double? quantity, 
      double? amount, 
      int? originId, 
      String? originType, 
      String? originNo, 
      int? storeId, 
      String? storeName, 
      int? direction, 
      int? checkStatus, 
      int? status, 
      String? occurAt, 
      String? createdBy, 
      String? createdAt, 
      String? updatedBy, 
      String? updatedAt, 
      int? corpId,}){
    _id = id;
    _name = name;
    _orderNo = orderNo;
    _quantity = quantity;
    _amount = amount;
    _originId = originId;
    _originType = originType;
    _originNo = originNo;
    _storeId = storeId;
    _storeName = storeName;
    _direction = direction;
    _checkStatus = checkStatus;
    _status = status;
    _occurAt = occurAt;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
    _corpId = corpId;
}

  Stock.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _orderNo = json['orderNo'];
    _quantity = json['quantity'];
    _amount = json['amount'];
    _originId = json['originId'];
    _originType = json['originType'];
    _originNo = json['originNo'];
    _storeId = json['storeId'];
    _storeName = json['storeName'];
    _direction = json['direction'];
    _checkStatus = json['checkStatus'];
    _status = json['status'];
    _occurAt = json['occurAt'];
    _createdBy = json['createdBy'];
    _createdAt = json['createdAt'];
    _updatedBy = json['updatedBy'];
    _updatedAt = json['updatedAt'];
    _corpId = json['corpId'];
  }
  int? _id;
  String? _name;
  String? _orderNo;
  double? _quantity;
  double? _amount;
  int? _originId;
  String? _originType;
  String? _originNo;
  int? _storeId;
  String? _storeName;
  int? _direction;
  int? _checkStatus;
  int? _status;
  String? _occurAt;
  String? _createdBy;
  String? _createdAt;
  String? _updatedBy;
  String? _updatedAt;
  int? _corpId;
Stock copyWith({  int? id,
  String? name,
  String? orderNo,
  double? quantity,
  double? amount,
  int? originId,
  String? originType,
  String? originNo,
  int? storeId,
  String? storeName,
  int? direction,
  int? checkStatus,
  int? status,
  String? occurAt,
  String? createdBy,
  String? createdAt,
  String? updatedBy,
  String? updatedAt,
  int? corpId,
}) => Stock(  id: id ?? _id,
  name: name ?? _name,
  orderNo: orderNo ?? _orderNo,
  quantity: quantity ?? _quantity,
  amount: amount ?? _amount,
  originId: originId ?? _originId,
  originType: originType ?? _originType,
  originNo: originNo ?? _originNo,
  storeId: storeId ?? _storeId,
  storeName: storeName ?? _storeName,
  direction: direction ?? _direction,
  checkStatus: checkStatus ?? _checkStatus,
  status: status ?? _status,
  occurAt: occurAt ?? _occurAt,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
  corpId: corpId ?? _corpId,
);
  int? get id => _id;
  String? get name => _name;
  String? get orderNo => _orderNo;
  double? get quantity => _quantity;
  double? get amount => _amount;
  int? get originId => _originId;
  String? get originType => _originType;
  String? get originNo => _originNo;
  int? get storeId => _storeId;
  String? get storeName => _storeName;
  int? get direction => _direction;
  int? get checkStatus => _checkStatus;
  int? get status => _status;
  String? get occurAt => _occurAt;
  String? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  String? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;
  int? get corpId => _corpId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['orderNo'] = _orderNo;
    map['quantity'] = _quantity;
    map['amount'] = _amount;
    map['originId'] = _originId;
    map['originType'] = _originType;
    map['originNo'] = _originNo;
    map['storeId'] = _storeId;
    map['storeName'] = _storeName;
    map['direction'] = _direction;
    map['checkStatus'] = _checkStatus;
    map['status'] = _status;
    map['occurAt'] = _occurAt;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['updatedBy'] = _updatedBy;
    map['updatedAt'] = _updatedAt;
    map['corpId'] = _corpId;
    return map;
  }

}