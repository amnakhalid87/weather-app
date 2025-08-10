import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:weather_app/Services/api_service.dart';

class ApiController extends GetxController {
  dynamic CurrentWeatherData;
  dynamic HourlyWeatherData;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  @override
  void onInit() {
    getUserLocation();
    CurrentWeatherData = getCurrentWeather(latitude.value, longitude.value);
    HourlyWeatherData = getHourlyWeather(latitude.value, longitude.value);

    super.onInit();
  }

  getUserLocation() async {
    var isLocationEnabled;
    var userPermission;
    isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      return Future.error("location is not enable ,first enable it");
    }
    userPermission = await Geolocator.checkPermission();
    if (userPermission == LocationPermission.deniedForever) {
      return Future.error("Permission denied forever for location");
    } else if (userPermission == LocationPermission.denied) {
      userPermission = await Geolocator.requestPermission();
      if (userPermission == LocationPermission.denied) {
        return Future.error("Permission denied again!");
      }
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Value) {
      latitude.value = Value.latitude;
      longitude.value = Value.longitude;
    });
  }
}
