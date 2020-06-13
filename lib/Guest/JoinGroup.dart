import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';
import 'package:samehomediffhacks/Models/User.dart';
import 'package:samehomediffhacks/Services/GroupServices.dart';

class JoinGroup extends StatefulWidget {
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {

  TextEditingController _accessCodeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool _pinging = false;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void submitCode() async {
    if(_pinging) {
      return;
    }
    _pinging = true;
    String code = _accessCodeController.text;
    String name = _nameController.text.trim();
    
    GroupServices.joinGroup(code, name).then((value) {
      _pinging = false;
      if(value.containsKey('error')) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(value['error']),
        ));
      }
      else {
        User user = User(false, name, code, value['groupName']);
        Navigator.pushNamed(context, "/guestLobby", arguments: user);
      }
    });

  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Join Group Page"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.http),
            onPressed: () {
              _accessCodeController.text = "c65a";
              submitCode();
            },
          )
        ],
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