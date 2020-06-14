import 'dart:convert';

import 'package:samehomediffhacks/Models/Restaurant.dart';
import '../Helpers/Constants.dart';
import '../Networking/Network.dart';

class RestaurantServices {
  static List<Restaurant> allRestaurants = List();

    static Future<List<Restaurant>> getRestaurants(String accessCode) async {

      Map<String, String> body = Map();
      body['accessCode'] = accessCode;

      List<dynamic> json = await Network.get('restaurants', body);

      List<Restaurant> restaurants = List();
      for(Map<String, dynamic> val in json) {
        restaurants.add(Restaurant.fromJSON(val));
      }

      return restaurants;
    }

    static Future<List<dynamic>> submitSwipes(String accessCode, String name, List<String> ids) async {
      Map<String, String> body = Map();
      body['accessCode'] = accessCode;
      body['swipes'] = jsonEncode(ids);
      body['name'] = name;

      List<dynamic> list = await Network.put(Constants.submitSwipes, body);
      print("Submitted Swipes: " + list.toString());
      return list;
    }

}