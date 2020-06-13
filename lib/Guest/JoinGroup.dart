import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';
import 'package:samehomediffhacks/Services/GroupServices.dart';

class JoinGroup extends StatefulWidget {
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {

  TextEditingController _accessCodeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool _pinging = false;

  void submitCode() async {
    if(!_isValid() || _pinging) {
      return;
    }
    _pinging = true;
    String code = _accessCodeController.text;
    String name = _nameController.text.trim();
    _pinging = false;
    Navigator.pushNamed(context, "/guestLobby");
    //GroupServices.joinGroup(code).then((value) {

    //});

  }

  bool _isValid() {
    return true;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Group Page"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _accessCodeController,
              decoration: InputDecoration(
                  hintText: "Access Code"
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  hintText: "Name"
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {
        submitCode();
      },
        label: Text("Join"),
      ),
    );
  }
}