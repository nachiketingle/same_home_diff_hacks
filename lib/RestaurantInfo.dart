import 'package:flutter/material.dart';

class RestaurantInfoPage extends StatefulWidget {
  _RestaurantInfoPageState createState() => _RestaurantInfoPageState();
}

class _RestaurantInfoPageState extends State<RestaurantInfoPage> {

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("RestaurantInfo Page"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is the Restaurant Info page"),
          ],
        ),
      ),
    );

  }

}