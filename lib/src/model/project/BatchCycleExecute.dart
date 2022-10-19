import 'dart:convert';
/// id : 1
/// name : ""
/// description : ""
/// batchId : 1
/// batchName : ""
/// batchCycleId : 1
/// batchCycleName : ""
/// startAt : ""
/// endAt : ""
/// quantity : 0.9
/// price : 5.5
/// amount : 5.6
/// investProductId : 3
/// investProductName : ""
/// customerId : 4
/// customerName : ""
/// contractId : 7
/// contractName : ""
/// managerId : 6
/// managerName : ""
/// status : 2
/// customerSign : ""
/// managerSign : ""
/// createdAt : ""
/// corpId : 1

BatchCycleExecute batchCycleExecuteFromJson(String str) => BatchCycleExecute.fromJson(json.decode(str));
String batchCycleExecuteToJson(BatchCycleExecute data) => json.encode(data.toJson());
class BatchCycleExecute {
  BatchCycleExecute({
      int? id, 
      String? name, 
      String? description, 
      int? batchId, 
      String? batchName, 
      int? batchCycleId, 
      String? batchCycleName, 
      String? startAt, 
      String? endAt, 
      double? quantity, 
      double? price, 
      double? amount, 
      int? investProductId, 
      String? investProductName, 
      int? customerId, 
      String? customerName, 
      int? contractId, 
      String? contractName, 
      int? managerId, 
      String? managerName, 
      int? status, 
      String? customerSign, 
      String? managerSign, 
      String? createdAt, 
      int? corpId,}){
    _id = id;
    _name = name;
    _description = description;
    _batchId = batchId;
    _batchName = batchName;
    _batchCycleId = batchCycleId;
    _batchCycleName = batchCycleName;
    _startAt = startAt;
    _endAt = endAt;
    _quantity = quantity;
    _price = price;
    _amount = amount;
    _investProductId = investProductId;
    _investProductName = investProductName;
    _customerId = customerId;
    _customerName = customerName;
    _contractId = contractId;
    _contractName = contractName;
    _managerId = managerId;
    _managerName = managerName;
    _status = status;
    _customerSign = customerSign;
    _managerSign = managerSign;
    _createdAt = createdAt;
    _corpId = corpId;
}

  BatchCycleExecute.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _batchId = json['batchId'];
    _batchName = json['batchName'];
    _batchCycleId = json['batchCycleId'];
    _batchCycleName = json['batchCycleName'];
    _startAt = json['startAt'];
    _endAt = json['endAt'];
    _quantity = json['quantity'];
    _price = json['price'];
    _amount = json['amount'];
    _investProductId = json['investProductId'];
    _investProductName = json['investProductName'];
    _customerId = json['customerId'];
    _customerName = json['customerName'];
    _contractId = json['contractId'];
    _contractName = json['contractName'];
    _managerId = json['managerId'];
    _managerName = json['managerName'];
    _status = json['status'];
    _customerSign = json['customerSign'];
    _managerSign = json['managerSign'];
    _createdAt = json['createdAt'];
    _corpId = json['corpId'];
  }
  int? _id;
  String? _name;
  String? _description;
  int? _batchId;
  String? _batchName;
  int? _batchCycleId;
  String? _batchCycleName;
  String? _startAt;
  String? _endAt;
  double? _quantity;
  double? _price;
  double? _amount;
  int? _investProductId;
  String? _investProductName;
  int? _customerId;
  String? _customerName;
  int? _contractId;
  String? _contractName;
  int? _managerId;
  String? _managerName;
  int? _status;
  String? _customerSign;
  String? _managerSign;
  String? _createdAt;
  int? _corpId;
BatchCycleExecute copyWith({  int? id,
  String? name,
  String? description,
  int? batchId,
  String? batchName,
  int? batchCycleId,
  String? batchCycleName,
  String? startAt,
  String? endAt,
  double? quantity,
  double? price,
  double? amount,
  int? investProductId,
  String? investProductName,
  int? customerId,
  String? customerName,
  int? contractId,
  String? contractName,
  int? managerId,
  String? managerName,
  int? status,
  String? customerSign,
  String? managerSign,
  String? createdAt,
  int? corpId,
}) => BatchCycleExecute(  id: id ?? _id,
  name: name ?? _name,
  description: description ?? _description,
  batchId: batchId ?? _batchId,
  batchName: batchName ?? _batchName,
  batchCycleId: batchCycleId ?? _batchCycleId,
  batchCycleName: batchCycleName ?? _batchCycleName,
  startAt: startAt ?? _startAt,
  endAt: endAt ?? _endAt,
  quantity: quantity ?? _quantity,
  price: price ?? _price,
  amount: amount ?? _amount,
  investProductId: investProductId ?? _investProductId,
  investProductName: investProductName ?? _investProductName,
  customerId: customerId ?? _customerId,
  customerName: customerName ?? _customerName,
  contractId: contractId ?? _contractId,
  contractName: contractName ?? _contractName,
  managerId: managerId ?? _managerId,
  managerName: managerName ?? _managerName,
  status: status ?? _status,
  customerSign: customerSign ?? _customerSign,
  managerSign: managerSign ?? _managerSign,
  createdAt: createdAt ?? _createdAt,
  corpId: corpId ?? _corpId,
);
  int? get id => _id;
  String? get name => _name;
  String? get description => _description;
  int? get batchId => _batchId;
  String? get batchName => _batchName;
  int? get batchCycleId => _batchCycleId;
  String? get batchCycleName => _batchCycleName;
  String? get startAt => _startAt;
  String? get endAt => _endAt;
  double? get quantity => _quantity;
  double? get price => _price;
  double? get amount => _amount;
  int? get investProductId => _investProductId;
  String? get investProductName => _investProductName;
  int? get customerId => _customerId;
  String? get customerName => _customerName;
  int? get contractId => _contractId;
  String? get contractName => _contractName;
  int? get managerId => _managerId;
  String? get managerName => _managerName;
  int? get status => _status;
  String? get customerSign => _customerSign;
  String? get managerSign => _managerSign;
  String? get createdAt => _createdAt;
  int? get corpId => _corpId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['batchId'] = _batchId;
    map['batchName'] = _batchName;
    map['batchCycleId'] = _batchCycleId;
    map['batchCycleName'] = _batchCycleName;
    map['startAt'] = _startAt;
    map['endAt'] = _endAt;
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['amount'] = _amount;
    map['investProductId'] = _investProductId;
    map['investProductName'] = _investProductName;
    map['customerId'] = _customerId;
    map['customerName'] = _customerName;
    map['contractId'] = _contractId;
    map['contractName'] = _contractName;
    map['managerId'] = _managerId;
    map['managerName'] = _managerName;
    map['status'] = _status;
    map['customerSign'] = _customerSign;
    map['managerSign'] = _managerSign;
    map['createdAt'] = _createdAt;
    map['corpId'] = _corpId;
    return map;
  }

}