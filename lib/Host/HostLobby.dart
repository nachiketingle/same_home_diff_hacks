import 'package:flutter/material.dart';
import 'package:samehomediffhacks/AppThemes.dart';

class HostLobby extends StatefulWidget {
  _HostLobbyState createState() => _HostLobbyState();
}

class _HostLobbyState extends State<HostLobby> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Host Lobby Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is the lobby page for the host"),
            RaisedButton(
              color: AppThemes.primaryColor,
              child: Text("Choose Categories", style: TextStyle(color: AppThemes.buttonTextColor),),
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