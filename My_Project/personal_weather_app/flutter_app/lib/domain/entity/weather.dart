import 'package:flutter/material.dart';

class Weather {
  final String id;
  final DateTime day;
  final String city;
  final double temperature;
  final String weatherDescription;
  final IconData weatherIcon;
  final String uvDescription;
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
    required this.weatherDescription,
    required this.weatherIcon,
    required this.uvDescription,
    required this.windDescription,
    required this.rainDescription,
    required this.humidityDescription,
    required this.tempDescription,
    required this.warningDesc,
  });

}
