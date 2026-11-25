import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/weather_model.dart';

class WeatherService {
  WeatherService._();

  static Future<WeatherData> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri =
        Uri.parse('${ApiConstants.weatherBaseUrl}/forecast').replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current':
            'temperature_2m,relative_humidity_2m,apparent_temperature,'
                'precipitation,weather_code,wind_speed_10m',
        'daily':
            'temperature_2m_max,temperature_2m_min,'
                'precipitation_probability_max,weather_code',
        'timezone': 'auto',
      },
    );

    final response = await http.get(uri).timeout(ApiConstants.timeout);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherData.fromJson(json);
    } else {
      throw Exception(
          'Gagal mengambil data cuaca (${response.statusCode})');
    }
  }
}
