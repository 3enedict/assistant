import 'package:flutter/material.dart';
import 'package:owl/widgets/custom_textfield.dart';

import 'package:provider/provider.dart';

import 'package:owl/widgets/cutout_container.dart';
import 'package:owl/widgets/buttons/url.dart';
import 'package:owl/url_model.dart';

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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
    );
  }
}
