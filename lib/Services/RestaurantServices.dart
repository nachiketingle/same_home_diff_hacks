import 'package:samehomediffhacks/Models/Restaurant.dart';
import '../Helpers/Constants.dart';
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

    static Future<bool> submitSwipes(String accessCode, List<String> left, List<String> right) async {
      Map<String, dynamic> body = Map();
      body['accessCode'] = accessCode;
      Map<String, dynamic> swipes = Map();
      swipes['left'] = left;
      swipes['right'] = right;
      body['swipes'] = swipes;
      List<dynamic> list = await Network.put(Constants.submitSwipes, body);
      print("Submitted Swipes: " + list[0]);
      return list[0];
    }

}