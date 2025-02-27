import '../../domain/entity/weather.dart';
import '../model/weather_model.dart';
import 'package:flutter/material.dart';

class WeatherMapper {
  static Weather fromModel(WeatherModel model) {
    return Weather(
      id: model.id,
      day: _transSecondToDate(model.day),
      city: _transCityNameKr(model.city),
      temperature: model.temperature,
      weatherDescription: model.weatherDescription,
      weatherIcon: _transTextToIcon(model.weatherDescription),
      uvDescription: _transUvDescription(model.uvIndex),
      windDescription: _transWindDescription(model.windSpeed),
      rainDescription: _transRainDescription(model.probabilityRain),
      humidityDescription: _transHumidityDescription(model.humidity),
      tempDescription: _transTemperatureDescription(model.temperature),
      warningDesc: _transWeatherWarning(model.weatherDescription),
    );
  }

  static WeatherModel fromJson(
      Map<String, dynamic> weatherData, String id, double uvIndex, String cityName) {
    return WeatherModel(
      id: id,
      day: weatherData['dt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      city: cityName,
      temperature: (weatherData['main']?['temp'] ?? 8.8).toDouble(),
      windSpeed: (weatherData['wind']?['speed'] ?? 8.8).toDouble(),
      humidity: weatherData['main']?['humidity'] ?? 88,
      probabilityRain: (weatherData['rain']?['3h'] ?? 8888.0).toDouble(),
      weatherDescription: weatherData['weather']?[0]['description'] ?? '날씨 맑음',
      uvIndex: uvIndex,
    );
  }

  static DateTime _transSecondToDate(int timeStamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return dateTime;
  }

  static IconData _transTextToIcon(String weatherText) {
    final weatherIcons = {
      "맑음": Icons.wb_sunny,
      "비": Icons.water_drop,
      "보통 비": Icons.water_drop,
      "눈": Icons.cloudy_snowing,
      "약간의 구름이 낀 하늘": Icons.wb_cloudy,
      "튼구름": Icons.wb_cloudy,
      "온흐림": Icons.wb_cloudy,
      "구름조금": Icons.wb_cloudy,
    };

    return weatherIcons[weatherText] ?? Icons.wb_sunny;
  }

  static String _transWindDescription(num windSpeed) {
    if (windSpeed >= 0 && windSpeed <= 5) {
      return '약한 바람';
    } else if (windSpeed >= 6 && windSpeed <= 15) {
      return '보통 바람';
    } else if (windSpeed >= 16 && windSpeed <= 30) {
      return '강한 바람';
    } else if (windSpeed >= 31 && windSpeed <= 50) {
      return '매우 강한 바람';
    } else {
      return '강풍 주의';
    }
  }

  static String _transHumidityDescription(int humidity) {
    if (humidity >= 0 && humidity <= 40) {
      return '매우 건조';
    } else if (humidity >= 41 && humidity <= 60) {
      return '적당히 건조';
    } else if (humidity >= 61 && humidity <= 80) {
      return '약간 습함';
    } else {
      return '매우 습함';
    }
  }

  static String _transTemperatureDescription(double temperature) {
    if (temperature < -10) {
      return '혹한기';
    } else if (temperature > -10 && temperature < 0) {
      return '매우 추움';
    } else if (temperature >= 0 && temperature <= 10) {
      return '꽤 추움';
    } else if (temperature >= 11 && temperature <= 20) {
      return '쌀쌀함';
    } else if (temperature >= 21 && temperature <= 25) {
      return '적당히 따뜻함';
    } else if (temperature >= 26 && temperature <= 30) {
      return '덥지 않음';
    } else {
      return '폭염';
    }
  }

  static String _transRainDescription(double rain) {
    if (rain >= 8888) {
      return "비 안옴";
    }
    if (rain >= 0 && rain <= 2) {
      return '가벼운 비';
    } else if (rain > 2 && rain <= 5) {
      return '보통 비';
    } else if (rain > 5 && rain <= 10) {
      return '강한 비';
    } else if (rain > 10 && rain <= 20) {
      return '매우 강한 비';
    } else {
      return '집중 호우';
    }
  }

  static String _transWeatherWarning(String weather) {
    var weatherWarnings = {
      '맑음': '햇살 가득, 나가서 산책하기 좋은 날!',
      '비': '비가 와요. 우산 준비는 필수!',
      '보통 비': '가벼운 비가 내리고 있어요. 우산은 챙기세요.',
      '눈': '눈이 내려요. 길이 미끄럽습니다, 조심하세요!',
      '약간의 구름이 낀 하늘': '구름이 약간 있지만 대체로 맑고 좋아요!',
      '튼구름': '구름 많고 흐린 날, 우울해지지 않게 기분전환 필요!',
      '온흐림': '흐린 날씨, 조금 답답하지만 괜찮아요.',
      '구름조금': '구름이 조금 있지만, 대체로 맑고 쾌적해요.',
    };

    return weatherWarnings[weather] ?? '날씨 정보를 확인할 수 없습니다';
  }

  static String _transCityNameKr(String city) {
    var cityNames = {
      'Seoul': '서울',
      'Incheon': '인천',
      'Goyang-si': '고양시',
      'Daejeon': '대전',
      'Busan': '부산',
    };
    return cityNames[city] ?? '서울';
  }

  static String _transUvDescription(double uvIndex) {
    if (uvIndex >= 0 && uvIndex < 3) {
      return '자외선 낮음';
    } else if (uvIndex >= 3 && uvIndex < 6) {
      return '자외선 보통';
    } else if (uvIndex >= 6 && uvIndex < 8) {
      return '자외선 강함';
    } else if (uvIndex >= 8 && uvIndex < 11) {
      return '자외선 매우 강함';
    } else {
      return '자외선 위험, 외출 자제!';
    }
  }
}
