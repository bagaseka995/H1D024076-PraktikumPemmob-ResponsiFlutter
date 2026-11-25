import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/location_model.dart';
import 'location_search_controller.dart';

class SearchView extends GetView<LocationSearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller.searchTextController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari nama kota...',
            border: InputBorder.none,
          ),
          onChanged: (value) => controller.searchQuery.value = value,
        ),
        actions: [
          Obx(() {
            if (controller.searchQuery.value.isEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller.searchTextController.clear();
                controller.searchQuery.value = '';
                controller.searchResults.clear();
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Bagian Favorit ──
            if (controller.favorites.isNotEmpty) ...[
              Text(
                'Lokasi Favorit',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...controller.favorites
                  .map((loc) => _buildLocationTile(context, loc)),
              const SizedBox(height: 20),
            ],

            // ── Bagian Pencarian ──
            if (controller.isSearching.value)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (controller.searchError.value != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48, color: theme.colorScheme.error),
                      const SizedBox(height: 12),
                      Text(
                        controller.searchError.value!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            else if (controller.searchQuery.value.isNotEmpty &&
                controller.searchResults.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off,
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(height: 12),
                      Text(
                        'Lokasi tidak ditemukan',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (controller.searchResults.isNotEmpty) ...[
              Text(
                'Hasil Pencarian',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...controller.searchResults
                  .map((loc) => _buildLocationTile(context, loc)),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildLocationTile(BuildContext context, LocationModel location) {
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: const Icon(Icons.location_on_outlined),
        title: Text(location.name),
        subtitle:
            location.subtitle.isNotEmpty ? Text(location.subtitle) : null,
        trailing: Obx(() => IconButton(
              icon: Icon(
                controller.favorites.any((f) => f.id == location.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: controller.favorites.any((f) => f.id == location.id)
                    ? Colors.red
                    : null,
              ),
              onPressed: () => controller.toggleFavorite(location),
            )),
        onTap: () => controller.selectLocation(location),
      ),
    );
  }
}
