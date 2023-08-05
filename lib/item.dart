import 'package:flutter/material.dart';
import 'package:owl/gradient_button.dart';

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
      child: Consumer<UrlModel>(
        builder: (context, urls, child) {
          return Stack(
            children: [
              ShaderMask(
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
              ),
              SizedBox(
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
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: TextEditingController(text: name),
                        keyboardType: TextInputType.url,
                        autofocus: autofocus,
                        expands: false,
                        onSubmitted: (url) => urls.set(id, url),
                      ),
                    ),
                    const SizedBox(width: 66 + 10),
                  ],
                ),
              ),
              Padding(
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
                    urls.set(id, name);
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.link,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          );
        },
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
