import 'package:flutter/material.dart';
import 'package:owl/widgets/custom_textfield.dart';

import 'package:provider/provider.dart';

import 'package:owl/widgets/cutout_container.dart';
import 'package:owl/widgets/buttons/url.dart';
import 'package:owl/url_model.dart';

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

class ItemState extends State<Item> {
  bool _alreadyRemoved = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerMove: (details) {
          double x = details.delta.dx;
          double y = details.delta.dy;

          if (x > 10 || x < -10 && y < 2 && y > -2 && !_alreadyRemoved) {
            setState(() => _alreadyRemoved = true);
            Provider.of<UrlModel>(context, listen: false).remove(widget.id);
          }
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
