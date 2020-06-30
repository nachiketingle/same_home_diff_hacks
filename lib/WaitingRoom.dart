import 'dart:convert';

import 'package:flutter/material.dart';
import 'Wrappers/FromWaiting.dart';
import 'Wrappers/ToWaiting.dart';
import 'Networking/PusherWeb.dart';
import 'Models/User.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WaitingRoom extends StatefulWidget {
  _WaitingRoomState createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  PusherWeb pusher;
  String _eventName;
  String _futureEvent;
  String _nextRoute;
  User _user;
  bool _loaded = false;
  List<String> _remaining = List();

  void initState() {
    super.initState();
    pusher = PusherWeb();
  }

  void dispose() {
    pusher.unbindEvent(_eventName);
    pusher.unSubscribePusher(_user.accessCode);
    super.dispose();
  }

  void listenStream() async {
    pusher.eventStream.listen((event) async {
      print("Event: " + event);
      Map<String, dynamic> json = jsonDecode(event);
      if (json['event'] == _eventName) {
        setState(() {
          _remaining.clear();
          List<dynamic> _temp = json['message'];
          for (String name in _temp) {
            _remaining.add(name);
          }
        });
      } else if (json['event'] == _futureEvent) {
        // await Future.delayed(Duration(milliseconds: 10000000));
        FromWaiting wrapper = FromWaiting(_user, json['message']);
        Navigator.pushNamedAndRemoveUntil(context, _nextRoute, (_) => false,
            arguments: wrapper);
      }
    });
  }

  Widget build(BuildContext context) {
    if (!_loaded) {
      _loaded = true;
      ToWaiting wrapper = ModalRoute.of(context).settings.arguments;
      _eventName = wrapper.eventName;
      _user = wrapper.user;
      _futureEvent = wrapper.futureEvent;
      _nextRoute = wrapper.nextRoute;
      _remaining = wrapper.remaining;
      pusher.firePusher(_user.accessCode, _eventName).then((value) {
        pusher.bindEvent(_futureEvent);
        print("Events Binded in Waiting: " + _eventName + " " + _futureEvent);
      });
      listenStream();
    }

    return Scaffold(
      body: SafeArea(
          child: Center(
              child: Stack(children: <Widget>[
        Opacity(
          opacity: .6,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.blue, Colors.purple]),
            ),
          ),
        ),
        Column(children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * .1,
          ),
          Text(_remaining.length == 0 ? "Loading..." : "Waiting for...",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.deepPurple[50])),
          if (_remaining.length > 0)
            ListView.builder(
                shrinkWrap: true,
                itemCount: _remaining.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: new Center(
                        child: Text(_remaining[index],
                            style: TextStyle(fontSize: 25))),
                  );
                }),
          if (_remaining.length == 0)
            Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .3,
                ),
                Transform.scale(
                    scale: 4,
                    child: SpinKitDoubleBounce(color: Colors.deepPurple))
              ],
            )
        ])
      ]))),
    );
  }
}
