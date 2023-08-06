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
    final urls = Provider.of<UrlModel>(context);

    List<String> list = currentList.map((e) => e.name).toList();
    if (listEquals(urls.list, list) == false) {
      List<ItemData> items = [];

      int i = 0;
      for (var url in urls.list) {
        items.add(
          ItemData(
            name: url,
            id: i,
            autofocus: url == "" && i == urls.number - 1,
          ),
        );
        i++;
      }

      setState(() {
        currentList = items;
      });
    }

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
          child: Stack(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.transparent,
                ),
                child: Scrollbar(
                  controller: widget.scrollController,
                  child: AutomaticAnimatedListView<ItemData>(
                    addAnimatedElevation: 0,
                    list: currentList,
                    comparator: AnimatedListDiffListComparator<ItemData>(
                        sameItem: (a, b) => a.id == b.id,
                        sameContent: (a, b) => a.name == b.name),
                    itemBuilder: (context, item, data) => data.measuring
                        ? const Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: CutoutContainer(leftHanded: true),
                          )
                        : Item(
                            name: item.name,
                            id: item.id,
                            autofocus: item.autofocus,
                          ),
                    listController: widget.controller,
                    addLongPressReorderable: true,
                    reorderModel: AnimatedListReorderModel(
                      onReorderStart: (index, dx, dy) => true,
                      onReorderMove: (index, dropIndex) => true,
                      onReorderComplete: (index, dropIndex, slot) {
                        Provider.of<UrlModel>(context)
                            .reorder(index, dropIndex);

                        return true;
                      },
                    ),
                    scrollController: widget.scrollController,
                  ),
                ),
              ),
              AddButton(
                id: Provider.of<UrlModel>(context).number,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
