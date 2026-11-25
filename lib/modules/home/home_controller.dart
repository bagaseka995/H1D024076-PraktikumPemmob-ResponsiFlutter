import 'dart:async';
import 'package:get/get.dart';
import '../../data/local/favorite_service.dart';
import '../../data/models/location_model.dart';
import '../../data/models/weather_model.dart';
import '../../data/services/weather_service.dart';

class HomeController extends GetxController {
  final weatherData = Rxn<WeatherData>();
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final cityName = 'Cuaca'.obs;

  LocationModel? _currentLocation;
  int _loadGeneration = 0;

  @override
  void onInit() {
    super.onInit();
    _loadLastLocation();
  }

  void _loadLastLocation() {
    final lastLocation = FavoriteService.getLastLocation();
    if (lastLocation != null) {
      selectLocation(lastLocation);
    }
  }

  void selectLocation(LocationModel location) {
    _currentLocation = location;
    cityName.value = location.name;
    weatherData.value = null;
    FavoriteService.setLastLocation(location);
    loadWeather();
  }

  Future<void> loadWeather() async {
    if (_currentLocation == null) return;

    final gen = ++_loadGeneration;

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final data = await WeatherService.getWeather(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
      );

      if (gen != _loadGeneration) return;
      weatherData.value = data;
    } on TimeoutException {
      if (gen != _loadGeneration) return;
      errorMessage.value = 'Koneksi timeout. Coba lagi.';
    } catch (e) {
      if (gen != _loadGeneration) return;
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (gen == _loadGeneration) {
        isLoading.value = false;
      }
    }
  }
}
