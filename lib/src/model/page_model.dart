import 'dart:convert';

class PageModel {

  PageModel({
    int? page = 0, int? size= 60}){
    _page = page;
    _size = size;
  }

  int? get page => _page;

  set page(int? value) {
    _page = value;
  }

  int? _page;
  int? _size;

  int? get size => _size;

  set size(int? value) {
    _size = value;
  }
}