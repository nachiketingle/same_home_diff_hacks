import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:samehomediffhacks/AppThemes.dart';
import '../Models/User.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  double miles = 10;

  void getAccessCode() {
    if (!validFields())
      return;

    // TODO: Ping server for access code
    bool success = true;
    if(success) {
      // TODO: If successful, create user and go to next page
      User user = User(
        true,
        _nameController.text.trim(),
        "A7G8F",
        _groupNameController.text.trim(),
      );
      Navigator.pushNamed(context, "/createGroup", arguments: user);
    }
    else {
      // TODO: If not, indicate it with snack bar
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Unable to retrieve code"),
      ));
    }
  }

  bool validFields() {
    if(_nameController.text.trim().length > 0 && _groupNameController.text.trim().length > 0) {
      return true;
    }
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Please fill out all fields"),
      )
    );
    return false;
  }

  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Settings Page"),
        actions: <Widget>[

        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                controller: _groupNameController,
                decoration: InputDecoration(
                  hintText: "Group Name"
                ),
              ),
            ),
            Text("Max distance: " + miles.toStringAsFixed(2) + " miles"),
            Slider(
              min: 1,
              max: 50,
              value: miles,
              onChanged: (val) {
                setState(() {
                  miles = val;
                });
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    hintText: "Your Name"
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Create Group", style: TextStyle(color: AppThemes.buttonTextColor),),
        onPressed: getAccessCode,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );

  }

}