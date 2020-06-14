import 'dart:convert';

import '../Networking/Network.dart';
import '../Helpers/Constants.dart';

class CategoryService {
  static Future<Map<String, dynamic>> startCategory(String accessCode) async {
    Map<String, dynamic> body = Map();
    body['accessCode'] = accessCode;
    Map<String, dynamic> list = await Network.put(Constants.startCategories, body);
    print("Start Category: " + list.toString());
    return list;
  }

  static Future<List<dynamic>> setCategories(String accessCode, String name, List<String> codes) async {
    Map<String, dynamic> body = Map();
    body['accessCode'] = accessCode;
    body['categories'] = jsonEncode(codes);
    List<dynamic> list = await Network.put(Constants.setCategories, body);
    print("Set Category: " + list.toString());
    return list;
  }

}