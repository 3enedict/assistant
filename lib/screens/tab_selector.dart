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

Future<Widget> loadUrls(BuildContext context) async {
  return ScrollConfiguration(
    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
    child: CustomScrollView(
      key: const PageStorageKey("Tab Selector"),
      controller: ScrollController(initialScrollOffset: 200),
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            0,
            200,
            0,
            MediaQuery.of(context).size.height - 92.5,
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
