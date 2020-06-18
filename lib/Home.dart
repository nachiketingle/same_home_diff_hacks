import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';
import 'package:samehomediffhacks/Group.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;
  bool _formOpen = false;
  bool _keyboardVisible = false;
  int index = 0;
  int animationTime = 500;

  void _toggle() async {
    _formOpen = !_formOpen;
    switch (controller.status) {
      case AnimationStatus.completed:
        controller.reverse();
        await Future.delayed(Duration(milliseconds: animationTime));
        break;
      case AnimationStatus.dismissed:
        controller.forward();
        break;
      default:
        controller.forward();
    }
    setState(() {
      print('done');
    });
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: animationTime));
    offset = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    ));
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
        });
      },
    );
  }

  Widget build(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (!_keyboardVisible)
              Column(children: <Widget>[
                InkWell(
                    onTap: () {
                      _toggle();
                    },
                    child: Image.asset('assets/logo.png', scale: 1)),
                Text(
                  'Make a decision now.',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.deepPurple[50]),
                ),
                SizedBox(height: 30),
              ]),
            if (!_formOpen)
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
                        index = 0;
                        _toggle();
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),
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
                        index = 1;
                        _toggle();
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .15),
                ],
              ),
            if (_formOpen)
              Expanded(
                  child: SlideTransition(
                      position: offset,
                      child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            if (details.delta.dy > 10 && _formOpen) {
                              _toggle();
                            }
                          },
                          child: Group(index:index))))
          ],
        ))
      ]),
    ));
  }
}
