import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Helpers/AppThemes.dart';
import '../Models/User.dart';
import '../Services/GroupServices.dart';
import '../Helpers/DeviceInfo.dart';
import 'package:samehomediffhacks/Bulge.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  double miles = 10;
  double lat;
  double lng;
  bool _pinging = false;

  void getAccessCode(BuildContext context) async {
    if (!validFields(context)) return;
    if (_pinging) return;

    setState(() {
      _pinging = true;
    });

    await DeviceInfo.getLocationData().then((value) {
      double lat = value.latitude;
      double lng = value.longitude;
      GroupServices.createGroup(_groupNameController.text.trim(),
              _nameController.text.trim(), lat, lng, miles)
          .then((value) {
        List<User> allUsers = List();
        // If successful, create user and go to next page
        User user = User(
          true,
          _nameController.text.trim(),
          value,
          _groupNameController.text.trim(),
        );
        allUsers.add(user);
        Navigator.pushNamed(context, "/lobby", arguments: allUsers);
      }).timeout(Duration(seconds: 30), onTimeout: () {
        // If not, indicate it with snack bar
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("TIMEOUT: Unable to retrieve code"),
        ));
      });
    });
    _pinging = false;
  }

  bool validFields(BuildContext context) {
    if (_nameController.text.trim().length > 0 &&
        _groupNameController.text.trim().length > 0) {
      return true;
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Please fill out all of fields"),
    ));
    return false;
  }

  Widget build(BuildContext context) {
    Widget body;
    if (_pinging) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Creating Group...",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.deepPurple[50])),
          Transform.scale(
              scale: 2.5, child: SpinKitDoubleBounce(color: Colors.deepPurple))
        ],
      );
    } else {
      body = Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(hintText: "Group Name"),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "Your Name"),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Column(
              children: <Widget>[
                Text("Max distance: " + miles.toStringAsFixed(1) + " miles"),
                SliderTheme(
                    data: SliderThemeData(trackShape: CustomTrackShape()),
                    child: Slider(
                      activeColor: Colors.purple[900],
                      min: 1,
                      max: 25,
                      divisions: 48,
                      value: miles,
                      onChanged: (val) {
                        setState(() {
                          miles = val;
                        });
                      },
                    ))
              ],
            ),
            Bulge(onPressed: () {
              getAccessCode(context);
            })
          ],
        )),
      );
    }
    return Center(child: body);
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = 5;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
