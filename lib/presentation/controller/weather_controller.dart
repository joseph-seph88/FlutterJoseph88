import 'dart:convert';
import 'package:api_project/service/notification_service.dart';
import 'package:api_project/data/model/weather.dart';
import 'package:api_project/data/data_source/weather_data_source.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class WeatherController extends GetxController {
  final WeatherDataSource _dataSource = Get.find<WeatherDataSource>();
  final NotificationService _notificationService = Get.find<NotificationService>();

  final uuid = Uuid();

  var weatherModelList = <Weather>[].obs;
  var todayWeatherList = <Weather>[].obs;
  var todayWeatherData = Rx<Weather?>(null);

  var selectedCity = 'Seoul';
  var cityList = ['서울', '인천', '경기도 고양시', '대전', '부산'];
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initWeatherData(selectedCity);
    notificationInit();
  }

  void notificationInit() async {
    await _notificationService.initNotification();
  }

  void pushNotification(String body) async {
    final String title = "오늘 날씨 정보";
    int index = DateTime.now().millisecondsSinceEpoch.remainder(1000000);
    await _notificationService.showInstanceNotification(title, body, index);
  }

  void changeWeatherData(String selectedCity) {
    weatherModelList.value = <Weather>[];
    todayWeatherList.value = <Weather>[];
    todayWeatherData.value = null;
    initWeatherData(selectedCity);
  }

  void initWeatherData(String selectedCity) async {
    isLoading.value = true;
    final uvDescription = await _getUvData(selectedCity);
    final response = await _dataSource.fetchForecast(selectedCity);
    final weatherData = json.decode(response.body);
    List<dynamic> forecasts = weatherData['list'];
    final city = weatherData['city']?['name'];

    for (var forecast in forecasts) {
      var forecastDate = _transSecondToDate(forecast['dt']);
      String id = uuid.v4();

      var rain = (weatherData['rain']?['3h'] ?? 8888.0).toDouble();
      var wind = (forecast['wind']?['speed']).toDouble();
      var temper = (forecast['main']?['temp']).toDouble();
      var humidity = forecast['main']?['humidity'];
      var weatherDesc = forecast['weather']?[0]['description'];

      var weatherIcon = _transTextToIcon(weatherDesc);
      var windDesc = _getWindDescription(wind);
      var rainDesc = _getRainDescription(rain);
      var humidityDesc = _getHumidityDescription(humidity);
      var tempDesc = _getTemperatureDescription(temper);
      var warningDesc = _getWeatherWarning(weatherDesc);
      var tranCity = _transCityNameKr(city);

      var weatherDTO = Weather(
        id: id,
        day: forecastDate,
        city: tranCity,
        temperature: temper,
        windSpeed: wind,
        humidity: humidity,
        probabilityRain: rain,
        weatherDescription: weatherDesc,
        weatherIcon: weatherIcon,
        windDescription: windDesc,
        rainDescription: rainDesc,
        humidityDescription: humidityDesc,
        tempDescription: tempDesc,
        warningDesc: warningDesc,
        uvDescription: uvDescription,
      );
      weatherModelList.add(weatherDTO);
    }
    _getTodayWeatherData();
    isLoading.value = false;
  }

  Future<String> _getUvData(String selectedCity) async {
    final uvResponse = await _dataSource.getUvIndex(selectedCity);
    final uvData = json.decode(uvResponse.body);
    final uvDescription = _getUvDescription(uvData['value']);
    return uvDescription;
  }

  void _getTodayWeatherData() {
    var today = DateTime.now();
    todayWeatherList.value = weatherModelList.where((value) {
      return value.day.year == today.year && value.day.month == today.month;
    }).toList();

    todayWeatherData.value = todayWeatherList.where((value) {
      return value.day.day == today.day;
    }).first;
  }

  DateTime _transSecondToDate(dynamic timeStamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour);
  }

  IconData _transTextToIcon(String weatherText) {
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

  String _getWindDescription(num windSpeed) {
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

  String _getHumidityDescription(int humidity) {
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

  String _getTemperatureDescription(double temperature) {
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

  String _getRainDescription(double rain) {
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

  String _getWeatherWarning(String weather) {
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

  String _transCityNameKr(String city) {
    var cityNames = {
      'Seoul': '서울',
      'Incheon': '인천',
      'Goyang-si': '고양시',
      'Daejeon': '대전',
      'Busan': '부산',
    };

    return cityNames[city] ?? '서울';
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

  String _getUvDescription(double uvIndex) {
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
