import 'dart:convert';
/// batchId : 1
/// batchName : ""
/// productId : 1
/// productName : ""

BatchProductDto batchProductDtoFromJson(String str) => BatchProductDto.fromJson(json.decode(str));
String batchProductDtoToJson(BatchProductDto data) => json.encode(data.toJson());
class BatchProductDto {
  BatchProductDto({
      num? batchId, 
      String? batchName, 
      num? productId, 
      String? productName,}){
    _batchId = batchId;
    _batchName = batchName;
    _productId = productId;
    _productName = productName;
}

  BatchProductDto.fromJson(dynamic json) {
    _batchId = json['batchId'];
    _batchName = json['batchName'];
    _productId = json['productId'];
    _productName = json['productName'];
  }
  num? _batchId;
  String? _batchName;
  num? _productId;
  String? _productName;
BatchProductDto copyWith({  num? batchId,
  String? batchName,
  num? productId,
  String? productName,
}) => BatchProductDto(  batchId: batchId ?? _batchId,
  batchName: batchName ?? _batchName,
  productId: productId ?? _productId,
  productName: productName ?? _productName,
);
  num? get batchId => _batchId;
  String? get batchName => _batchName;
  num? get productId => _productId;
  String? get productName => _productName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['batchId'] = _batchId;
    map['batchName'] = _batchName;
    map['productId'] = _productId;
    map['productName'] = _productName;
    return map;
  }

}