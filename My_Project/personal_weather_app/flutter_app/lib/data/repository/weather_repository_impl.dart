import 'package:flutter_app/data/data_source/weather_data_source.dart';
import 'package:flutter_app/data/mapper/weather_mapper.dart';
import 'package:flutter_app/domain/repository/weather_repository.dart';
import 'package:uuid/uuid.dart';
import '../model/weather_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherDataSource _dataSource;
  final uuid = Uuid();

  WeatherRepositoryImpl(this._dataSource);

  @override
  Future<List<WeatherModel>> fetchForecast(String city) async {
    try {
      final Map<String, dynamic> weatherResponse =
          await _dataSource.fetchForecast(city);
      final List<dynamic> weatherData = weatherResponse['list'];
      final cityName = weatherResponse['city']?['name'] ?? 'Seoul';

      final Map<String, dynamic> uvResponse =
          await _dataSource.getUvIndex(city);
      final double uvIndex = uvResponse['value'] ?? 8.8;

      return weatherData.map((data) {
        return WeatherMapper.fromJson(data, uuid.v4(), uvIndex, cityName);
      }).toList();
    } catch (e) {
      throw Exception('[REPO] fetchForecast Error ${e.toString()}');
    }
  }

}
