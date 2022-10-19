import 'dart:convert';
/// id : 1
/// dealType : ""
/// dealNo : ""
/// dealName : ""
/// occurAt : ""
/// quantity : 9.0
/// amount : 0.00
/// customerId : 1
/// customerName : ""
/// orderNo : ""
/// orderName : ""
/// orderId : 1
/// orderType : ""
/// direction : ""
/// managerId : 1
/// managerName : ""
/// batchName : ""
/// batchId : 1
/// checkStatus : 1
/// status : 1
/// createdBy : ""
/// createdAt : ""
/// updatedBy : ""
/// updatedAt : ""
/// corpId : 2

AccountBill accountBillFromJson(String str) => AccountBill.fromJson(json.decode(str));
String accountBillToJson(AccountBill data) => json.encode(data.toJson());
class AccountBill {
  AccountBill({
      int? id, 
      String? dealType, 
      String? dealNo, 
      String? dealName, 
      String? occurAt, 
      double? quantity, 
      double? amount, 
      int? customerId, 
      String? customerName, 
      String? orderNo, 
      String? orderName, 
      int? orderId, 
      String? orderType, 
      String? direction, 
      int? managerId, 
      String? managerName, 
      String? batchName, 
      int? batchId, 
      int? checkStatus, 
      int? status, 
      String? createdBy, 
      String? createdAt, 
      String? updatedBy, 
      String? updatedAt, 
      int? corpId,}){
    _id = id;
    _dealType = dealType;
    _dealNo = dealNo;
    _dealName = dealName;
    _occurAt = occurAt;
    _quantity = quantity;
    _amount = amount;
    _customerId = customerId;
    _customerName = customerName;
    _orderNo = orderNo;
    _orderName = orderName;
    _orderId = orderId;
    _orderType = orderType;
    _direction = direction;
    _managerId = managerId;
    _managerName = managerName;
    _batchName = batchName;
    _batchId = batchId;
    _checkStatus = checkStatus;
    _status = status;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
    _corpId = corpId;
}

  AccountBill.fromJson(dynamic json) {
    _id = json['id'];
    _dealType = json['dealType'];
    _dealNo = json['dealNo'];
    _dealName = json['dealName'];
    _occurAt = json['occurAt'];
    _quantity = json['quantity'];
    _amount = json['amount'];
    _customerId = json['customerId'];
    _customerName = json['customerName'];
    _orderNo = json['orderNo'];
    _orderName = json['orderName'];
    _orderId = json['orderId'];
    _orderType = json['orderType'];
    _direction = json['direction'];
    _managerId = json['managerId'];
    _managerName = json['managerName'];
    _batchName = json['batchName'];
    _batchId = json['batchId'];
    _checkStatus = json['checkStatus'];
    _status = json['status'];
    _createdBy = json['createdBy'];
    _createdAt = json['createdAt'];
    _updatedBy = json['updatedBy'];
    _updatedAt = json['updatedAt'];
    _corpId = json['corpId'];
  }
  int? _id;
  String? _dealType;
  String? _dealNo;
  String? _dealName;
  String? _occurAt;
  double? _quantity;
  double? _amount;
  int? _customerId;
  String? _customerName;
  String? _orderNo;
  String? _orderName;
  int? _orderId;
  String? _orderType;
  String? _direction;
  int? _managerId;
  String? _managerName;
  String? _batchName;
  int? _batchId;
  int? _checkStatus;
  int? _status;
  String? _createdBy;
  String? _createdAt;
  String? _updatedBy;
  String? _updatedAt;
  int? _corpId;
AccountBill copyWith({  int? id,
  String? dealType,
  String? dealNo,
  String? dealName,
  String? occurAt,
  double? quantity,
  double? amount,
  int? customerId,
  String? customerName,
  String? orderNo,
  String? orderName,
  int? orderId,
  String? orderType,
  String? direction,
  int? managerId,
  String? managerName,
  String? batchName,
  int? batchId,
  int? checkStatus,
  int? status,
  String? createdBy,
  String? createdAt,
  String? updatedBy,
  String? updatedAt,
  int? corpId,
}) => AccountBill(  id: id ?? _id,
  dealType: dealType ?? _dealType,
  dealNo: dealNo ?? _dealNo,
  dealName: dealName ?? _dealName,
  occurAt: occurAt ?? _occurAt,
  quantity: quantity ?? _quantity,
  amount: amount ?? _amount,
  customerId: customerId ?? _customerId,
  customerName: customerName ?? _customerName,
  orderNo: orderNo ?? _orderNo,
  orderName: orderName ?? _orderName,
  orderId: orderId ?? _orderId,
  orderType: orderType ?? _orderType,
  direction: direction ?? _direction,
  managerId: managerId ?? _managerId,
  managerName: managerName ?? _managerName,
  batchName: batchName ?? _batchName,
  batchId: batchId ?? _batchId,
  checkStatus: checkStatus ?? _checkStatus,
  status: status ?? _status,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
  corpId: corpId ?? _corpId,
);
  int? get id => _id;
  String? get dealType => _dealType;
  String? get dealNo => _dealNo;
  String? get dealName => _dealName;
  String? get occurAt => _occurAt;
  double? get quantity => _quantity;
  double? get amount => _amount;
  int? get customerId => _customerId;
  String? get customerName => _customerName;
  String? get orderNo => _orderNo;
  String? get orderName => _orderName;
  int? get orderId => _orderId;
  String? get orderType => _orderType;
  String? get direction => _direction;
  int? get managerId => _managerId;
  String? get managerName => _managerName;
  String? get batchName => _batchName;
  int? get batchId => _batchId;
  int? get checkStatus => _checkStatus;
  int? get status => _status;
  String? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  String? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;
  int? get corpId => _corpId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['dealType'] = _dealType;
    map['dealNo'] = _dealNo;
    map['dealName'] = _dealName;
    map['occurAt'] = _occurAt;
    map['quantity'] = _quantity;
    map['amount'] = _amount;
    map['customerId'] = _customerId;
    map['customerName'] = _customerName;
    map['orderNo'] = _orderNo;
    map['orderName'] = _orderName;
    map['orderId'] = _orderId;
    map['orderType'] = _orderType;
    map['direction'] = _direction;
    map['managerId'] = _managerId;
    map['managerName'] = _managerName;
    map['batchName'] = _batchName;
    map['batchId'] = _batchId;
    map['checkStatus'] = _checkStatus;
    map['status'] = _status;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['updatedBy'] = _updatedBy;
    map['updatedAt'] = _updatedAt;
    map['corpId'] = _corpId;
    return map;
  }

}