import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Models/Restaurant.dart';
import 'package:samehomediffhacks/Services/RestaurantServices.dart';
import 'package:samehomediffhacks/Wrappers/FromWaiting.dart';
import 'package:samehomediffhacks/Wrappers/ToWaiting.dart';
import 'package:samehomediffhacks/Models/User.dart';
import 'package:samehomediffhacks/SwipeCard.dart';
import 'Helpers/AppThemes.dart';
import 'dart:math';
import 'dart:core';

class RestaurantsPage extends StatefulWidget {
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage>
    with TickerProviderStateMixin {
  List<Restaurant> _restaurants = List<Restaurant>();
  List<Restaurant> _leftList = List<Restaurant>();
  List<Restaurant> _rightList = List<Restaurant>();
  bool _loaded = false;
  User _user;
  String stampPosition = "";

  // animations
  double xOffset = 0;
  double yOffset = 0;
  double xPosition = 0;
  double yPosition = 0;
  double angle = 0;
  double opacity = 0;
  Offset start;
  double submitThreshold = .3;

  void _submitRestaurants() {
    List<String> _ids = List();
    for (Restaurant rest in _rightList) {
      _ids.add(rest.id);
    }

    RestaurantServices.submitSwipes(_user.accessCode, _user.name, _ids)
        .then((value) {
      List<String> remaining = List();
      for (String name in value) {
        remaining.add(name);
      }
      ToWaiting wrapper = ToWaiting(
          _user, 'onSwipeEnd', 'onResultFound', '/results', remaining);
      Navigator.pushNamed(context, "/waiting", arguments: wrapper);
    });
  }

  void _showMoreInfo(Restaurant restaurant) {
    Navigator.pushNamed(context, "/restaurantInfo", arguments: restaurant);
  }

  List<Widget> _getCards(BuildContext context) {
    List<Widget> cards = [];
    for (int i = 0; i < _restaurants.length; i++) {
      Restaurant rest = _restaurants[i];
      Widget card;
      if (i == _restaurants.length - 1) {
        card = Positioned(
            top: yPosition,
            left: xPosition,
            child: GestureDetector(
                onTap: () {
                  _showMoreInfo(rest);
                },
                onPanUpdate: (tapInfo) {
                  double deltaX = tapInfo.localPosition.dx - start.dx;
                  setState(() {
                    // threshold to see stamp
                    double threshold =
                        submitThreshold / 5 * MediaQuery.of(context).size.width;
                    if (deltaX > threshold) {
                      stampPosition = "left";
                    } else if (deltaX < -1 * threshold) {
                      stampPosition = "right";
                    } else {
                      stampPosition = "";
                    }
                    angle = (xPosition / (MediaQuery.of(context).size.width))
                            .clamp(-1.0, 1.0)
                            .toDouble() *
                        pi /
                        6;
                    opacity = (xPosition.abs() /
                            (MediaQuery.of(context).size.width *
                                submitThreshold))
                        .clamp(0, 1.0)
                        .toDouble();
                    xPosition += tapInfo.delta.dx;
                    yPosition += tapInfo.delta.dy;
                  });
                },
                onPanDown: (details) {
                  start = details.localPosition;
                },
                onPanEnd: (details) {
                  print('$xPosition $yPosition');
                  double threshold = .35 * MediaQuery.of(context).size.width;
                  // swipe right
                  if (xPosition - xOffset > threshold) {
                    print("RIGHT");
                    rest.votedFor = true;
                    _rightList.add(rest);
                    _restaurants.remove(rest);
                  }
                  // swipe left
                  else if (xPosition - xOffset < -1 * threshold) {
                    print("LEFT");
                    rest.votedFor = false;
                    _leftList.add(rest);
                    _restaurants.remove(rest);
                  }
                  setState(() {
                    stampPosition = "";
                    xPosition = xOffset;
                    yPosition = yOffset;
                    angle = 0;
                  });
                },
                child: SwipeCard(
                  restaurant: rest,
                  stampPosition: stampPosition,
                  angle: angle,
                  opacity: opacity,
                )));
      } else {
        card = Padding(
            padding: EdgeInsets.only(left: xOffset, top: yOffset),
            child: SwipeCard(
              restaurant: rest,
              stampPosition: "",
              angle: 0,
              opacity: 0,
            ));
      }
      cards.add(card);
    }
    return cards;
  }

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    if (_loaded) {
      if (_restaurants.length == 0) {
        _submitRestaurants();
      }
    }

    if (!_loaded) {
      setState(() {
        xOffset = MediaQuery.of(context).size.width * .05;
        yOffset = MediaQuery.of(context).size.height * .05;
        xPosition = xOffset;
        yPosition = yOffset;
      });

      FromWaiting wrapper = ModalRoute.of(context).settings.arguments;
      _user = wrapper.user;
      RestaurantServices.getRestaurants(_user.accessCode).then((value) {
        setState(() {
          _restaurants = value;
          _loaded = true;
        });
      });
    }

    ShapeDecoration buttonDecoration =
        ShapeDecoration(color: Colors.white, shape: CircleBorder(), shadows: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 3,
        blurRadius: 7,
        offset: Offset(0, 3),
      )
    ]);

    return Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "RESTAURANTS",
                style: new TextStyle(
                    fontSize: 18.0,
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.bold),
              ),
              new Container(
                width: 20.0,
                height: 20.0,
                margin: new EdgeInsets.only(bottom: 20.0),
                alignment: Alignment.center,
                child: new Text(
                  '${_restaurants.length}',
                  style: new TextStyle(fontSize: 10.0),
                ),
                decoration: new BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
              )
            ],
          ),
        ),
        body: Stack(children: <Widget>[
          Opacity(
            opacity: .6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topLeft,
                    colors: [Colors.blue, Colors.purple]),
              ),
            ),
          ),
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * .8,
                      height: MediaQuery.of(context).size.height * .1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Ink(
                              decoration: buttonDecoration,
                              child: IconButton(
                                iconSize: 50,
                                icon: Icon(Icons.close),
                                onPressed: () {},
                                color: Colors.red,
                              )),
                          Ink(
                              decoration: buttonDecoration,
                              child: IconButton(
                                iconSize: 40,
                                icon: Icon(Icons.favorite),
                                onPressed: () {},
                                color: Colors.lightGreen[400],
                              )),
                        ],
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),
                ]),
          ),
          Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(children: _getCards(context))),
        ]));
  }
}
