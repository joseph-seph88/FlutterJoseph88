class WeatherModel {
  final String id;
  final int day;
  final String city;
  final double temperature;
  final double windSpeed;
  final int humidity;
  final double probabilityRain;
  final String weatherDescription;
  final double uvIndex;

  WeatherModel({
    required this.id,
    required this.day,
    required this.city,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.probabilityRain,
    required this.weatherDescription,
    required this.uvIndex,
  });
}
