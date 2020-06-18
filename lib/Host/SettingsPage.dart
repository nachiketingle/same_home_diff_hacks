import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';
import '../Models/User.dart';
import '../Services/GroupServices.dart';
import '../Helpers/DeviceInfo.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  double miles = 10;
  double lat;
  double lng;
  bool _pinging = false;

  void getAccessCode() async {
    if (!validFields()) return;
    if (_pinging) return;

    _pinging = true;
    // TODO: Ping server for access code
    await DeviceInfo.getLocationData().then((value) {
      double lat = value.latitude;
      double lng = value.longitude;
      GroupServices.createGroup(_groupNameController.text.trim(),
              _nameController.text.trim(), lat, lng, miles)
          .then((value) {
        // If successful, create user and go to next page
        User user = User(
          true,
          _nameController.text.trim(),
          value,
          _groupNameController.text.trim(),
        );
        Navigator.pushNamed(context, "/createGroup", arguments: user);
      }).timeout(Duration(seconds: 30), onTimeout: () {
        // If not, indicate it with snack bar
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("TIMEOUT: Unable to retrieve code"),
        ));
      });
      /*.catchError((err) {
        // If not, indicate it with snack bar
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("ERROR: " + err.toString()),
        ));
      });*/
    });
    _pinging = false;
  }

  bool validFields() {
    if (_nameController.text.trim().length > 0 &&
        _groupNameController.text.trim().length > 0) {
      return true;
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Please fill out all of fields"),
    ));
    return false;
  }

  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextField(
              controller: _groupNameController,
              decoration: InputDecoration(hintText: "Group Name"),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "Your Name"),
            ),
          ),
          Text("Max distance: " + miles.toStringAsFixed(2) + " miles"),
          Slider(
            activeColor: Colors.purple[900],
            min: 1,
            max: 25,
            value: miles,
            onChanged: (val) {
              setState(() {
                miles = val;
              });
            },
          ),
          ButtonTheme(
            buttonColor: AppThemes.highlightColor,
            minWidth: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: RaisedButton(
              child: Text(
                "Create!",
                style: TextStyle(color: AppThemes.buttonTextColor),
              ),
              onPressed: getAccessCode,
            ),
          )
        ],
      ),
    );
  }
}
