import 'package:flutter/material.dart';
import 'Models/Restaurant.dart';
import 'Services/RestaurantServices.dart';
import 'Wrappers/FromWaiting.dart';
import 'Models/User.dart';

class ResultsPage extends StatefulWidget {
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  bool _loaded = false;
  List<String> _ids = List();
  List<Restaurant> _restaurants = List();
  User _user;

  void getRestaurants() {
    RestaurantServices.getRestaurants(_user.accessCode).then((value) {
      List<Restaurant> allRestaurants = value;
      setState(() {
        for(Restaurant rest in allRestaurants) {
          if(_ids.contains(rest.id)) {
            _restaurants.add(rest);
          }
        }
      });
    });
  }

  void _showMoreInfo(Restaurant restaurant) {
    Navigator.pushNamed(context, "/restaurantInfo", arguments: restaurant);
  }

  Widget build(BuildContext context) {
    if(!_loaded) {
      _loaded = true;
      FromWaiting wrapper = ModalRoute.of(context).settings.arguments;
      for(String val in wrapper.message) {
        _ids.add(val);
      }
      _user = wrapper.user;
      getRestaurants();
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Results Page"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          )
        ],
      ),

      body: Center(
        child: ListView.builder(
          itemCount: _restaurants.length,
            itemBuilder: (context, index) {
              Restaurant rest = _restaurants[index];
              return GestureDetector(
                onTap: () => _showMoreInfo(rest),
                child: Card(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.network(
                            rest.imageURLs[0],
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.175,
                        ),
                        Text(rest.name, style: TextStyle(fontSize: 20),)
                      ],
                    )
                  ),
                ),
              );
            }),
      ),
    );

  }

}