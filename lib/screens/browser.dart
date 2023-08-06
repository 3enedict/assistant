import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

import 'package:owl/screens/tab_selector.dart';
import 'package:owl/widgets/slide_route.dart';
import 'package:owl/url_model.dart';
import 'package:owl/gradients.dart';

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
            if (!urls.hasLoaded || !urlIsValid(urls) || child == null) {
              return Listener(
                behavior: HitTestBehavior.translucent,
                onPointerMove: (details) {
                  controller.getScrollPosition().then(
                    (value) {
                      double x = details.delta.dx;
                      double y = details.delta.dy;

                      if (value.dy == 0 && y > 20 && x < 2 && x > -2) {
                        Navigator.push(
                          context,
                          SlideRightRoute(page: const TabSelector()),
                        );
                      }
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: toBackgroundGradientWithReducedColorChange(
                          owlGradient),
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              );
            }

            controller.currentUrl().then(
              (controllerUrl) {
                if ((controllerUrl ?? "") != urls.current) {
                  controller.loadRequest(Uri.parse(urls.current));
                }
              },
            );

            return child;
          },
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerMove: (details) {
              controller.getScrollPosition().then(
                (value) {
                  double x = details.delta.dx;
                  double y = details.delta.dy;

                  if (value.dy == 0 && y > 20 && x < 2 && x > -2) {
                    Navigator.push(
                      context,
                      SlideRightRoute(page: const TabSelector()),
                    );
                  }
                },
              );
            },
            child: WebViewWidget(controller: controller),
          ),
        ),
      ),
    );
  }
}

bool urlIsValid(UrlModel urls) {
  if (urls.isEmpty) return false;

  String url = urls.current;
  if (url != "" && Uri.parse(url).isAbsolute) return true;

  return false;
}
