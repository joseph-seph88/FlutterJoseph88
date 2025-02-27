import 'dart:io';
import 'package:flutter_app/domain/usecase/weather_useCase.dart';
import 'package:flutter_app/service/websocket_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../domain/entity/weather.dart';
import '../../service/notification_service.dart';

class WeatherController extends GetxController {
  final WeatherUseCase _useCase = Get.find<WeatherUseCase>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();
  final WebsocketService _websocketService = Get.find<WebsocketService>();

  String myId = "default";
  String otherId = "default";

  var weatherModelList = <Weather>[].obs;
  var todayWeatherList = <Weather>[].obs;
  var todayWeatherData = Rxn<Weather?>();

  var selectedCity = 'Seoul';
  var cityList = ['서울', '인천', '경기도 고양시', '대전', '부산'];
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _weatherDataInit(selectedCity);
    _notificationInit();
    _websocketInit();
  }

  void sendMessage() {
    final message = todayWeatherData.value?.warningDesc ?? "오늘 비온대요, 우산 챙기세요!";
    final sender = myId;
    final receiver = otherId;
    _websocketService.sendMessage(message, sender, receiver);
  }

  void getWeatherDataWithCity(String cityName) {
    weatherModelList.value = <Weather>[];
    todayWeatherList.value = <Weather>[];
    todayWeatherData.value = null;
    _weatherDataInit(cityName);
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

  void _weatherDataInit(String cityNames) async {
    isLoading.value = true;
    final weatherData = await _useCase.fetchForecast(cityNames);
    weatherModelList.value = weatherData;
    _getTodayWeatherList();
    _getTodayWeatherData();
    isLoading.value = false;
  }

  void _getTodayWeatherList() {
    var today = DateTime.now();
    todayWeatherList.value = weatherModelList.where((value) {
      DateTime dateOnly = DateTime(value.day.year, value.day.month);
      DateTime monthOnly = DateTime(today.year, today.month);
      return dateOnly.isAtSameMomentAs(monthOnly);
    }).toList();
  }

  void _getTodayWeatherData() {
    var today = DateTime.now();
    DateTime todayOnly = DateTime(today.year, today.month, today.day);

    todayWeatherData.value = todayWeatherList.firstWhere(
      (value) {
        DateTime dateOnly =
            DateTime(value.day.year, value.day.month, value.day.day);
        return dateOnly.isAtSameMomentAs(todayOnly);
      },
      orElse: () {
        DateTime tomorrowOnly =
            DateTime(today.year, today.month, today.day + 1);
        return todayWeatherData.value = todayWeatherList.firstWhere(
          (value) {
            DateTime dateOnly =
                DateTime(value.day.year, value.day.month, value.day.day);
            return dateOnly.isAtSameMomentAs(tomorrowOnly);
          },
        );
      },
    );
  }

  String _getClientId() {
    if (Platform.isAndroid) {
      myId = "user88";
      otherId = "user22";
      return myId;
    } else if (Platform.isIOS) {
      myId = "user22";
      otherId = "user88";
      return myId;
    }
    return "user500";
  }

  void _websocketInit() {
    _websocketService.connect().then((_) {
      String sender = _getClientId();
      _websocketService.setId(sender);
      _websocketService.startListeningForMessages();
    }).catchError((e) {
      debugPrint("웹소켓 연결 실패: ${e.toString()}");
    });
  }

  void _notificationInit() async {
    await _notificationService.initNotification();
  }
}
