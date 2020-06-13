import 'package:samehomediffhacks/Models/Restaurant.dart';

import '../Networking/Network.dart';

class RestaurantServices {
    static Future<List<Restaurant>> getRestaurants() async {
      List<dynamic> body = await Network.get('get-restaurants', null);
      List<Restaurant> restaurants = List();
      for(Map<String, dynamic> json in body) {
        restaurants.add(Restaurant.fromJSON(json));
      }

      return restaurants;
    }
}