import 'package:flutter/material.dart';

import 'package:owl/gradients.dart';

class CutoutContainer extends StatelessWidget {
  const CutoutContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bound) {
        return LinearGradient(colors: toSurfaceGradient(owlGradient))
            .createShader(bound);
      },
      blendMode: BlendMode.srcIn,
      child: CustomPaint(
        painter: HolePainter(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(33),
          ),
          height: 66,
        ),
      ),
    );
  }
}

class HolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.black87;
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addRRect(RRect.fromLTRBR(
            size.width,
            size.height,
            0,
            0,
            Radius.circular(size.height / 2),
          )),
        Path()
          ..addOval(Rect.fromCircle(
            center: Offset(size.width - (size.height / 2), size.height / 2),
            radius: size.height / 2 - 4,
          ))
          ..close(),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
