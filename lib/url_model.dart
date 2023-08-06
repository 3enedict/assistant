import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UrlModel extends ChangeNotifier {
  bool _hasLoaded = false;
  List<String> _urls = [];
  int _enabled = 0;

  //This doesn't really have much to do with urls but changes how the ui looks
  bool _leftHanded = true;

  Future<void> load() async {
    SharedPreferences.getInstance().then(
      (instance) {
        _urls = instance.getStringList("urls") ?? [];
        _leftHanded = instance.getBool("leftHanded") ?? true;
        _hasLoaded = true;

        notifyListeners();
      },
    );
  }

  void reorder(int index, int dropIndex) {
    _urls.insert(dropIndex, _urls.removeAt(index));

    notify();
  }

  void set(int index, String url) {
    if (index > _urls.length - 1) _urls.add("");
    _urls[index] = url;
    _enabled = index;

    notify();
  }

  void remove(int index) {
    _urls.removeAt(index);
    _enabled = 0;

    notify();
  }

  List<String> get list => List.from(_urls);
  String get current => _urls.elementAtOrNull(_enabled) ?? "";
  int get enabled => _enabled;
  int get number => _urls.length;
  bool get isEmpty => _urls.isEmpty;
  bool get hasLoaded => _hasLoaded;

  bool get isleftHanded => _leftHanded;
  void toggleLeftHanded() {
    _leftHanded = !_leftHanded;

    notify();
  }

  void notify() {
    SharedPreferences.getInstance().then(
      (instance) {
        instance.setStringList("urls", _urls);
        instance.setBool("leftHanded", _leftHanded);
      },
    );

    notifyListeners();
  }
}
