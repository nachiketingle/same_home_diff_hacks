import '../Networking/Network.dart';
import '../Helpers/Constants.dart';

class CategoryService {
  static Future<bool> startCategory(String accessCode) async {
    Map<String, dynamic> body = Map();
    body['accessCode'] = accessCode;
    List<dynamic> list = await Network.put(Constants.startCategories, body);
    print("Start Category: " + list[0]);
    return list[0];
  }

  static Future<bool> setCategories(String accessCode, List<String> categories) async {
    Map<String, dynamic> body = Map();
    body['accessCode'] = accessCode;
    body['categories'] = categories;
    List<dynamic> list = await Network.put(Constants.setCategories, body);
    print("Set Category: " + list[0]);
    return list[0];
  }

}