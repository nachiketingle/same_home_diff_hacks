import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Models/Restaurant.dart';
import 'package:samehomediffhacks/Services/RestaurantServices.dart';
import 'package:samehomediffhacks/Wrappers/FromWaiting.dart';
import 'package:samehomediffhacks/Wrappers/ToWaiting.dart';
import 'package:samehomediffhacks/Models/User.dart';
import 'Helpers/AppThemes.dart';

class RestaurantsPage extends StatefulWidget {
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  List<Restaurant> _restaurants = List<Restaurant>();
  List<Restaurant> _leftList = List<Restaurant>();
  List<Restaurant> _rightList = List<Restaurant>();
  bool _loaded = false;
  User _user;

  void _submitRestaurants() {
    List<String> _ids = List();
    for(Restaurant rest in _rightList) {
      _ids.add(rest.id);
    }

    RestaurantServices.submitSwipes(_user.accessCode, _user.name, _ids).then((value) {
      List<String> remaining = List();
      for(String name in value) {
        remaining.add(name);
      }
      ToWaiting wrapper = ToWaiting(_user, 'onSwipeEnd', 'onResultFound', '/results', remaining);
      Navigator.pushNamed(context, "/waiting", arguments: wrapper);
    });

  }

  void _showMoreInfo(Restaurant restaurant) {
    Navigator.pushNamed(context, "/restaurantInfo", arguments: restaurant);
  }

  void _addRestaurants(List<dynamic> body) {
    for(Map<String, dynamic> json in body) {
      _restaurants.add(Restaurant.fromJSON(json));
    }

    setState(() {

    });
  }

  List<Widget> _getCards() {
    List<Widget> cards = List();

    for(Restaurant rest in _restaurants) {
      cards.add(
        Dismissible(
          key: UniqueKey(),
          onDismissed: (dir) {
            if(dir == DismissDirection.startToEnd) {
              rest.votedFor = true;
              _rightList.add(rest);
            }
            else {
              rest.votedFor = false;
              _leftList.add(rest);
            }
            setState(() {
              _restaurants.remove(rest);
            });

          },
          child: Center(
            child: GestureDetector(
              onTap: () => _showMoreInfo(rest),
              child: Card(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(child: Image.network(rest.imageURLs[0])),
                        Text(rest.name, style: TextStyle(fontSize: 20),)
                      ],
                    )
                ),
              ),
            ),
          ),
        )
      );
    }

    return cards;
  }

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    if(_loaded) {
      if(_restaurants.length == 0) {
        _submitRestaurants();
      }
    }

    if(!_loaded) {

      FromWaiting wrapper = ModalRoute.of(context).settings.arguments;
      _user = wrapper.user;
      //List<dynamic> json = jsonDecode(wrapper.message);
      RestaurantServices.getRestaurants(_user.accessCode).then((value) {
        setState(() {
          _restaurants = value;
          _loaded = true;
        });
      });
      //_addRestaurants(json);

    }



    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurants Page"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.pushNamed(context, "/results");
            },
          )
        ],
      ),

      body: Center(
        child: Stack(
          children: _getCards()
        ),
      ),
    );
  }

}