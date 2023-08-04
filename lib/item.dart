import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:owl/gradient_button.dart';
import 'package:owl/gradients.dart';

class Item extends StatelessWidget {
  final String name;

  const Item({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: GradientButton(
        borderRadius: 30,
        height: 60,
        padding: const EdgeInsets.all(0),
        gradient: toSurfaceGradient(owlGradient),
        onPressed: () => Navigator.of(context).pop(),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(colors: owlGradient),
              ),
              margin: const EdgeInsets.fromLTRB(18, 0, 11, 0),
              height: 24,
              width: 24,
            ),
            Text(
              name,
              style: GoogleFonts.workSans(
                textStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
