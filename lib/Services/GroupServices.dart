import '../Networking/Network.dart';

class GroupServices {

  static Future<String> createGroup(String groupName, String name, double lat, double lng, double maxDistance) async {
    Map<String, dynamic> json = Map();
    json['groupName'] = groupName;
    json['name'] =  name;
    json['latitude'] = lat;
    json['longitude'] = lng;
    json['maxDistance'] = maxDistance;
    String val = await Network.put("create-group", json);
    print("Create group response: " + val);
    return val;
  }


}