import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:whetherapp/screens/services/Location_service.dart';

class LocationProvider with ChangeNotifier {
  
  Position? _currentPosition;

  Position? get currentPostion => _currentPosition;

  //instance for location service
  final LocationService _locationService=LocationService();
  Placemark? _currentLocationName;

  Placemark? get currentLocationName=>_currentLocationName;
  

//currentposition pick
  Future<void> determinePosition() async {
    bool serviceEnabled;
print('currentposion pick');
    LocationPermission permission;
    //check
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    //enabled not current position null
    if (!serviceEnabled) {
      print('currentposion null');
      _currentPosition = null;
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print('currentposion denied');
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        _currentPosition = null;
        notifyListeners();
        return;
      }
    }

    //Permission not granted
    if (permission == LocationPermission.deniedForever) {
      print('currentposion not granted');
      _currentPosition = null;
      notifyListeners();
      return;
    }
//we have the permission
    _currentPosition = await Geolocator.getCurrentPosition();
   print('Location is $_currentPosition');
    
//Location name convert
    _currentLocationName=await _locationService.getLocationName(_currentPosition);
    print('Location name is $_currentLocationName');
   
    notifyListeners();
  }

  //ask the permission

  //get the location

  //get the place mark
}
