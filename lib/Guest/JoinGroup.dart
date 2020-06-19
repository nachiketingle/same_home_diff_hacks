import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Models/User.dart';
import 'package:samehomediffhacks/Services/GroupServices.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';
import 'package:samehomediffhacks/Bulge.dart';

class JoinGroup extends StatefulWidget {
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  TextEditingController _accessCodeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool _pinging = false;

  void submitCode(BuildContext context) async {
    if (_isValid() && _pinging) {
      return;
    }
    _pinging = true;
    String code = _accessCodeController.text;
    String name = _nameController.text.trim();

    GroupServices.joinGroup(code, name).then((value) {
      _pinging = false;
      if (value.containsKey('error')) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(value['error']),
        ));
      } else {
        List<dynamic> _temp = value['members'];
        List<User> allUsers = List();
        for (String username in _temp) {
          allUsers.add(User(false, username, code, value['groupName']));
        }

        Navigator.pushNamed(context, "/lobby", arguments: allUsers);
      }
    });
  }

  bool _isValid() {
    if (_nameController.text.trim().length > 0) return true;

    return false;
  }

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextField(
              controller: _accessCodeController,
              decoration: InputDecoration(hintText: "Access Code"),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "Name"),
            ),
            Bulge(
              onPressed: () async {
                submitCode(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
