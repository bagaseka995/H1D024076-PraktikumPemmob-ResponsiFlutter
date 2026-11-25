import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class FavoriteService {
  FavoriteService._();

  static const String _keyFavorites = 'favorite_locations';
  static const String _keyLastLocation = 'last_location';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ─── Favorit ────────────────────────────────────────────────

  static List<LocationModel> getFavorites() {
    final jsonStr = _prefs.getString(_keyFavorites);
    if (jsonStr == null) return [];
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list
        .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> _saveFavorites(List<LocationModel> favorites) async {
    final jsonStr = jsonEncode(favorites.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyFavorites, jsonStr);
  }

  static Future<void> addFavorite(LocationModel location) async {
    final favorites = getFavorites();
    if (favorites.any((f) => f.id == location.id)) return;
    favorites.add(location);
    await _saveFavorites(favorites);
  }

  static Future<void> removeFavorite(int locationId) async {
    final favorites = getFavorites();
    favorites.removeWhere((f) => f.id == locationId);
    await _saveFavorites(favorites);
  }

  static bool isFavorite(int locationId) {
    return getFavorites().any((f) => f.id == locationId);
  }

  // ─── Lokasi Terakhir ───────────────────────────────────────

  static LocationModel? getLastLocation() {
    final jsonStr = _prefs.getString(_keyLastLocation);
    if (jsonStr == null) return null;
    return LocationModel.fromJson(
        jsonDecode(jsonStr) as Map<String, dynamic>);
  }

  static Future<void> setLastLocation(LocationModel location) async {
    await _prefs.setString(_keyLastLocation, jsonEncode(location.toJson()));
  }
}
