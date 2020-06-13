import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              child: RaisedButton(
                child: Text("Create Group", style: TextStyle(color: AppThemes.buttonTextColor),),
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                },
              ),
            ),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              child: RaisedButton(
                child: Text("Join Group", style: TextStyle(color: AppThemes.buttonTextColor),),
                onPressed: () {
                  Navigator.pushNamed(context, "/joinGroup");
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}