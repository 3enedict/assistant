import 'package:flutter/material.dart';

import 'package:owl/gradients.dart';
import 'package:owl/url_model.dart';
import 'package:provider/provider.dart';

class Item extends StatelessWidget {
  final String name;
  final int id;

  const Item({
    super.key,
    required this.name,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          gradient: LinearGradient(colors: toSurfaceGradient(owlGradient)),
        ),
        height: 70,
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
                    keyboardType: TextInputType.url,
                    controller: TextEditingController(text: name),
                    decoration: const InputDecoration(border: InputBorder.none),
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
