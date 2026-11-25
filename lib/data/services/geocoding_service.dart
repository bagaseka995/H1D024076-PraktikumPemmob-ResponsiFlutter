import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/location_model.dart';

class GeocodingService {
  GeocodingService._();

  static Future<List<LocationModel>> searchLocation(String query) async {
    if (query.trim().isEmpty) return [];

    final uri =
        Uri.parse('${ApiConstants.geocodingBaseUrl}/search').replace(
      queryParameters: {
        'name': query.trim(),
        'count': '10',
        'language': 'id',
        'format': 'json',
      },
    );

    final response = await http.get(uri).timeout(ApiConstants.timeout);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final results = json['results'] as List<dynamic>?;
      if (results == null) return [];
      return results
          .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Gagal mencari lokasi (${response.statusCode})');
    }
  }
}
