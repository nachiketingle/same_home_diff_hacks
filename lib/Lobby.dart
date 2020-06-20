import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';
import 'package:samehomediffhacks/Services/CategoryService.dart';
import 'package:samehomediffhacks/Wrappers/LobbyToCategory.dart';
import './Models/User.dart';
import './Networking/PusherWeb.dart';
import './Networking/Network.dart';
import './Helpers/Constants.dart';
import './Particles.dart';

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
  List<bool> _pokable = List<bool>();
  bool _loaded = false;
  bool _pinging = false;
  PusherWeb pusher;
  int myIndex;
  bool _poking = false;
  String _pokingEmoji = "";

  // called by host only
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

  // listen for events
  void listenStream() async {
    // initialize pusher
    await pusher.firePusher(user.accessCode, "onGuestJoin");
    pusher.bindEvent('onCategoryStart');
    pusher.bindEvent('onPoke');
    // add listener for events
    pusher.eventStream.listen((event) {
      print("Event: " + event);
      Map<String, dynamic> json = jsonDecode(event);
      if (json['event'] == "onGuestJoin") {
        setState(() {
          _allUsers.clear();
          List<dynamic> _temp = json['message'];
          // add every name
          for (String name in _temp) {
            _allUsers.add(name);
          }
          // new users are pokable
          int missing = _allUsers.length - _pokable.length;
          for (int i = 0; i < missing; i++) {
            _pokable.add(true);
          }
        });
      } else if (json['event'] == 'onCategoryStart') {
        // receives the categories
        Map<String, dynamic> value = json['message'];
        Navigator.pushNamedAndRemoveUntil(context, '/categories', (_) => false,
            arguments: LobbyToCategory(user, value));
      } else if (json['event'] == 'onPoke') {
        // receives sender and reciever
        Map<String, dynamic> value = json['message'];
        int from = int.parse(value['from']);
        int to = int.parse(value['to']);
        if (myIndex == to) {
          print("Getting Poked by $from ${emojis[from]}");
          setState(() {
            _poking = true;
            _pokingEmoji = emojis[from];
            _pokable[from] = true;
          });
        }
      }
    });
  }

  void poke(int from, int to) {
    print('$from poked $to');
    // prevent poke spam
    setState(() {
      _pokable[to] = false;
    });
    String accessCode = user.accessCode;
    // create put body
    Map<String, dynamic> body = Map();
    body['accessCode'] = accessCode;
    body['from'] = from.toString();
    body['to'] = to.toString();
    // send put request
    Network.put(Constants.poke, body);
  }

  void onPokeFinished() async {
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      _poking = false;
    });
  }

  void initState() {
    super.initState();
    emojis.shuffle();
    pusher = PusherWeb();
  }

  void dispose() {
    pusher.unbindEvent("onCategoryStart");
    pusher.unbindEvent("onGuestJoin");
    pusher.unbindEvent("onPoke");
    pusher.unSubscribePusher(user.accessCode);
    super.dispose();
  }

  Widget build(BuildContext context) {
    // load initial data
    if (!_loaded) {
      // get list of people in lobby
      List<User> users = ModalRoute.of(context).settings.arguments;
      // add each user
      _allUsers.clear();
      for (User _user in users) {
        _allUsers.add(_user.name);
      }
      // new users are pokable
      int missing = _allUsers.length - _pokable.length;
      for (int i = 0; i < missing; i++) {
        _pokable.add(true);
      }
      // identify if the person is a host
      isHost = users[0].isHost;
      // assign unique index
      myIndex = users.length - 1;
      user = users.last;
      print(_allUsers);
      listenStream();
      _loaded = true;
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
                            color: _pokable[index]
                                ? AppThemes.highlightColor
                                : null,
                            size: 30,
                          ),
                          onPressed: _pokable[index]
                              ? () {
                                  poke(myIndex, index);
                                }
                              : null,
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
        if (_poking)
          Positioned.fill(
              child: IgnorePointer(
                  child: Particles(30, _pokingEmoji, onPokeFinished))),
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
