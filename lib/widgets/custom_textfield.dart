import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:owl/url_model.dart';

class CustomTextfield extends StatelessWidget {
  final String name;
  final int id;
  final bool autofocus;
  final bool leftHanded;

  const CustomTextfield({
    super.key,
    required this.name,
    required this.id,
    this.autofocus = false,
    required this.leftHanded,
  });

  @override
  Widget build(BuildContext context) {
    final textfield = Expanded(
      child: TextField(
        decoration: const InputDecoration(border: InputBorder.none),
        controller: TextEditingController(text: name),
        keyboardType: TextInputType.url,
        autofocus: autofocus,
        expands: false,
        onSubmitted: (url) =>
            Provider.of<UrlModel>(context, listen: false).set(id, url),
      ),
    );

    final leftConfiguration = [
      const SizedBox(width: 66 + 10),
      textfield,
      const SizedBox(width: 10),
      const Icon(
        FontAwesomeIcons.gripVertical,
        color: Colors.white70,
      ),
      const SizedBox(width: 25),
    ];

    final rightConfiguration = [
      const SizedBox(width: 25),
      const Icon(
        FontAwesomeIcons.gripVertical,
        color: Colors.white70,
      ),
      const SizedBox(width: 10),
      textfield,
      const SizedBox(width: 66 + 10),
    ];

    return SizedBox(
      height: 66,
      child: Row(
        children: leftHanded ? leftConfiguration : rightConfiguration,
      ),
    );
  }
}
