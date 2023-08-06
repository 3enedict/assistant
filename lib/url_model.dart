import 'package:flutter/material.dart';
import 'package:owl/widgets/item.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ScaleClipper extends CustomClipper<Rect> {
  double value;

  ScaleClipper({required this.value});

  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height - value);
    return rect;
  }

  @override
  bool shouldReclip(ScaleClipper oldClipper) {
    return true;
  }
}

class UrlModel extends ChangeNotifier {
  bool _hasLoaded = false;
  List<String> _urls = [];
  List<Widget> _items = [];
  int _enabled = 0;

  //This doesn't really have much to do with urls changes how the ui looks
  bool _leftHanded = true;

  Future<void> load() async {
    SharedPreferences.getInstance().then(
      (instance) {
        _urls = instance.getStringList("urls") ?? [];
        updateItems();

        _hasLoaded = true;

        _leftHanded = instance.getBool("leftHanded") ?? true;

        notifyListeners();
      },
    );
  }

  void updateItems() {
    List<Widget> items = [];

    int i = 0;
    for (var url in _urls) {
      items.add(Item(key: Key("$i"), name: url, id: i));
      i++;
    }

    _items = items;
  }

  void add() {
    _items.add(
      TweenAnimationBuilder(
        key: Key("${_urls.length}"),
        duration: const Duration(milliseconds: 300),
        tween: Tween<double>(begin: 1, end: 0),
        builder: (BuildContext context, double value, Widget? child) {
          return ClipRect(
            clipper: ScaleClipper(value: value * 86),
            child: child,
          );
        },
        child: Item(
          name: "",
          id: _urls.length,
          autofocus: true,
        ),
      ),
    );

    _urls.add("");
    notify();
  }

  List<Widget> get items => _items;

  void set(int index, String url) {
    setInternal(index, url);
    notify();
  }

  void remove(int index) {
    _urls.removeAt(index);
    updateItems();

    _enabled = _enabled - 1;
    if (_enabled < 0) _enabled = 0;

    notify();
  }

  void setInternal(int index, String url) {
    if (index > _urls.length - 1) _urls.add("");
    _urls[index] = url;
    updateItems();

    _enabled = index;
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

  void setEnabled(int id) {
    _enabled = id;
    notifyListeners();
  }

  bool get isleftHanded => _leftHanded;
  void toggleLeftHanded() {
    _leftHanded = !_leftHanded;
    SharedPreferences.getInstance().then(
      (instance) => instance.setBool("leftHanded", _leftHanded),
    );

    notifyListeners();
  }
}
