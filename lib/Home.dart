import 'package:flutter/material.dart';
import 'package:samehomediffhacks/AppThemes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DotEnv().env['VAR_NAME'])//"Home Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              child: RaisedButton(
                child: Text("Create Group", style: TextStyle(color: AppThemes.buttonTextColor),),
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                },
              ),
            ),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              child: RaisedButton(
                child: Text("Join Group", style: TextStyle(color: AppThemes.buttonTextColor),),
                onPressed: () {
                  Navigator.pushNamed(context, "/joinGroup");
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}