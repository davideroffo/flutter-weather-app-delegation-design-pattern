import 'package:location/location.dart';

class LocationService {
  var location = Location();
  var _serviceEnabled = false;
  var _permissionGranted = PermissionStatus.denied;

  Future<void> _init() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<LocationData> requestLocation() async {
    await _init();
    final locationData = await location.getLocation();
    return locationData;
  }
}
