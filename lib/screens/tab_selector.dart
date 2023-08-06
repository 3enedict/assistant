import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:great_list_view/great_list_view.dart';
import 'package:owl/widgets/cutout_container.dart';
import 'package:provider/provider.dart';

import 'package:owl/widgets/buttons/add.dart';
import 'package:owl/widgets/item.dart';
import 'package:owl/url_model.dart';
import 'package:owl/gradients.dart';

class TabSelector extends StatefulWidget {
  final scrollController = ScrollController();
  final controller = AnimatedListController();

  TabSelector({super.key});

  @override
  TabSelectorState createState() => TabSelectorState();
}

class TabSelectorState extends State<TabSelector> {
  List<ItemData> currentList = [];

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
              Consumer<UrlModel>(
                builder: (context, urls, child) {
                  List<String> list = currentList.map((e) => e.name).toList();
                  if (listEquals(urls.list, list) == false) {
                    List<ItemData> items = [];

                    int i = 0;
                    for (var url in urls.list) {
                      items.add(ItemData(name: url, id: i));
                      i++;
                    }

                    Future.delayed(Duration.zero, () async {
                      setState(() {
                        currentList = items;
                      });
                    });
                  }

                  return child ?? Container();
                },
                child: Scrollbar(
                  controller: widget.scrollController,
                  child: AutomaticAnimatedListView<ItemData>(
                    shrinkWrap: true,
                    list: currentList,
                    comparator: AnimatedListDiffListComparator<ItemData>(
                        sameItem: (a, b) => a.id == b.id,
                        sameContent: (a, b) => a.name == b.name),
                    itemBuilder: (context, item, data) => data.measuring
                        ? Container(
                            margin: const EdgeInsets.all(5), height: 100)
                        : Item(name: item.name, id: item.id),
                    listController: widget.controller,
                    addLongPressReorderable: true,
                    reorderModel:
                        AutomaticAnimatedListReorderModel(currentList),
                    scrollController: widget.scrollController,
                  ),
                ),
              ),
              AddButton(
                id: Provider.of<UrlModel>(context, listen: false).number,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
