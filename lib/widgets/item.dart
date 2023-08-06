import 'package:flutter/material.dart';
import 'package:owl/widgets/custom_textfield.dart';

import 'package:provider/provider.dart';

import 'package:owl/widgets/cutout_container.dart';
import 'package:owl/widgets/buttons/url.dart';
import 'package:owl/url_model.dart';

class ItemData {
  final String name;
  final int id;
  final bool autofocus;

  const ItemData({
    required this.name,
    required this.id,
    this.autofocus = false,
  });
}

class Item extends StatefulWidget {
  final String name;
  final int id;
  final bool autofocus;

  const Item({
    super.key,
    required this.name,
    required this.id,
    this.autofocus = false,
  });

  @override
  ItemState createState() => ItemState();
}

class ItemState extends State<Item> with SingleTickerProviderStateMixin {
  bool _removed = false;

  @override
  Widget build(BuildContext context) {
    if (_removed) return const SizedBox(height: 86);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Dismissible(
        key: UniqueKey(),
        resizeDuration: null,
        onDismissed: (direction) {
          setState(() => _removed = true);
          Provider.of<UrlModel>(context, listen: false).remove(widget.id);
        },
        child: Consumer<UrlModel>(
          builder: (context, urls, child) {
            return Stack(
              children: [
                CutoutContainer(
                  leftHanded: urls.isleftHanded,
                ),
                CustomTextfield(
                  name: widget.name,
                  id: widget.id,
                  autofocus: widget.autofocus,
                  leftHanded: urls.isleftHanded,
                ),
                UrlButton(
                  name: widget.name,
                  id: widget.id,
                  leftHanded: urls.isleftHanded,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
