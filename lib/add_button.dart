import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:owl/gradient_button.dart';
import 'package:owl/item.dart';

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

    return Padding(
      padding: const EdgeInsets.fromLTRB(60, 25, 60, 0),
      child: GradientButton(
        borderRadius: 23,
        height: 46,
        onPressed: () => setState(() => _pressed = true),
        child: Text(
          "Add",
          style: GoogleFonts.workSans(
            fontSize: 14 * MediaQuery.of(context).textScaleFactor * 1.1,
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
