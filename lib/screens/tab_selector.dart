import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:owl/widgets/buttons/add.dart';
import 'package:owl/widgets/item.dart';
import 'package:owl/url_model.dart';
import 'package:owl/gradients.dart';

class TabSelector extends StatelessWidget {
  const TabSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: toBackgroundGradientWithReducedColorChange(owlGradient),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: FutureBuilder(
            future: loadUrls(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      return Material(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Transform.scale(scale: 1.05, child: child),
      );
    },
    child: child,
  );
}

Future<Widget> loadUrls(BuildContext context) async {
  return ScrollConfiguration(
    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
    child: Consumer<UrlModel>(
      builder: (context, urls, child) {
        List<Widget> items = [];

        int i = 0;
        for (var url in urls.list) {
          items.add(Item(key: Key("$i"), name: url, id: i));
          i++;
        }

        return Column(
          children: [
            Flexible(
              child: ReorderableListView(
                shrinkWrap: true,
                proxyDecorator: _proxyDecorator,
                children: items,
                onReorder: (int start, int current) {
                  if (start < current) {
                    int end = current - 1;
                    String startItem = urls.list[start];
                    int i = 0;
                    int local = start;

                    do {
                      urls.setInternal(local, urls.list[++local]);
                      i++;
                    } while (i < end - start);

                    urls.setInternal(end, startItem);
                    urls.notify();
                  } else if (start > current) {
                    String startItem = urls.list[start];

                    for (int i = start; i > current; i--) {
                      urls.setInternal(i, urls.list[i - 1]);
                    }

                    urls.setInternal(current, startItem);
                    urls.notify();
                  }
                },
              ),
            ),
            AddButton(id: urls.number),
          ],
        );
      },
    ),
  );
}
