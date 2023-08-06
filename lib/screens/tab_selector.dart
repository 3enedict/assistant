import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:owl/widgets/buttons/add.dart';
import 'package:owl/url_model.dart';
import 'package:owl/gradients.dart';

class TabSelector extends StatelessWidget {
  const TabSelector({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = ScrollController();

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
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerMove: (details) {
              var pos = controller.position;
              double x = details.delta.dx;
              double y = details.delta.dy;

              if (pos.atEdge &&
                  pos.pixels == pos.maxScrollExtent &&
                  y < -20 &&
                  x < 2 &&
                  x > -2) {
                Navigator.of(context).pop();
              }
            },
            child: FutureBuilder(
              future: loadUrls(context, controller),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                }

                return const SizedBox();
              },
            ),
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

Future<Widget> loadUrls(
  BuildContext context,
  ScrollController controller,
) async {
  return ScrollConfiguration(
    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
    child: Consumer<UrlModel>(
      builder: (context, urls, child) {
        return Stack(
          children: [
            Column(
              children: [
                Flexible(
                  child: ReorderableListView(
                    shrinkWrap: true,
                    proxyDecorator: _proxyDecorator,
                    scrollController: controller,
                    children: urls.items,
                    onReorder: (int start, int current) {
                      final enabledName = urls.list[urls.enabled];

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
                      } else if (start > current) {
                        String startItem = urls.list[start];

                        for (int i = start; i > current; i--) {
                          urls.setInternal(i, urls.list[i - 1]);
                        }

                        urls.setInternal(current, startItem);
                      }

                      urls.setEnabled(urls.list.indexOf(enabledName));
                      urls.notify();
                    },
                  ),
                ),
                AddButton(
                  id: urls.number,
                  onPressed: () =>
                      controller.jumpTo(controller.position.maxScrollExtent),
                ),
                const SizedBox(height: 60),
              ],
            ),
            const Column(
              children: [
                Expanded(child: SizedBox()),
                Center(
                  child: Icon(
                    Icons.expand_more,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
              ],
            )
          ],
        );
      },
    ),
  );
}
