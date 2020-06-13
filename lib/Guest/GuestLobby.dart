import 'package:flutter/material.dart';
import '../Models/User.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';

class GuestLobby extends StatefulWidget {
  _GuestLobbyState createState() => _GuestLobbyState();
}

class _GuestLobbyState extends State<GuestLobby> {

  User user;
  List<String> _allUsers = List<String>();

  void startVote() {
    if(!isValid()) {
      return;
    }

    // Tell server to start vote
    Navigator.of(context).pushNamed("/categories", arguments: user);
  }

  bool isValid() {
    // Determine if there is just more than one person in the group
    return _allUsers.length > 1;
  }

  void getNames() {
    // Ping server to get list of names
    _allUsers.clear();
    _allUsers.add(user.name);
    _allUsers.add("Kev");
    _allUsers.add("arOn");
    _allUsers.add("Casp");
  }

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {

    user = ModalRoute.of(context).settings.arguments;
    print(user.toString());
    getNames();

    return Scaffold(
      appBar: AppBar(
        title: Text("Group: " + user.groupName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Acces Code: " + user.accessCode.toString()),
            ListView.builder(
                itemCount: _allUsers.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_allUsers[index]),
                  );
                }
            ),
            Text("Number of Users: " + _allUsers.length.toString())
          ],
        ),
      ),
    );
  }
}