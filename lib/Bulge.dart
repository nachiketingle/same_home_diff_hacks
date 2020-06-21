import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';

typedef void VoidCallback();

class Bulge extends StatefulWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final double iconSize;
  Bulge(
      {Key key,
      @required this.onPressed,
      @required this.icon,
      @required this.iconSize})
      : super(key: key);
  BulgeState createState() => BulgeState();
}

class BulgeState extends State<Bulge> with SingleTickerProviderStateMixin {
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

  Future bulge() async {
    print("Bulge Call!");
    // animate bulge
    animationController.forward();
    // wait for bulge to end
    return Future.delayed(Duration(milliseconds: _animationDuration * 2));
  }

  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: animation,
        alignment: Alignment.center,
        child: IconButton(
          iconSize: widget.iconSize,
          color: AppThemes.highlightColor,
          hoverColor: AppThemes.buttonColor,
          icon: widget.icon,
          onPressed: widget.onPressed != null
              ? () async {
                  await bulge();
                  // close keyboard
                  FocusScope.of(context).requestFocus(FocusNode());
                  // settle
                  await Future.delayed(
                      Duration(milliseconds: _animationDuration * 2));
                  // call resulting function
                  widget.onPressed();
                }
              : null,
        ));
  }
}
