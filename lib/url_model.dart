import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UrlModel extends ChangeNotifier {
  List<String> _urls = [];
  int _enabled = 0;

  Future<void> load() async {
    var instance = await SharedPreferences.getInstance();

    _urls = instance.getStringList("urls") ?? [];
  }

  void set(int index, String url) {
    if (index > _urls.length - 1) _urls.add("");
    _urls[index] = url;
    _enabled = index;

    print(_urls);

    SharedPreferences.getInstance().then(
      (instance) => instance.setStringList("urls", _urls),
    );

    notifyListeners();
  }

  String url(int index) => _urls.elementAtOrNull(index) ?? "";

  int get enabled => _enabled;

  int get number => _urls.length;
}
