import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';

class JoinGroup extends StatefulWidget {
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Group Page"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is the page to join groups"),
            RaisedButton(
              color: AppThemes.primaryColor,
              child: Text("Join Group", style: TextStyle(color: AppThemes.buttonTextColor),),
              onPressed: () {
                Navigator.pushNamed(context, "/guestLobby");
              },
            )
          ],
        ),
      ),
    );
  }
}