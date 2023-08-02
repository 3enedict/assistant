import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

const defaultUrl = "https://www.google.com";

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Assistant',
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

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    SharedPreferences.getInstance().then(
      (instance) {
        final url = instance.getString("url");
        controller.loadRequest(Uri.parse(url ?? defaultUrl));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => const SelectionScreen(),
          ),
        )
            .then(
          (newUrl) {
            setState(() => controller.loadRequest(Uri.parse(newUrl)));
            SharedPreferences.getInstance().then(
              (instance) => instance.setString("url", newUrl),
            );
          },
        ),
        child: const Icon(Icons.link),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextField(
            autofocus: true,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              hintText: "https://www.google.com",
              border: InputBorder.none,
            ),
            expands: false,
            onSubmitted: (url) => Navigator.of(context).pop(url),
          ),
        ),
      ),
    );
  }
}
