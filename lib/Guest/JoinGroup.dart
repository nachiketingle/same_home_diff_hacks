import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/Constants.dart';
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
    if(_isValid() && _pinging) {
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
        List<dynamic> _temp = value['members'];
        List<User> allUsers = List();
        for(String username in _temp) {
          allUsers.add(User(false, username, code, value['groupName']));
        }

        Navigator.pushNamed(context, "/guestLobby", arguments: allUsers);
      }
    });

  }

  bool _isValid() {
    if(_nameController.text.trim().length > 0)
      return true;

    return false;
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
              _accessCodeController.text = Constants.accessCode;
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