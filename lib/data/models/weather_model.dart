class CurrentWeather {
  final double temperature;
  final double relativeHumidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;

  const CurrentWeather({
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0,
      relativeHumidity:
          (json['relative_humidity_2m'] as num?)?.toDouble() ?? 0,
      apparentTemperature:
          (json['apparent_temperature'] as num?)?.toDouble() ?? 0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0,
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int precipitationProbabilityMax;
  final int weatherCode;

  const DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.precipitationProbabilityMax,
    required this.weatherCode,
  });
}

class WeatherData {
  final CurrentWeather current;
  final List<DailyForecast> daily;

  const WeatherData({required this.current, required this.daily});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final currentJson = json['current'] as Map<String, dynamic>;
    final dailyJson = json['daily'] as Map<String, dynamic>;

    final times =
        (dailyJson['time'] as List?)?.cast<String>() ?? <String>[];
    final maxTemps =
        (dailyJson['temperature_2m_max'] as List?)?.cast<num>() ?? <num>[];
    final minTemps =
        (dailyJson['temperature_2m_min'] as List?)?.cast<num>() ?? <num>[];
    final precipProbs =
        (dailyJson['precipitation_probability_max'] as List?)?.cast<num>() ??
            <num>[];
    final weatherCodes =
        (dailyJson['weather_code'] as List?)?.cast<num>() ?? <num>[];

    final dailyList = <DailyForecast>[];
    for (int i = 0; i < times.length; i++) {
      dailyList.add(DailyForecast(
        date: DateTime.parse(times[i]),
        tempMax: i < maxTemps.length ? maxTemps[i].toDouble() : 0,
        tempMin: i < minTemps.length ? minTemps[i].toDouble() : 0,
        precipitationProbabilityMax:
            i < precipProbs.length ? precipProbs[i].toInt() : 0,
        weatherCode:
            i < weatherCodes.length ? weatherCodes[i].toInt() : 0,
      ));
    }

    return WeatherData(
      current: CurrentWeather.fromJson(currentJson),
      daily: dailyList,
    );
  }
}
