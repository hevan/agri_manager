import 'dart:convert';
/// id : 3
/// name : ""
/// orderNo : ""
/// customerName : ""
/// customerId : 4
/// quantity : 5
/// amount : 0.00
/// batchId : 1
/// batchName : ""
/// storeId : ""
/// storeName : ""
/// status : 1
/// checkStatus : 1
/// createdBy : ""
/// createdAt : ""
/// updatedBy : ""
/// updatedAt : ""
/// corpId : 5

SaleOrder saleOrderFromJson(String str) => SaleOrder.fromJson(json.decode(str));
String saleOrderToJson(SaleOrder data) => json.encode(data.toJson());
class SaleOrder {
  SaleOrder({
      int? id, 
      String? name, 
      String? orderNo, 
      String? customerName, 
      int? customerId, 
      int? quantity, 
      double? amount, 
      int? batchId, 
      String? batchName, 
      String? storeId, 
      String? storeName, 
      int? status, 
      int? checkStatus, 
      String? createdBy, 
      String? createdAt, 
      String? updatedBy, 
      String? updatedAt, 
      int? corpId,}){
    _id = id;
    _name = name;
    _orderNo = orderNo;
    _customerName = customerName;
    _customerId = customerId;
    _quantity = quantity;
    _amount = amount;
    _batchId = batchId;
    _batchName = batchName;
    _storeId = storeId;
    _storeName = storeName;
    _status = status;
    _checkStatus = checkStatus;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
    _corpId = corpId;
}

  SaleOrder.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _orderNo = json['orderNo'];
    _customerName = json['customerName'];
    _customerId = json['customerId'];
    _quantity = json['quantity'];
    _amount = json['amount'];
    _batchId = json['batchId'];
    _batchName = json['batchName'];
    _storeId = json['storeId'];
    _storeName = json['storeName'];
    _status = json['status'];
    _checkStatus = json['checkStatus'];
    _createdBy = json['createdBy'];
    _createdAt = json['createdAt'];
    _updatedBy = json['updatedBy'];
    _updatedAt = json['updatedAt'];
    _corpId = json['corpId'];
  }
  int? _id;
  String? _name;
  String? _orderNo;
  String? _customerName;
  int? _customerId;
  int? _quantity;
  double? _amount;
  int? _batchId;
  String? _batchName;
  String? _storeId;
  String? _storeName;
  int? _status;
  int? _checkStatus;
  String? _createdBy;
  String? _createdAt;
  String? _updatedBy;
  String? _updatedAt;
  int? _corpId;
SaleOrder copyWith({  int? id,
  String? name,
  String? orderNo,
  String? customerName,
  int? customerId,
  int? quantity,
  double? amount,
  int? batchId,
  String? batchName,
  String? storeId,
  String? storeName,
  int? status,
  int? checkStatus,
  String? createdBy,
  String? createdAt,
  String? updatedBy,
  String? updatedAt,
  int? corpId,
}) => SaleOrder(  id: id ?? _id,
  name: name ?? _name,
  orderNo: orderNo ?? _orderNo,
  customerName: customerName ?? _customerName,
  customerId: customerId ?? _customerId,
  quantity: quantity ?? _quantity,
  amount: amount ?? _amount,
  batchId: batchId ?? _batchId,
  batchName: batchName ?? _batchName,
  storeId: storeId ?? _storeId,
  storeName: storeName ?? _storeName,
  status: status ?? _status,
  checkStatus: checkStatus ?? _checkStatus,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
  corpId: corpId ?? _corpId,
);
  int? get id => _id;
  String? get name => _name;
  String? get orderNo => _orderNo;
  String? get customerName => _customerName;
  int? get customerId => _customerId;
  int? get quantity => _quantity;
  double? get amount => _amount;
  int? get batchId => _batchId;
  String? get batchName => _batchName;
  String? get storeId => _storeId;
  String? get storeName => _storeName;
  int? get status => _status;
  int? get checkStatus => _checkStatus;
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
    map['customerName'] = _customerName;
    map['customerId'] = _customerId;
    map['quantity'] = _quantity;
    map['amount'] = _amount;
    map['batchId'] = _batchId;
    map['batchName'] = _batchName;
    map['storeId'] = _storeId;
    map['storeName'] = _storeName;
    map['status'] = _status;
    map['checkStatus'] = _checkStatus;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['updatedBy'] = _updatedBy;
    map['updatedAt'] = _updatedAt;
    map['corpId'] = _corpId;
    return map;
  }

}