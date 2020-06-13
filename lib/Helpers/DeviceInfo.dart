import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart' as perm;
import 'package:shared_preferences/shared_preferences.dart';

class DeviceInfo {
  static Location _location = Location();

  /// Requests permission for location if not granted
  /// Will return [PermissionStatus.denied] or [PermissionStatus.granted]
  static Future<perm.PermissionStatus> locationPermissions() async{
    bool serviceStatus = await _location.serviceEnabled();
    perm.PermissionStatus permissionStatus = await perm.LocationPermissions().checkPermissionStatus();

    if(!serviceStatus) {
      serviceStatus = await _location.requestService();
      if(!serviceStatus)
        return perm.PermissionStatus.denied;
    }

    if(permissionStatus != perm.PermissionStatus.granted) {
      await perm.LocationPermissions().requestPermissions();
    }

    return await perm.LocationPermissions().checkPermissionStatus();
  }

  /// Get location data from device
  /// If permission is not [PermissionStatus.granted], return [null]
  static Future<LocationData> getLocationData() async {
    perm.PermissionStatus status = await locationPermissions();
    if (status != perm.PermissionStatus.granted)
      return null;

    return await _location.getLocation();
  }

  static Future<SharedPreferences> loadSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }
}