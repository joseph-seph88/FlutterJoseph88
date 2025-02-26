import 'package:flutter/material.dart';

class Weather {
  final String id;
  final DateTime day;
  final String city;
  final double temperature;
  final double windSpeed;
  final String uvDescription;
  final int humidity;
  final double? probabilityRain;
  final String weatherDescription;
  final IconData weatherIcon;
  final String windDescription;
  final String rainDescription;
  final String humidityDescription;
  final String tempDescription;
  final String warningDesc;

  Weather({
    required this.id,
    required this.day,
    required this.city,
    required this.temperature,
    required this.windSpeed,
    required this.uvDescription,
    required this.humidity,
    required this.probabilityRain,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.windDescription,
    required this.rainDescription,
    required this.humidityDescription,
    required this.tempDescription,
    required this.warningDesc,
  });

  factory Weather.fromJson(
    Map<String, dynamic> weatherData,
    String id,
    DateTime forecastDate,
    IconData weatherIcon,
    String windDescription,
    String rainDescription,
    String humidityDescription,
    String tempDescription,
    String warningDesc,
    String uvDescription,
  ) {
    return Weather(
      id: id,
      day: forecastDate,
      city: weatherData['city']?['name'] ?? "88",
      temperature:
          double.tryParse(weatherData['main']?['temp']?.toString() ?? '') ??
              8.8,
      windSpeed: weatherData['wind']?['speed'] ?? 8.8,
      uvDescription: uvDescription,
      humidity: weatherData['main']?['humidity'] ?? 88,
      probabilityRain: (weatherData['rain']?['3h'] ?? 8.8).toDouble(),
      weatherDescription: weatherData['weather']?[0]['description'] ?? '88',
      weatherIcon: weatherIcon,
      windDescription: windDescription,
      rainDescription: rainDescription,
      humidityDescription: humidityDescription,
      tempDescription: tempDescription,
      warningDesc: warningDesc,
    );
  }
}
