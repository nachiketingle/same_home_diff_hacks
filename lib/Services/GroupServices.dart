import '../Networking/Network.dart';

class GroupServices {

  static Future<String> createGroup(String groupName, String name, double lat, double lng, double maxDistance) async {
    Map<String, dynamic> json = Map();
    json['groupName'] = groupName;
    json['name'] =  name;
    json['latitude'] = lat.toString();
    json['longitude'] = lng.toString();
    json['maxDistance'] = maxDistance.toString();
    print("Creating a group");
    Map<String, dynamic> list = await Network.put("create-group", json);
    print("Create group response: " + list['accessCode']);
    return list['accessCode'];
  }

  static Future<bool> joinGroup(String accessCode) async {
    Map<String, dynamic> json = Map();
    json['accessCode'] = accessCode;
    List<dynamic> list = await Network.put('join-group', json);
    print("Join Success: " + list[0]);
    return list[0];
  }

}