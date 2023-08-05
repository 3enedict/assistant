import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:owl/gradients.dart';
import 'package:owl/url_model.dart';

class CustomTextfield extends StatelessWidget {
  final String name;
  final int id;
  final bool autofocus;

  const CustomTextfield({
    super.key,
    required this.name,
    required this.id,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: const LinearGradient(colors: owlGradient),
            ),
            margin: const EdgeInsets.fromLTRB(20, 0, 12, 0),
            height: 26,
            width: 26,
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(border: InputBorder.none),
              controller: TextEditingController(text: name),
              keyboardType: TextInputType.url,
              autofocus: autofocus,
              expands: false,
              onSubmitted: (url) =>
                  Provider.of<UrlModel>(context, listen: false).set(id, url),
            ),
          ),
          const SizedBox(width: 66 + 10),
        ],
      ),
    );
  }
}
