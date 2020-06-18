import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samehomediffhacks/CustomWidgets/BackgroundWidgets.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';
import 'package:samehomediffhacks/Services/CategoryService.dart';
import 'package:samehomediffhacks/Wrappers/LobbyToCategory.dart';
import '../Models/User.dart';
import '../Networking/PusherWeb.dart';

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
      // Tell server to start vote
      Navigator.of(context).pushNamedAndRemoveUntil("/categories", (_) => false, arguments: LobbyToCategory(user, value));
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

    return Scaffold(
      body: FoodGradient(
        back: true,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  "Access Code: " + user.accessCode.toString(),
                  style: AppThemes.basicTextStyle(),),
              ),
              ListView.builder(
                  itemCount: _allUsers.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _allUsers[index],
                        style: AppThemes.basicTextStyle(),),
                    );
                  }
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Text(
                  "Number of Users: " + _allUsers.length.toString(),
                  style: AppThemes.basicTextStyle(),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppThemes.buttonColor,
          onPressed: startVote,
          label: Text("Start Voting", style: TextStyle(color: AppThemes.buttonTextColor),)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}