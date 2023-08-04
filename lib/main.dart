import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:owl/tab_selector.dart';

const defaultUrl = "http://192.168.1.2:8123";

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Owl',
      theme: ThemeData.dark(useMaterial3: true),
      home: const Owl(),
    ),
  );
}

class Owl extends StatefulWidget {
  const Owl({super.key});

  @override
  OwlState createState() => OwlState();
}

class OwlState extends State<Owl> {
  late final WebViewController controller;
  final List<String> _urls = [defaultUrl];

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    SharedPreferences.getInstance().then(
      (instance) {
        setState(() {
          var url = instance.getString("url");
          controller.loadRequest(Uri.parse(url ?? defaultUrl));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
          controller: controller,
          gestureRecognizers: {
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()
                ..onDown = (DragDownDetails dragDownDetails) {
                  controller.getScrollPosition().then(
                    (value) {
                      var movement = dragDownDetails.globalPosition;
                      if (value.dy == 0 && movement.direction < 1) {
                        Navigator.push(
                          context,
                          SlideRightRoute(
                            page: TabSelector(urls: _urls),
                          ),
                        );
                      }
                    },
                  );
                },
            ),
          },
        ),
      ),
    );
  }
}
