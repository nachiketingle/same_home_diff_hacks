import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Models/Restaurant.dart';
import 'package:samehomediffhacks/Services/RestaurantServices.dart';
import 'Helpers/AppThemes.dart';

class RestaurantsPage extends StatefulWidget {
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  List<Restaurant> _restaurants = List<Restaurant>();
  List<Restaurant> _leftList = List<Restaurant>();
  List<Restaurant> _rightList = List<Restaurant>();

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
                        Image.network(rest.imageURLs[0]),
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