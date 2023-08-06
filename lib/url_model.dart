import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UrlModel extends ChangeNotifier {
  bool _hasLoaded = false;
  List<String> _urls = [];
  int _enabled = 0;

  //This doesn't really have much to do with urls changes how the ui looks
  bool _leftHanded = true;
  bool _rebuildListView = true;

  Future<void> load() async {
    SharedPreferences.getInstance().then(
      (instance) {
        _urls = instance.getStringList("urls") ?? [];
        _hasLoaded = true;

        _leftHanded = instance.getBool("leftHanded") ?? true;

        notifyListeners();
      },
    );
  }

  void reorder(int index, int dropIndex) {
    _urls.insert(dropIndex, _urls.removeAt(index));
    notify();
  }

  void set(int index, String url) {
    setInternal(index, url);
    notify();
  }

  void remove(int index) {
    removeInternal(index);
    notify();
  }

  void setInternal(int index, String url) {
    if (index > _urls.length - 1) _urls.add("");
    _urls[index] = url;
    _enabled = index;
  }

  void removeInternal(int index) {
    _urls.removeAt(index);
    _enabled = 0;
  }

  void notify() {
    SharedPreferences.getInstance().then(
      (instance) => instance.setStringList("urls", _urls),
    );

    notifyListeners();
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
    SharedPreferences.getInstance().then(
      (instance) => instance.setBool("leftHanded", _leftHanded),
    );

    notifyListeners();
  }

  bool get listViewNeedsRebuilding => _rebuildListView;
  void listViewRebuilt() => _rebuildListView = false;
  void rebuildListView() {
    _rebuildListView = true;
    notify();
  }
}
