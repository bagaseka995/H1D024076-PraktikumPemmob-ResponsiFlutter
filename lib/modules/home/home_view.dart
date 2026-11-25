import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/weather_utils.dart';
import '../../data/models/weather_model.dart';
import '../../routes/app_routes.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              controller.cityName.value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Cari kota',
            onPressed: () => Get.toNamed(Routes.search),
          ),
        ],
      ),
      body: Obx(() {
        // ── Loading ──
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── Error ──
        if (controller.errorMessage.value != null) {
          return _buildError(context);
        }

        // ── Belum ada lokasi ──
        final weather = controller.weatherData.value;
        if (weather == null) {
          return _buildEmpty(context);
        }

        // ── Data cuaca ──
        return RefreshIndicator(
          onRefresh: controller.loadWeather,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCurrentCard(context, weather.current),
                const SizedBox(height: 16),
                _buildInfoRow(context, weather.current),
                const SizedBox(height: 24),
                _buildDailySection(context, weather.daily),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ─── State: Error ─────────────────────────────────────────

  Widget _buildError(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 72, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: controller.loadWeather,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  // ─── State: Kosong ────────────────────────────────────────

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_city,
                size: 72, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Pilih kota untuk melihat cuaca',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => Get.toNamed(Routes.search),
              icon: const Icon(Icons.search),
              label: const Text('Cari Kota'),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Kartu Cuaca Saat Ini ─────────────────────────────────

  Widget _buildCurrentCard(BuildContext context, CurrentWeather current) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          children: [
            Icon(
              WeatherUtils.getIcon(current.weatherCode),
              size: 72,
              color: WeatherUtils.getIconColor(current.weatherCode),
            ),
            const SizedBox(height: 8),
            Text(
              WeatherUtils.getDescription(current.weatherCode),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${current.temperature.round()}°C',
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Terasa seperti ${current.apparentTemperature.round()}°C',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Info Row (Kelembapan, Angin, Curah Hujan) ────────────

  Widget _buildInfoRow(BuildContext context, CurrentWeather current) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            Icons.water_drop_outlined,
            '${current.relativeHumidity.round()}%',
            'Kelembapan',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildInfoCard(
            context,
            Icons.air,
            '${current.windSpeed.round()} km/h',
            'Angin',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildInfoCard(
            context,
            Icons.umbrella,
            '${current.precipitation} mm',
            'Curah Hujan',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Prakiraan 7 Hari ─────────────────────────────────────

  Widget _buildDailySection(
      BuildContext context, List<DailyForecast> daily) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Prakiraan 7 Hari',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          color: theme.colorScheme.surfaceContainerHighest,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                for (int i = 0; i < daily.length; i++) ...[
                  _buildDailyRow(context, daily[i]),
                  if (i < daily.length - 1)
                    Divider(
                        height: 1,
                        color: theme.colorScheme.outlineVariant),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyRow(BuildContext context, DailyForecast forecast) {
    final theme = Theme.of(context);
    final isToday = WeatherUtils.isToday(forecast.date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              WeatherUtils.getDayName(forecast.date),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Icon(
            WeatherUtils.getIcon(forecast.weatherCode),
            size: 24,
            color: WeatherUtils.getIconColor(forecast.weatherCode),
          ),
          const SizedBox(width: 12),
          Icon(Icons.water_drop, size: 14, color: Colors.blue.shade400),
          const SizedBox(width: 2),
          SizedBox(
            width: 36,
            child: Text(
              '${forecast.precipitationProbabilityMax}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.blue.shade600,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '${forecast.tempMax.round()}°',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' / ${forecast.tempMin.round()}°',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
