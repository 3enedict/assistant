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

class Item extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerMove: (details) {
          double x = details.delta.dx;
          double y = details.delta.dy;

          if ((x > 10 || x < -10) && y < 0.1 && y > -0.1) {
            Provider.of<UrlModel>(context, listen: false).remove(id);
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
                  name: name,
                  id: id,
                  autofocus: autofocus,
                  leftHanded: urls.isleftHanded,
                ),
                UrlButton(
                  name: name,
                  id: id,
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
