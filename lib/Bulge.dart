import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';

typedef void VoidCallback();

class Bulge extends StatefulWidget {
  final VoidCallback onPressed;
  Bulge({Key key, @required this.onPressed}) : super(key: key);
  _Bulge createState() => _Bulge();
}

class _Bulge extends State<Bulge> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  int _animationDuration = 100;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: _animationDuration))
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) animationController.reverse();
      })
      ..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceInOut,
    ));
  }

  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: animation,
        alignment: Alignment.center,
        child: IconButton(
          iconSize: 65,
          color: AppThemes.highlightColor,
          hoverColor: AppThemes.buttonColor,
          icon: Icon(Icons.add_circle_outline),
          onPressed: () async {
            // animate bulge
            animationController.forward();
            // wait for bulge to end
            await Future.delayed(
                Duration(milliseconds: _animationDuration * 2));
            // close keyboard
            FocusScope.of(context).requestFocus(FocusNode());
            // settle
            await Future.delayed(
                Duration(milliseconds: _animationDuration * 2));
            // call resulting function
            widget.onPressed();
          },
        ));
  }
}
