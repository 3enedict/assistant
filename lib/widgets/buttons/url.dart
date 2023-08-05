import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:owl/widgets/buttons/gradient.dart';
import 'package:owl/url_model.dart';

class UrlButton extends StatelessWidget {
  final String name;
  final int id;

  const UrlButton({super.key, required this.name, required this.id});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width - 40 - 66 + 6,
        6,
        0,
        0,
      ),
      child: GradientButton(
        borderRadius: 23,
        height: 46,
        width: 46,
        padding: const EdgeInsets.all(0),
        onPressed: () {
          Provider.of<UrlModel>(context, listen: false).set(id, name);
          Navigator.of(context).pop();
        },
        child: const Icon(
          Icons.link,
          color: Colors.black,
        ),
      ),
    );
  }
}
