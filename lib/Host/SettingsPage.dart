import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:samehomediffhacks/AppThemes.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings Page"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is the settings page"),
            RaisedButton(
              color: AppThemes.primaryColor,
              child: Text("Get Access Code", style: TextStyle(color: AppThemes.buttonTextColor),),
              onPressed: () {
                Navigator.pushNamed(context, "/createGroup");
              },
            )
          ],
        ),
      ),
    );

  }

}