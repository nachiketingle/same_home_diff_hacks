import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Models/Restaurant.dart';
import 'AppThemes.dart';

class RestaurantsPage extends StatefulWidget {
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  List<Restaurant> _restaurants = List<Restaurant>();
  List<Restaurant> _finishedList = List<Restaurant>();

  void _showMoreInfo() {
    Navigator.pushNamed(context, "/restaurantInfo");
  }

  void _addRestaurants() {
    _restaurants.add(Restaurant.minimum("InnOut"));
    _restaurants.add(Restaurant.minimum("TacoBell"));
    _restaurants.add(Restaurant.minimum("Subway"));
    _restaurants.add(Restaurant.minimum("McDonald's"));
    _restaurants.add(Restaurant.minimum("Falafel Stop"));
  }

  List<Widget> _getCards() {
    List<Widget> cards = List();

    for(Restaurant rest in _restaurants) {
      cards.add(
        Dismissible(
          key: Key(rest.name),
          onDismissed: (dir) {
            if(dir == DismissDirection.startToEnd) {
              rest.votedFor = true;
            }
            else {
              rest.votedFor = false;
            }
            _restaurants.remove(rest);
            _finishedList.add(rest);
          },
          child: Center(
            child: Card(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.7,
                  child: Text(rest.name)
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
    _addRestaurants();
  }

  Widget build(BuildContext context) {
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