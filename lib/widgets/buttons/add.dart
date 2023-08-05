import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:owl/widgets/buttons/gradient.dart';
import 'package:owl/widgets/item.dart';
import 'package:owl/url_model.dart';

class AddButton extends StatefulWidget {
  final int id;
  const AddButton({super.key, required this.id});

  @override
  AddButtonState createState() => AddButtonState();
}

class AddButtonState extends State<AddButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    if (_pressed) {
      _pressed = false;
      return Item(name: "", id: widget.id, autofocus: true);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: GradientButton(
        borderRadius: 25,
        height: 50,
        width: 80,
        onPressed: () => setState(() => _pressed = true),
        onLongPress: () {
          Provider.of<UrlModel>(context, listen: false).toggleLeftHanded();
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
