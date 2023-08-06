import 'package:flutter/material.dart';

import 'package:wakelock/wakelock.dart';
import 'package:provider/provider.dart';

import 'package:owl/screens/browser.dart';
import 'package:owl/url_model.dart';

void main() {
  Paint.enableDithering = true;
  Wakelock.enable();

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
        home: const Browser(),
      ),
    ),
  );
}
