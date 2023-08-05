import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

import 'package:owl/screens/tab_selector.dart';
import 'package:owl/widgets/slide_route.dart';
import 'package:owl/url_model.dart';

class Browser extends StatefulWidget {
  const Browser({super.key});

  @override
  BrowserState createState() => BrowserState();
}

class BrowserState extends State<Browser> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<UrlModel>(
          builder: (context, urls, child) {
            if (!urls.hasLoaded) return Container();
            if (!urlIsValid(urls)) return const TabSelector();

            controller.loadRequest(Uri.parse(urls.current));
            return child ?? Container();
          },
          child: WebViewWidget(
            controller: controller,
            gestureRecognizers: {
              Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer()
                  ..onDown = (DragDownDetails dragDownDetails) {
                    controller.getScrollPosition().then(
                      (value) {
                        var movement = dragDownDetails.globalPosition;
                        if (value.dy == 0 && movement.dy > 100) {
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
      ),
    );
  }
}

bool urlIsValid(UrlModel urls) {
  if (urls.isEmpty) return false;

  String url = urls.current;
  if (url != "" && Uri.tryParse(url) != null) return true;

  return false;
}
