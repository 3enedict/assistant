import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

import 'package:owl/tab_selector.dart';
import 'package:owl/url_model.dart';

const defaultUrl = "http://192.168.1.2:8123";

void main() {
  Paint.enableDithering = true;

  runApp(
    ChangeNotifierProvider(
      create: (context) => UrlModel(),
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
  bool _loaded = false;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      var model = Provider.of<UrlModel>(context, listen: false);
      model.load().then((x) => setState(() => _loaded = true));
      return Container();
    }

    return Scaffold(
      body: SafeArea(
        child: Consumer<UrlModel>(
          builder: (context, urls, child) {
            String url = urls.current;
            if (url != "" && Uri.tryParse(url) != null) {
              controller.loadRequest(Uri.parse(url));
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
