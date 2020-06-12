import 'package:flutter/material.dart';
import 'package:samehomediffhacks/AppThemes.dart';

class GuestLobby extends StatefulWidget {
  _GuestLobbyState createState() => _GuestLobbyState();
}

class _GuestLobbyState extends State<GuestLobby> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guest Lobby Page"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is the guest lobby page"),
            RaisedButton(
              color: AppThemes.primaryColor,
              child: Text("To Categories", style: TextStyle(color: AppThemes.buttonTextColor),),
              onPressed: () {
                Navigator.pushNamed(context, "/categories");
              },
            )
          ],
        ),
      ),
    );
  }
}