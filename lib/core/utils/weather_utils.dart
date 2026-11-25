import 'package:flutter/material.dart';

class WeatherUtils {
  WeatherUtils._();

  static String getDescription(int code) {
    switch (code) {
      case 0:
        return 'Cerah';
      case 1:
        return 'Sebagian Cerah';
      case 2:
        return 'Berawan Sebagian';
      case 3:
        return 'Mendung';
      case 45:
      case 48:
        return 'Berkabut';
      case 51:
        return 'Gerimis Ringan';
      case 53:
        return 'Gerimis';
      case 55:
        return 'Gerimis Lebat';
      case 56:
      case 57:
        return 'Gerimis Beku';
      case 61:
        return 'Hujan Ringan';
      case 63:
        return 'Hujan Sedang';
      case 65:
        return 'Hujan Lebat';
      case 66:
      case 67:
        return 'Hujan Beku';
      case 71:
        return 'Salju Ringan';
      case 73:
        return 'Salju Sedang';
      case 75:
        return 'Salju Lebat';
      case 77:
        return 'Butir Salju';
      case 80:
        return 'Hujan Ringan';
      case 81:
        return 'Hujan Sedang';
      case 82:
        return 'Hujan Lebat';
      case 85:
      case 86:
        return 'Hujan Salju';
      case 95:
        return 'Badai Petir';
      case 96:
      case 99:
        return 'Badai & Hujan Es';
      default:
        return 'Tidak Diketahui';
    }
  }

  static IconData getIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 2) return Icons.wb_cloudy;
    if (code == 3) return Icons.cloud;
    if (code <= 48) return Icons.cloud;
    if (code <= 57) return Icons.grain;
    if (code <= 67) return Icons.water_drop;
    if (code <= 77) return Icons.ac_unit;
    if (code <= 82) return Icons.water_drop;
    if (code <= 86) return Icons.ac_unit;
    if (code <= 99) return Icons.flash_on;
    return Icons.help_outline;
  }

  static Color getIconColor(int code) {
    if (code == 0) return Colors.orange;
    if (code <= 3) return Colors.blueGrey;
    if (code <= 48) return Colors.grey;
    if (code <= 57) return Colors.lightBlue;
    if (code <= 67) return Colors.blue;
    if (code <= 77) return Colors.lightBlue.shade200;
    if (code <= 82) return Colors.blue;
    if (code <= 86) return Colors.lightBlue.shade200;
    if (code <= 99) return Colors.deepPurple;
    return Colors.grey;
  }

  static String getDayName(DateTime date) {
    if (isToday(date)) return 'Hari Ini';
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Besok';
    }
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[date.weekday - 1];
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
