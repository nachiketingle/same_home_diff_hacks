import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Models/Restaurant.dart';
import 'package:samehomediffhacks/Services/RestaurantServices.dart';
import 'AppThemes.dart';

class RestaurantsPage extends StatefulWidget {
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  List<Restaurant> _restaurants = List<Restaurant>();
  List<Restaurant> _finishedList = List<Restaurant>();

  void _showMoreInfo(Restaurant restaurant) {
    Navigator.pushNamed(context, "/restaurantInfo", arguments: restaurant);
  }

  void _addRestaurants() async {
    _restaurants = await RestaurantServices.getRestaurants();
    setState(() {

    });
  }

  List<Widget> _getCards() {
    List<Widget> cards = List();

    for(Restaurant rest in _restaurants) {
      cards.add(
        Dismissible(
          key: Key(rest.name),
          onDismissed: (dir) {
            _restaurants.remove(rest);
            _finishedList.add(rest);
            if(dir == DismissDirection.startToEnd) {
              rest.votedFor = true;
            }
            else {
              rest.votedFor = false;
            }
          },
          child: Center(
            child: GestureDetector(
              onTap: () => _showMoreInfo(rest),
              child: Card(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.7,
                    child: Text(rest.name)
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