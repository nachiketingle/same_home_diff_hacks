import 'package:flutter/material.dart';
import 'AppThemes.dart';

class RestaurantsPage extends StatefulWidget {
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurants Page"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is the restaurants page"),
            RaisedButton(
              color: AppThemes.primaryColor,
              child: Text("Restaurant Info", style: TextStyle(color: AppThemes.buttonTextColor),),
              onPressed: () {
                Navigator.pushNamed(context, "/restaurantInfo");
              },
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(20),
            ),
            RaisedButton(
              color: AppThemes.primaryColor,
              child: Text("Get Results", style: TextStyle(color: AppThemes.buttonTextColor),),
              onPressed: () {
                Navigator.pushNamed(context, "/results");
              },
            ),
          ],
        ),
      ),
    );
  }

}