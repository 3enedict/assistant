import 'package:flutter/material.dart';

import 'package:owl/gradients.dart';
import 'package:owl/url_model.dart';
import 'package:provider/provider.dart';

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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(33),
          gradient: LinearGradient(colors: toSurfaceGradient(owlGradient)),
        ),
        height: 66,
        child: Consumer<UrlModel>(
          builder: (context, urls, child) {
            return Row(
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
                    onSubmitted: (url) => urls.set(id, url),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
