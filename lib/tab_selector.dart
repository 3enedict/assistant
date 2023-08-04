import 'package:flutter/material.dart';

import 'package:owl/gradient_button.dart';
import 'package:owl/gradients.dart';
import 'package:owl/item.dart';

class TabSelector extends StatefulWidget {
  final List<String> urls;
  const TabSelector({super.key, required this.urls});

  @override
  TabSelectorState createState() => TabSelectorState();
}

class TabSelectorState extends State<TabSelector> {
  final List<String>? _urls = null;

  @override
  Widget build(BuildContext context) {
    final urls = _urls ?? widget.urls;

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
          child: Column(
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: CustomScrollView(
                    key: const PageStorageKey("Tab Selector"),
                    slivers: <Widget>[
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          0,
                          0,
                          0,
                          MediaQuery.of(context).size.height - 70,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Item(name: urls[index]);
                            },
                            childCount: urls.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: GradientBackButton(),
              ),
            ],
          ),
        ),
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
