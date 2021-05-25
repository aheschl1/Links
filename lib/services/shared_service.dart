import 'package:geolocator/geolocator.dart';
import 'package:place_picker/place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService{
  
  static Future<LatLng> getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List latLng = prefs.getStringList('location');
    if(latLng != null){
      return LatLng(double.parse(latLng[0]), double.parse(latLng[1]));
    }else{
      return null;
    }
  }

  static setLocation(LatLng position) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('location', [position.latitude.toString(), position.longitude.toString()]);
  }
  
}