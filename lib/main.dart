import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:samehomediffhacks/CategoriesPage.dart';
import 'package:samehomediffhacks/Guest/GuestLobby.dart';
import 'package:samehomediffhacks/Guest/JoinGroup.dart';
import 'package:samehomediffhacks/RestaurantInfo.dart';
import 'package:samehomediffhacks/RestaurantsPage.dart';
import 'package:samehomediffhacks/Results.dart';
import 'Helpers/AppThemes.dart';
import 'Home.dart';
import 'Host/SettingsPage.dart';
import 'Host/HostLobby.dart';

//void main() => runApp(MyApp());
Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: AppThemes.primaryColor,
      ),
      routes: {
        "/": (context) => HomePage(),
        "/settings": (context) => SettingsPage(),
        "/createGroup": (context) => HostLobby(),
        "/joinGroup": (context) => JoinGroup(),
        "/guestLobby": (context) => GuestLobby(),
        "/categories": (context) => CategoriesPage(),
        "/restaurants": (context) => RestaurantsPage(),
        "/restaurantInfo": (context) => RestaurantInfoPage(),
        "/results": (context) => ResultsPage(),
      },
      initialRoute: "/",
    );
  }
}