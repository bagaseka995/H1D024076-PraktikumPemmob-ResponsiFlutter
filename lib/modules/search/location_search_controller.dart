import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/local/favorite_service.dart';
import '../../data/models/location_model.dart';
import '../../data/services/geocoding_service.dart';
import '../home/home_controller.dart';

class LocationSearchController extends GetxController {
  final searchQuery = ''.obs;
  final searchResults = <LocationModel>[].obs;
  final isSearching = false.obs;
  final searchError = RxnString();
  final favorites = <LocationModel>[].obs;

  final searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadFavorites();

    debounce(
      searchQuery,
      (_) => performSearch(),
      time: const Duration(milliseconds: 500),
    );
  }

  void loadFavorites() {
    favorites.value = FavoriteService.getFavorites();
  }

  Future<void> performSearch() async {
    final query = searchQuery.value;
    if (query.trim().isEmpty) {
      searchResults.clear();
      searchError.value = null;
      return;
    }

    try {
      isSearching.value = true;
      searchError.value = null;
      searchResults.value = await GeocodingService.searchLocation(query);
    } catch (e) {
      searchError.value = 'Gagal mencari lokasi. Periksa koneksi internet.';
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  void toggleFavorite(LocationModel location) {
    if (favorites.any((f) => f.id == location.id)) {
      favorites.removeWhere((f) => f.id == location.id);
      FavoriteService.removeFavorite(location.id);
    } else {
      favorites.add(location);
      FavoriteService.addFavorite(location);
    }
  }

  void selectLocation(LocationModel location) {
    final homeController = Get.find<HomeController>();
    homeController.selectLocation(location);
    Get.back();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
