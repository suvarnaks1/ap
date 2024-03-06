import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Placemark?> getLocationName(Position? position) async {
    if (position != null) {
      try {
        //postion convert
        final Placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (Placemarks.isNotEmpty) {
          return Placemarks[0];
        }
      } catch (e) {
        print("Error fetching location name");
      }
      return null;
    }
    
  }
}
