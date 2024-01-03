import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hofu/constants.dart';


class Hofu extends ChangeNotifier {
  Hofu(this._pref, this._content);

  final SharedPreferences _pref;
  String _content;

  String get content => _content;

  void updateContent(String content) {
    _content = content;
    notifyListeners();
  }

  void save() {
    _pref.setString(LocalStorageKey.hofuContent, _content);
    notifyListeners();
  }
}
