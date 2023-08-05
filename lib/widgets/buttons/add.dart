import 'package:flutter/material.dart';

import 'package:owl/widgets/buttons/gradient.dart';
import 'package:owl/widgets/item.dart';

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
      return Item(name: "", id: widget.id, autofocus: true);
    }

    final double padding = (MediaQuery.of(context).size.width / 2) - 50;

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 25, padding, 0),
      child: GradientButton(
        diameter: 50,
        onPressed: () => setState(() => _pressed = true),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
