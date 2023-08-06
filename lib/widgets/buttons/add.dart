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

class AddButtonState extends State<AddButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(widget.id * 86, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

    return Align(
      alignment: Alignment.topCenter,
      child: SlideTransition(
        position: offsetAnimation,
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: GradientButton(
            borderRadius: 25,
            height: 50,
            width: 80,
            onPressed: () {
              Provider.of<UrlModel>(context, listen: false).set(widget.id, "");
            },
            onLongPress: () {
              Provider.of<UrlModel>(context, listen: false).toggleLeftHanded();
            },
            child: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
