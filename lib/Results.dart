import 'package:flutter/material.dart';
import 'Helpers/AppThemes.dart';

class ResultsPage extends StatefulWidget {
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Results Page"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is the Results page"),
            RaisedButton(
              color: AppThemes.primaryColor,
              child: Text("Get Restaurant Info", style: TextStyle(color: AppThemes.buttonTextColor),),
              onPressed: () {
                Navigator.pushNamed(context, "/restaurantInfo");
              },
            )
          ],
        ),
      ),
    );

  }

}