import 'package:flutter/material.dart';

import 'package:owl/add_button.dart';
import 'package:provider/provider.dart';

import 'package:owl/gradient_button.dart';
import 'package:owl/gradients.dart';
import 'package:owl/url_model.dart';
import 'package:owl/item.dart';

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
          child: Column(
            children: [
              Expanded(
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

Future<Widget> loadUrls(BuildContext context) async {
  return ScrollConfiguration(
    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
          sliver: Consumer<UrlModel>(
            builder: (context, urls, child) {
              List<Widget> items = [];

              int i = 0;
              for (var url in urls.list) {
                items.add(Item(name: url, id: i));
                i++;
              }

              items.add(AddButton(id: i));

              return SliverList.list(children: items);
            },
          ),
        ),
      ],
    ),
  );
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
