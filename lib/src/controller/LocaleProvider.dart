import 'package:flutter/material.dart';
import 'package:agri_manager/src/controller/L10n.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  void setLocale(Locale locale){
    if(!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }
}