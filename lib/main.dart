import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:samehomediffhacks/CategoriesPage.dart';
import 'package:samehomediffhacks/Lobby.dart';
import 'package:samehomediffhacks/RestaurantInfo.dart';
import 'package:samehomediffhacks/RestaurantsPage.dart';
import 'package:samehomediffhacks/Results.dart';
import 'Helpers/AppThemes.dart';
import 'Home.dart';
import 'package:samehomediffhacks/WaitingRoom.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

//void main() => runApp(MyApp());
Future main() async {
  await DotEnv().load('.env');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: AppThemes.primaryColor, fontFamily: "Montserrat"),
      home: HomePage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/lobby':
            return PageTransition(
              child: Lobby(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/categories':
            return PageTransition(
              child: CategoriesPage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/restaurants':
            return PageTransition(
              child: RestaurantsPage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/restaurantInfo':
            return PageTransition(
              child: RestaurantInfoPage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/results':
            return PageTransition(
              child: ResultsPage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/waiting':
            return PageTransition(
              child: WaitingRoom(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          default:
            return null;
        }
      },
      initialRoute: "/",
    );
  }
}
