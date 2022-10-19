import 'dart:convert';
/// id : 1
/// name : "ss"
/// imageUrl : ""
/// description : "ss"
/// productId : 2
/// productName : "ss"
/// days : 5
/// amount : 80.00
/// parentId : 1
/// children : []

ProductCycle productCycleFromJson(String str) => ProductCycle.fromJson(json.decode(str));
String productCycleToJson(ProductCycle data) => json.encode(data.toJson());
class ProductCycle {
  ProductCycle({
      int? id, 
      String? name, 
      String? imageUrl, 
      String? description, 
      int? productId, 
      String? productName,
      String? sequence,
    int? days,
      double? amount, 
      int? parentId, 
      List<ProductCycle>? children,}){
    _id = id;
    _name = name;
    _imageUrl = imageUrl;
    _description = description;
    _productId = productId;
    _productName = productName;
    _sequence = sequence;
    _days = days;
    _amount = amount;
    _parentId = parentId;
    _children = children;
}

  ProductCycle.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _imageUrl = json['imageUrl'];
    _description = json['description'];
    _productId = json['productId'];
    _productName = json['productName'];
    _sequence = json['sequence'];
    _days = json['days'];
    _amount = json['amount'];
    _parentId = json['parentId'];
    if (json['children'] != null) {
      _children = [];
      json['children'].forEach((v) {
        _children?.add(ProductCycle.fromJson(v));
      });
    }
  }
  int? _id;
  String? _name;
  String? _imageUrl;
  String? _description;
  int? _productId;
  String? _productName;
  String? _sequence;
  int? _days;
  double? _amount;
  int? _parentId;
  List<ProductCycle>? _children;


  ProductCycle copyWith({  int? id,
  String? name,
  String? imageUrl,
  String? description,
  int? productId,
  String? productName,
    String? sequence,
  int? days,
  double? amount,
  int? parentId,
  List<ProductCycle>? children,
}) => ProductCycle(  id: id ?? _id,
  name: name ?? _name,
  imageUrl: imageUrl ?? _imageUrl,
  description: description ?? _description,
  productId: productId ?? _productId,
  productName: productName ?? _productName,
    sequence: sequence ?? _sequence,
  days: days ?? _days,
  amount: amount ?? _amount,
  parentId: parentId ?? _parentId,
  children: children ?? _children,
);
  int? get id => _id;
  String? get name => _name;
  String? get imageUrl => _imageUrl;
  String? get description => _description;
  int? get productId => _productId;
  String? get productName => _productName;
  int? get days => _days;
  double? get amount => _amount;
  int? get parentId => _parentId;
  List<ProductCycle>? get children => _children;

  String? get sequence => _sequence;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['imageUrl'] = _imageUrl;
    map['description'] = _description;
    map['productId'] = _productId;
    map['productName'] = _productName;
    map['sequence'] = _sequence;
    map['days'] = _days;
    map['amount'] = _amount;
    map['parentId'] = _parentId;
    if (_children != null) {
      map['children'] = _children?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  set id(int? value) {
    _id = value;
  }

  set name(String? value) {
    _name = value;
  }

  set imageUrl(String? value) {
    _imageUrl = value;
  }

  set description(String? value) {
    _description = value;
  }

  set productId(int? value) {
    _productId = value;
  }

  set productName(String? value) {
    _productName = value;
  }

  set days(int? value) {
    _days = value;
  }

  set amount(double? value) {
    _amount = value;
  }

  set parentId(int? value) {
    _parentId = value;
  }

  set children(List<ProductCycle>? value) {
    _children = value;
  }

  set sequence(String? value) {
    _sequence = value;
  }
}