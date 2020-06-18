import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;
  bool _formOpen = false;

  void _toggle() {
    setState(() {
      _formOpen = true;
      switch (controller.status) {
        case AnimationStatus.completed:
          controller.reverse();
          break;
        case AnimationStatus.dismissed:
          controller.forward();
          break;
        default:
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);
  }

  Widget build(BuildContext context) {
    print(offset);
    return Scaffold(
        body: SafeArea(
      child: Stack(children: <Widget>[
        Opacity(
            opacity: .4,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.jpg"),
                    fit: BoxFit.cover),
              ),
            )),
        Opacity(
          opacity: .6,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.purple]),
            ),
          ),
        ),
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(children: <Widget>[
              Image.asset('assets/logo.png', scale: 1),
              Text(
                'Make a decision now.',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.deepPurple[50]),
              )
            ]),
            // if (!_formOpen)
            Column(
              children: <Widget>[
                ButtonTheme(
                  buttonColor: AppThemes.buttonColor,
                  minWidth: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.height * 0.1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: RaisedButton(
                    child: Text(
                      "Create Group",
                      style: TextStyle(
                          color: AppThemes.buttonTextColor, fontSize: 18),
                    ),
                    onPressed: () {
                      _toggle();
                      // Navigator.pushNamed(context, "/settings");
                    },
                  ),
                ),
                SizedBox(height: 15),
                ButtonTheme(
                  buttonColor: AppThemes.buttonColor,
                  minWidth: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.height * 0.1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: RaisedButton(
                    child: Text(
                      "Join Group",
                      style: TextStyle(
                          color: AppThemes.buttonTextColor, fontSize: 18),
                    ),
                    onPressed: () {
                      // Navigator.pushNamed(context, "/joinGroup");
                    },
                  ),
                )
              ],
            ),
            if (_formOpen)
              Align(
                alignment: Alignment.bottomCenter,
                child: SlideTransition(
                    position: offset,
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: CircularProgressIndicator(),
                    )),
              )
          ],
        ))
      ]),
    ));
  }
}
