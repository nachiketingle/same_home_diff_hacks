import 'dart:convert';

import 'package:flutter/material.dart';
import 'Wrappers/FromWaiting.dart';
import 'Wrappers/ToWaiting.dart';
import 'Networking/PusherWeb.dart';
import 'Models/User.dart';

class WaitingRoom extends StatefulWidget{
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
    pusher.eventStream.listen((event) {
      print("Event: " + event);
      Map<String, dynamic> json = jsonDecode(event);
      if(json['event'] == _eventName) {
        setState(() {
          _remaining.clear();
          List<dynamic> _temp  = json['message'];
          for(String name in _temp) {
            _remaining.add(name);
          }
          print(_remaining);
        });
      }
      else if(json['event'] == _futureEvent) {
        print(_futureEvent + " was invoked User: " + _user.accessCode);
        FromWaiting wrapper = FromWaiting(_user, json['message']);
        Navigator.pushNamedAndRemoveUntil(context, _nextRoute, (_) => false, arguments: wrapper);
      }
    });
  }

  Widget build(BuildContext context) {
    if(!_loaded) {
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
      appBar: AppBar(
        leading: Container(),
        title: Text("You are waiting for..."),
      ),
      body: Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _remaining.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_remaining[index]),
              );
            }),
      ),
    );
  }
}