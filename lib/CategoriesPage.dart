import 'package:flutter/material.dart';
import 'AppThemes.dart';

class CategoriesPage extends StatefulWidget {
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories Page"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is the categories page"),
            RaisedButton(
              color: AppThemes.primaryColor,
              child: Text("Get Access Code", style: TextStyle(color: AppThemes.buttonTextColor),),
              onPressed: () {
                Navigator.pushNamed(context, "/restaurants");
              },
            )
          ],
        ),
      ),
    );
  }

}