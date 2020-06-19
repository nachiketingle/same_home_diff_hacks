import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';
import 'package:samehomediffhacks/Services/CategoryService.dart';
import 'package:samehomediffhacks/Wrappers/LobbyToCategory.dart';
import './Models/User.dart';
import './Networking/PusherWeb.dart';

class Lobby extends StatefulWidget {
  _LobbyState createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  List<String> emojis = [
    '🍇',
    '🍈',
    '🍉',
    '🍊',
    '🍋',
    '🍌',
    '🍍',
    '🍎',
    '🍏',
    '🍐',
    '🍑',
    '🍒',
    '🍓',
    '🥝',
    '🍅',
    '🥑'
  ];

  bool isHost;
  User user;
  List<String> _allUsers = List<String>();
  bool _loaded = false;
  bool _pinging = false;
  PusherWeb pusher;
  String _eventName = "onGuestJoin";
  int myIndex;

  void startVote() async {
    if (_pinging) {
      return;
    }
    _pinging = true;

    CategoryService.startCategory(user.accessCode).then((value) {
      // Tell server to start vote
      Navigator.of(context).pushNamedAndRemoveUntil("/categories", (_) => false,
          arguments: LobbyToCategory(user, value));
    });
  }

  void listenStream() async {
    await pusher.firePusher(user.accessCode, _eventName);
    pusher.bindEvent('onCategoryStart');
    pusher.eventStream.listen((event) {
      print("Event: " + event);
      Map<String, dynamic> json = jsonDecode(event);
      if (json['event'] == _eventName) {
        setState(() {
          _allUsers.clear();
          List<dynamic> _temp = json['message'];
          for (String name in _temp) {
            _allUsers.add(name);
          }
        });
      } else if (json['event'] == 'onCategoryStart') {
        Map<String, dynamic> value = json['message'];
        Navigator.pushNamedAndRemoveUntil(context, '/categories', (_) => false,
            arguments: LobbyToCategory(user, value));
      }
    });
  }

  void initState() {
    super.initState();
    emojis.shuffle();
    pusher = PusherWeb();
  }

  void dispose() {
    pusher.unbindEvent(_eventName);
    pusher.unSubscribePusher(user.accessCode);
    super.dispose();
  }

  Widget build(BuildContext context) {
    if (!_loaded) {
      List<User> users = ModalRoute.of(context).settings.arguments;
      _allUsers.clear();
      for (User _user in users) {
        _allUsers.add(_user.name);
      }
      isHost = users[0].isHost;
      myIndex = users.length - 1;
      user = users.last;
      print(_allUsers);
      _loaded = true;
      listenStream();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Lobby"),
      ),
      body: Stack(children: <Widget>[
        Opacity(
          opacity: .6,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topRight,
                  colors: [Colors.blue, Colors.purple]),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                user.groupName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: AppThemes.primaryColor),
              ),
              Text(
                "Access Code: " + user.accessCode.toString(),
                style: TextStyle(fontSize: 20),
              ),
              Divider(
                color: Colors.black,
              ),
              Expanded(
                  child: Center(
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: _allUsers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text('${emojis[index % emojis.length]}',
                            style: TextStyle(fontSize: 30)),
                        title: Text(
                          _allUsers[index],
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(index == 0 ? "Owner" : 'Guest #$index'),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.tag_faces,
                            size: 30,
                          ),
                          onPressed: () {
                            print("${myIndex} Pokes ${index}");
                          },
                        ),
                      );
                    }),
              )),
              Divider(
                color: Colors.black,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * .03),
                    child: Text(
                      "Group Size: " + _allUsers.length.toString(),
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ],
          ),
        ),
      ]),
      floatingActionButton: (isHost != null && isHost)
          ? FloatingActionButton.extended(
              onPressed: startVote,
              label: Text(
                "Start Voting",
                style: TextStyle(color: AppThemes.buttonTextColor),
              ))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
