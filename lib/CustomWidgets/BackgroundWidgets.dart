import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class FoodGradient extends StatefulWidget {
  FoodGradient({Key key, this.child, this.back: false})
      : super(key:key);

  /// Set true to add a back button
  final bool back;
  final Widget child;
  _FoodGradientState createState() => _FoodGradientState();

}

class _FoodGradientState extends State<FoodGradient> {

  Widget build(BuildContext context) {

    return SafeArea(
        child: Stack(
            children: <Widget>[
              // Background image
              Opacity(
                  opacity: .4,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/background.jpg"),
                          fit: BoxFit.cover
                      ),
                    ),
                  )
              ),

              // Color Gradient
              Opacity(
                opacity: .6,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue, Colors.purple]
                    ),
                  ),
                ),
              ),

              // Optional Back Button
              widget.back ? Positioned(
                  top: 5,
                  left: 5,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
              ):Container(),

              // Optional Child
              widget.child == null ? Container() : widget.child,
            ]
        )
    );
  }
}