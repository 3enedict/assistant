import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:owl/widgets/buttons/gradient.dart';
import 'package:owl/widgets/item.dart';
import 'package:owl/url_model.dart';

class AddButton extends StatefulWidget {
  final int id;
  final VoidCallback onPressed;

  const AddButton({
    super.key,
    required this.id,
    required this.onPressed,
  });

  @override
  AddButtonState createState() => AddButtonState();
}

class AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: GradientButton(
        borderRadius: 25,
        height: 50,
        width: 80,
        onPressed: () {
          Provider.of<UrlModel>(context, listen: false).add();
          widget.onPressed();
        },
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
