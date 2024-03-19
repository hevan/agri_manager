import 'dart:convert';

import 'package:agri_manager/src/model/sys/Address.dart';
/// id : 1
/// name : "农业产业研究院"
/// code : "1001"
/// description : "农业，产业园，研发"
/// addressId : 1
/// createdAt : "2022-12-06 00:00:00"
/// address : {"id":1,"province":"广东省","city":"广州市","region":"天河区","lineDetail":"汇彩路8号","linkName":"王海文","linkMobile":"18688868390","location":null,"createdAt":"2022-12-06 00:00:00"}

Corp corpFromJson(String str) => Corp.fromJson(json.decode(str));
String corpToJson(Corp data) => json.encode(data.toJson());
class Corp {
  Corp({
      int? id,
      String? name, 
      String? code, 
      String? description, 
      int? addressId,
      String? createdAt,
      int? createdUserId,
      Address? address,
    int? countProject,
    int? countTask,
    int? countApply,
    int? countCheck ,
     }){
    _id = id;
    _name = name;
    _code = code;
    _description = description;
    _addressId = addressId;
    _createdAt = createdAt;
    _createdUserId = createdUserId;
    _address = address;
    _countProject = countProject;
    _countTask = countTask;
    _countApply = countApply;
    _countCheck = countCheck;
}

  Corp.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _description = json['description'];
    _addressId = json['addressId'];
    _createdAt = json['createdAt'];
    _createdUserId = json['createdUserId'];
    _address = json['address'] != null ? Address.fromJson(json['address']) : null;

    _countProject = json['countProject'];
    _countTask = json['countTask'];
    _countApply = json['countApply'];
    _countCheck = json['countCheck'];
  }
  int? _id;
  String? _name;
  String? _code;
  String? _description;
  int? _addressId;
  String? _createdAt;
  int? _createdUserId;
  Address? _address;
  int? _countProject;
  int? _countTask;
  int? _countApply;
  int? _countCheck;


Corp copyWith({  int? id,
  String? name,
  String? code,
  String? description,
  int? addressId,
  String? createdAt,
  int? createdUserId,
  Address? address,
  int? countProject,
  int? countTask,
  int? countApply,
  int? countCheck
}) => Corp(  id: id ?? _id,
  name: name ?? _name,
  code: code ?? _code,
  description: description ?? _description,
  addressId: addressId ?? _addressId,
  createdAt: createdAt ?? _createdAt,
  createdUserId: createdUserId ?? _createdUserId,
  address: address ?? _address,
  countProject: countProject ?? _countProject,
  countTask: countTask ?? _countTask,
  countApply: countApply ?? _countApply,
  countCheck: countCheck ?? _countCheck,
);
  int? get id => _id;
  String? get name => _name;
  String? get code => _code;
  String? get description => _description;
  int? get addressId => _addressId;
  String? get createdAt => _createdAt;
  int? get createdUserId => _createdUserId;
  Address? get address => _address;
  int? get countTask => _countTask;
  int? get countProject => _countProject;
  int? get countApply => _countApply;
  int? get countCheck => _countCheck;



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['description'] = _description;
    map['addressId'] = _addressId;
    map['createdUserId'] = _createdUserId;
    map['createdAt'] = _createdAt;
    if (_address != null) {
      map['address'] = _address?.toJson();
    }
    return map;
  }

  set countProject(int? value) {
    _countProject = value;
  }

  set id(int? value) {
    _id = value;
  }
  set name(String? value) {
    _name = value;
  }

  set code(String? value) {
    _code = value;
  }

  set description(String? value) {
    _description = value;
  }

  set addressId(int? value) {
    _addressId = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set address(Address? value) {
    _address = value;
  }


  set countTask(int? value) {
    _countTask = value;
  }


  set countApply(int? value) {
    _countApply = value;
  }

  set countCheck(int? value) {
    _countCheck = value;
  }

  set createdUserId(int? value) {
    _createdUserId = value;
  }
}

