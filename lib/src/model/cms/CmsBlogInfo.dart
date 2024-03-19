import 'dart:convert';
/// id : ""
/// title : ""
/// author : ""
/// categoryId : ""
/// categoryCode : ""
/// categoryName : ""
/// tags : ""
/// description : ""
/// publishAt : ""
/// imageUrl : ""
/// videoUrl : ""
/// corpId : ""
/// countView : ""
/// countRaiseUp : ""
/// countRaiseDown : ""

CmsBlogInfo cmsBlogInfoFromJson(String str) => CmsBlogInfo.fromJson(json.decode(str));
String cmsBlogInfoToJson(CmsBlogInfo data) => json.encode(data.toJson());
class CmsBlogInfo {
  CmsBlogInfo({
      int? id, 
      String? title, 
      String? author, 
      int? categoryId,
      String? categoryCode, 
      String? categoryName, 
      String? tags, 
      String? description, 
      String? publishAt, 
      String? imageUrl, 
      String? videoUrl, 
      int? corpId,
      int? countView, 
      int? countRaiseUp,
      int? countRaiseDown,}){
    _id = id;
    _title = title;
    _author = author;
    _categoryId = categoryId;
    _categoryCode = categoryCode;
    _categoryName = categoryName;
    _tags = tags;
    _description = description;
    _publishAt = publishAt;
    _imageUrl = imageUrl;
    _videoUrl = videoUrl;
    _corpId = corpId;
    _countView = countView;
    _countRaiseUp = countRaiseUp;
    _countRaiseDown = countRaiseDown;
}

  CmsBlogInfo.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _author = json['author'];
    _categoryId = json['categoryId'];
    _categoryCode = json['categoryCode'];
    _categoryName = json['categoryName'];
    _tags = json['tags'];
    _description = json['description'];
    _publishAt = json['publishAt'];
    _imageUrl = json['imageUrl'];
    _videoUrl = json['videoUrl'];
    _corpId = json['corpId'];
    _countView = json['countView'];
    _countRaiseUp = json['countRaiseUp'];
    _countRaiseDown = json['countRaiseDown'];
  }
  int? _id;
  String? _title;
  String? _author;
  int? _categoryId;
  String? _categoryCode;
  String? _categoryName;
  String? _tags;
  String? _description;
  String? _publishAt;
  String? _imageUrl;
  String? _videoUrl;
  int? _corpId;
  int? _countView;
  int? _countRaiseUp;
  int? _countRaiseDown;
CmsBlogInfo copyWith({  int? id,
  String? title,
  String? author,
  int? categoryId,
  String? categoryCode,
  String? categoryName,
  String? tags,
  String? description,
  String? publishAt,
  String? imageUrl,
  String? videoUrl,
  int? corpId,
  int? countView,
  int? countRaiseUp,
  int? countRaiseDown,
}) => CmsBlogInfo(  id: id ?? _id,
  title: title ?? _title,
  author: author ?? _author,
  categoryId: categoryId ?? _categoryId,
  categoryCode: categoryCode ?? _categoryCode,
  categoryName: categoryName ?? _categoryName,
  tags: tags ?? _tags,
  description: description ?? _description,
  publishAt: publishAt ?? _publishAt,
  imageUrl: imageUrl ?? _imageUrl,
  videoUrl: videoUrl ?? _videoUrl,
  corpId: corpId ?? _corpId,
  countView: countView ?? _countView,
  countRaiseUp: countRaiseUp ?? _countRaiseUp,
  countRaiseDown: countRaiseDown ?? _countRaiseDown,
);
  int? get id => _id;
  String? get title => _title;
  String? get author => _author;
  int? get categoryId => _categoryId;
  String? get categoryCode => _categoryCode;
  String? get categoryName => _categoryName;
  String? get tags => _tags;
  String? get description => _description;
  String? get publishAt => _publishAt;
  String? get imageUrl => _imageUrl;
  String? get videoUrl => _videoUrl;
  int? get corpId => _corpId;
  int? get countView => _countView;
  int? get countRaiseUp => _countRaiseUp;
  int? get countRaiseDown => _countRaiseDown;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['author'] = _author;
    map['categoryId'] = _categoryId;
    map['categoryCode'] = _categoryCode;
    map['categoryName'] = _categoryName;
    map['tags'] = _tags;
    map['description'] = _description;
    map['publishAt'] = _publishAt;
    map['imageUrl'] = _imageUrl;
    map['videoUrl'] = _videoUrl;
    map['corpId'] = _corpId;
    map['countView'] = _countView;
    map['countRaiseUp'] = _countRaiseUp;
    map['countRaiseDown'] = _countRaiseDown;
    return map;
  }

}