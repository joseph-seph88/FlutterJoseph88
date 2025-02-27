import 'package:flutter_app/data/model/weather_model.dart';

abstract class WeatherRepository {
  Future<List<WeatherModel>> fetchForecast(String city);
}
