import 'package:samehomediffhacks/Models/Restaurant.dart';
import '../Helpers/Constants.dart';
import '../Networking/Network.dart';

class RestaurantServices {
  static List<Restaurant> allRestaurants = List();

    static Future<List<Restaurant>> getRestaurants(String accessCode) async {
      List<dynamic> body = await Network.get('restaurants', null);

      List<Restaurant> restaurants = List();
      for(Map<String, dynamic> json in body) {
        restaurants.add(Restaurant.fromJSON(json));
      }

      return restaurants;
    }

    static Future<List<dynamic>> submitSwipes(String accessCode, List<String> ids) async {
      Map<String, dynamic> body = Map();
      body['accessCode'] = accessCode;
      Map<String, dynamic> swipes = Map();
      swipes['swipes'] = ids;
      body['swipes'] = swipes;
      List<dynamic> list = await Network.put(Constants.submitSwipes, body);
      print("Submitted Swipes: " + list.toString());
      return list;
    }

}