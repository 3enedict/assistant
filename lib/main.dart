import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

const defaultUrl = "http://192.168.1.2:8123";

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Owl',
      theme: ThemeData.dark(useMaterial3: true),
      home: const Assistant(),
    ),
  );
}

class Assistant extends StatefulWidget {
  const Assistant({super.key});

  @override
  AssistantState createState() => AssistantState();
}

class AssistantState extends State<Assistant> {
  late final WebViewController controller;
  final List<String> _urls = [];

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
                      if (value.dy == 0 &&
                          movement.direction < 1 &&
                          movement.distance > 1) {
                        Navigator.push(
                          context,
                          SlideRightRoute(page: const TabSelector()),
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

class TabSelector extends StatelessWidget {
  const TabSelector({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
