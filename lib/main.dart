import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

import 'package:owl/tab_selector.dart';
import 'package:owl/url_model.dart';

void main() {
  Paint.enableDithering = true;

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        var model = UrlModel();
        model.load();
        return model;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Owl',
        theme: ThemeData.dark(useMaterial3: true),
        home: const Owl(),
      ),
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
            if (urls.isEmpty) return const TabSelector();

            String url = urls.current;
            if (url != "" && Uri.tryParse(url) != null) {
              controller.loadRequest(Uri.parse(url));
            } else {
              return const TabSelector();
            }

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
                        if (value.dy == 0 &&
                            movement.direction < 1 &&
                            movement.dy > 100) {
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
