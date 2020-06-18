import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                      style: TextStyle(color: AppThemes.buttonTextColor, fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/settings");
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
                      style: TextStyle(color: AppThemes.buttonTextColor, fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/joinGroup");
                    },
                  ),
                )
              ],
            )
          ],
        ))
      ]),
    ));
  }
}
