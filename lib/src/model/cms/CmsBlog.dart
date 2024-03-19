import 'dart:convert';

import 'package:agri_manager/src/model/cms/CmsCategory.dart';
/// id : 10
/// title : ""
/// status : 1
/// checkStatus : 1
/// author : ""
/// categoryId : 6
/// createdAt : ""
/// updatedAt : ""
/// tags : ""
/// description : ""
/// createdUserId : 5
/// content : ""
/// publishAt : ""
/// imageUrl : ""
/// videoUrl : ""
/// corpId : 3
/// category : {}

CmsBlog cmsBlogFromJson(String str) => CmsBlog.fromJson(json.decode(str));
String cmsBlogToJson(CmsBlog data) => json.encode(data.toJson());
class CmsBlog {
  CmsBlog({
      num? id, 
      String? title, 
      num? status, 
      num? checkStatus, 
      String? author, 
      num? categoryId, 
      String? createdAt, 
      String? updatedAt, 
      String? tags, 
      String? description, 
      num? createdUserId, 
      String? content, 
      String? publishAt, 
      String? imageUrl, 
      String? videoUrl, 
      num? corpId, 
      CmsCategory? category,
    num? countView,
    num? countRaiseUp,
    num? countRaiseDown,}){
    _id = id;
    _title = title;
    _status = status;
    _checkStatus = checkStatus;
    _author = author;
    _categoryId = categoryId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _tags = tags;
    _description = description;
    _createdUserId = createdUserId;
    _content = content;
    _publishAt = publishAt;
    _imageUrl = imageUrl;
    _videoUrl = videoUrl;
    _corpId = corpId;
    _category = category;
    _countView = countView;
    _countRaiseDown = countRaiseDown;
    _countRaiseUp = countRaiseUp;
}

  CmsBlog.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _status = json['status'];
    _checkStatus = json['checkStatus'];
    _author = json['author'];
    _categoryId = json['categoryId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _tags = json['tags'];
    _description = json['description'];
    _createdUserId = json['createdUserId'];
    _content = json['content'];
    _publishAt = json['publishAt'];
    _imageUrl = json['imageUrl'];
    _videoUrl = json['videoUrl'];
    _corpId = json['corpId'];
    _category =  null != json['category'] ? CmsCategory.fromJson(json['category']) : null;

    _countView = json['countView'];
    _countRaiseDown = json['countRaiseDown'];
    _countRaiseUp = json['countRaiseUp'];
  }
  num? _id;
  String? _title;
  num? _status;
  num? _checkStatus;
  String? _author;
  num? _categoryId;
  String? _createdAt;
  String? _updatedAt;
  String? _tags;
  String? _description;
  num? _createdUserId;
  String? _content;
  String? _publishAt;
  String? _imageUrl;
  String? _videoUrl;
  num? _corpId;
  CmsCategory? _category;

  num? _countView;
  num? _countRaiseUp;
  num? _countRaiseDown;

CmsBlog copyWith({  num? id,
  String? title,
  num? status,
  num? checkStatus,
  String? author,
  num? categoryId,
  String? createdAt,
  String? updatedAt,
  String? tags,
  String? description,
  num? createdUserId,
  String? content,
  String? publishAt,
  String? imageUrl,
  String? videoUrl,
  num? corpId,
  CmsCategory? category,
  num? countView,
  num? countRaiseUp,
  num? countRaiseDown,
}) => CmsBlog(  id: id ?? _id,
  title: title ?? _title,
  status: status ?? _status,
  checkStatus: checkStatus ?? _checkStatus,
  author: author ?? _author,
  categoryId: categoryId ?? _categoryId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  tags: tags ?? _tags,
  description: description ?? _description,
  createdUserId: createdUserId ?? _createdUserId,
  content: content ?? _content,
  publishAt: publishAt ?? _publishAt,
  imageUrl: imageUrl ?? _imageUrl,
  videoUrl: videoUrl ?? _videoUrl,
  corpId: corpId ?? _corpId,
  category: category ?? _category,
  countView: countView ?? _countView,
  countRaiseUp: countRaiseUp ?? _countRaiseUp,
    countRaiseDown: countRaiseDown ?? _countRaiseDown,
);
  num? get id => _id;
  String? get title => _title;
  num? get status => _status;
  num? get checkStatus => _checkStatus;
  String? get author => _author;
  num? get categoryId => _categoryId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get tags => _tags;
  String? get description => _description;
  num? get createdUserId => _createdUserId;
  String? get content => _content;
  String? get publishAt => _publishAt;
  String? get imageUrl => _imageUrl;
  String? get videoUrl => _videoUrl;
  num? get corpId => _corpId;
  CmsCategory? get category => _category;


  num? get countView => _countView;
  num? get countRaiseUp => _countRaiseUp;
  num? get countRaiseDown => _countRaiseDown;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['status'] = _status;
    map['checkStatus'] = _checkStatus;
    map['author'] = _author;
    map['categoryId'] = _categoryId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['tags'] = _tags;
    map['description'] = _description;
    map['createdUserId'] = _createdUserId;
    map['content'] = _content;
    map['publishAt'] = _publishAt;
    map['imageUrl'] = _imageUrl;
    map['videoUrl'] = _videoUrl;
    map['corpId'] = _corpId;
    map['category'] = null != _category? _category!.toJson() : null;
    map['countRaiseUp'] =_countRaiseUp;
    map['countView'] = _countView;
    map['countRaiseDown'] =_countRaiseDown;
    return map;
  }

  set category(CmsCategory? value) {
    _category = value;
  }

  set corpId(num? value) {
    _corpId = value;
  }

  set videoUrl(String? value) {
    _videoUrl = value;
  }

  set imageUrl(String? value) {
    _imageUrl = value;
  }

  set publishAt(String? value) {
    _publishAt = value;
  }

  set content(String? value) {
    _content = value;
  }

  set createdUserId(num? value) {
    _createdUserId = value;
  }

  set description(String? value) {
    _description = value;
  }

  set tags(String? value) {
    _tags = value;
  }

  set updatedAt(String? value) {
    _updatedAt = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set categoryId(num? value) {
    _categoryId = value;
  }

  set author(String? value) {
    _author = value;
  }

  set checkStatus(num? value) {
    _checkStatus = value;
  }

  set status(num? value) {
    _status = value;
  }

  set title(String? value) {
    _title = value;
  }

  set id(num? value) {
    _id = value;
  }

  set countRaiseDown(num? value) {
    _countRaiseDown = value;
  }

  set countRaiseUp(num? value) {
    _countRaiseUp = value;
  }

  set countView(num? value) {
    _countView = value;
  }
}