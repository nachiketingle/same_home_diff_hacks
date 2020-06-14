import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Wrappers/LobbyToCategory.dart';
import '../Models/User.dart';
import '../Networking/PusherWeb.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';

class GuestLobby extends StatefulWidget {
  _GuestLobbyState createState() => _GuestLobbyState();
}

class _GuestLobbyState extends State<GuestLobby> {

  User user;
  List<String> _allUsers = List<String>();
  bool _loaded = false;
  PusherWeb pusher;
  String _eventName = "onGuestJoin";

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

  void listenStream() async {
    pusher.firePusher(user.accessCode, _eventName);
    pusher.firePusher(user.accessCode, 'onCategoryStart');
    pusher.eventStream.listen((event) {
      print("Event: " + event);
      Map<String, dynamic> json = jsonDecode(event);
      if(json['event'] == _eventName) {
        setState(() {
          _allUsers.clear();
          List<dynamic> _temp  = json['message'];
          for(String name in _temp) {
            _allUsers.add(name);
          }
        });
      }
      else if(json['event'] == 'onCategoryStart') {
        Map<String, dynamic> value = json['message'];
        Navigator.pushNamedAndRemoveUntil(context, '/categories', (_) => false, arguments: LobbyToCategory(user, value));
      }
    });
  }

  void initState() {
    super.initState();
    pusher = PusherWeb();
  }

  void dispose() {
    pusher.unbindEvent(_eventName);
    pusher.unSubscribePusher(user.accessCode);
    super.dispose();
  }

  Widget build(BuildContext context) {
    if(!_loaded) {
      List<User> users = ModalRoute.of(context).settings.arguments;
      _allUsers.clear();
      for(User _user in users) {
        _allUsers.add(_user.name);
      }
      user = users.last;
      print(_allUsers);
      _loaded = true;
      listenStream();
    }

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