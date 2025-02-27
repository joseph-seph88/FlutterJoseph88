import 'package:flutter_app/data/mapper/weather_mapper.dart';
import 'package:flutter_app/domain/repository/weather_repository.dart';
import '../entity/weather.dart';

class WeatherUseCase {
  final WeatherRepository _repository;

  WeatherUseCase(this._repository);

  Future<List<Weather>> fetchForecast(String city) async {
    try {
      final weatherList = await _repository.fetchForecast(city);
      final weatherData =
          weatherList.map((data) => WeatherMapper.fromModel(data)).toList();
      return weatherData;
    } catch (e) {
      throw Exception('[USE] fetchForecast Error ${e.toString()}');
    }
  }

  String transCityNameEng(String city) {
    var cityNames = {
      '서울': 'Seoul',
      '인천': 'Incheon',
      '경기도 고양시': 'Goyang',
      '대전': 'Daejeon',
      '부산': 'Busan',
    };

    return cityNames[city] ?? 'Seoul';
  }
}
