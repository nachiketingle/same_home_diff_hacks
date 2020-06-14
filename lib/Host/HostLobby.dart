import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';
import 'package:samehomediffhacks/Services/CategoryService.dart';
import 'package:samehomediffhacks/Wrappers/LobbyToCategory.dart';
import '../Models/User.dart';
import '../Networking/PusherWeb.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HostLobby extends StatefulWidget {
  _HostLobbyState createState() => _HostLobbyState();
}

class _HostLobbyState extends State<HostLobby> {
  User user;
  List<String> _allUsers = List<String>();
  PusherWeb pusher;
  bool _loaded = false;
  bool _pinging = false;
  String _eventName = 'onGuestJoin';

  void startVote() async {
    if(!isValid() && _pinging) {
      return;
    }
    _pinging = true;

    CategoryService.startCategory(user.accessCode).then((value) {
      LobbyToCategory(user, value);
      // Tell server to start vote
      Navigator.of(context).pushNamed("/categories");
    });

  }

  bool isValid() {
    // Determine if there is just more than one person in the group
    return _allUsers.length > 1;
  }

  void listenStream() async {
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
      user = ModalRoute.of(context).settings.arguments;
      _loaded = true;
      pusher.firePusher(user.accessCode, _eventName);
      listenStream();
      _allUsers.add(user.name);
    }
    print(user.toString());


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
      floatingActionButton: FloatingActionButton.extended(
          onPressed: startVote,
          label: Text("Start Voting", style: TextStyle(color: AppThemes.buttonTextColor),)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}