import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../core/theme/custom_text_style.dart';
import '../controller/weather_controller.dart';

class WeatherView extends GetView<WeatherController> {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B0C1E),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B1B2F),
              Color(0xFF0B0C1E),
            ],
          ),
        ),
        child: RefreshIndicator(
          child: Obx(
            () => controller.isLoading.value
                ? Center(
                    child: SizedBox(
                        width: 120,
                        height: 120,
                        child: LoadingIndicator(
                            indicatorType: Indicator.pacman,
                            colors: [Colors.white])))
                : SafeArea(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(child: _buildHeader()),
                        SliverToBoxAdapter(child: _buildMainWeather()),
                        SliverToBoxAdapter(child: _buildHourlyForecast()),
                        SliverToBoxAdapter(child: _buildWeatherDetails()),
                      ],
                    ),
                  ),
          ),
          onRefresh: () async {},
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            if (controller.todayWeatherData.value == null) {
              return Container();
            }
            final weatherData = controller.todayWeatherData.value;
            DateTime? day = weatherData?.day ?? DateTime.now();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(weatherData?.city ?? "서울",
                    style: CustomTextStyle.titleMediumWhite()),
                const SizedBox(height: 5),
                Text('${day.year}년 ${day.month}월 ${day.day}일',
                    style: CustomTextStyle.subTitleWhite70()),
              ],
            );
          }),
          Row(
            children: [
              IconButton(
                  onPressed: () async{
                    controller.sendMessage();
                  },
                  icon: Icon(Icons.schedule_send)),
              PopupMenuButton<String>(
                onSelected: (value) {
                  final cityName = controller.transCityNameEng(value);
                  controller.selectedCity = cityName;
                  controller.changeWeatherData(cityName);
                },
                itemBuilder: (BuildContext context) {
                  return controller.cityList.map((String city) {
                    return PopupMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList();
                },
                icon: Icon(Icons.more_vert, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMainWeather() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        if (controller.todayWeatherData.value == null) {
          Container();
        }
        final weatherData = controller.todayWeatherData.value;
        final weatherIcon = weatherData?.weatherIcon ?? Icons.sunny;

        return Column(
          children: [
            Icon(weatherIcon, size: 120, color: Colors.yellow),
            SizedBox(height: 16),
            Text('${weatherData?.temperature}°',
                style: CustomTextStyle.bodyVeryBigWhite()),
            Text(weatherData?.weatherDescription ?? "맑음",
                style: CustomTextStyle.bodyMediumWhite70()),
            SizedBox(height: 12),
            Text(weatherData?.warningDesc ?? "오늘은 맑음",
                style: CustomTextStyle.bodySmallWhite60()),
          ],
        );
      }),
    );
  }

  Widget _buildHourlyForecast() {
    return Container(
      height: 120,
      margin: EdgeInsets.only(top: 32),
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.todayWeatherList.length,
          itemBuilder: (context, index) {
            final weather = controller.todayWeatherList[index];

            return GestureDetector(
              onTap: () => controller.todayWeatherData.value =
                  controller.todayWeatherList[index],
              child: Container(
                width: 60,
                margin: EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Text('${weather.day.day}일 ${weather.day.hour}시',
                        style: CustomTextStyle.bodyVerySmallWhite70()),
                    SizedBox(height: 8),
                    Icon(weather.weatherIcon, color: Colors.yellow, size: 24),
                    SizedBox(height: 8),
                    Text('${weather.temperature}°',
                        style: CustomTextStyle.bodyVerySmallWhite()),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Container(
      margin: EdgeInsets.only(top: 32),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(28),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Obx(
        () {
          final weatherDetail = controller.todayWeatherData.value;
          final tempDesc = weatherDetail?.tempDescription ?? '따뜻함';
          final humDesc = weatherDetail?.humidityDescription ?? '습함';
          final windDesc = weatherDetail?.windDescription ?? '선섬함';
          final uvDesc = weatherDetail?.uvDescription ?? '자외선 강함';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('날씨 상세 정보', style: CustomTextStyle.bodyLargeWhite()),
              SizedBox(height: 16),
              _buildDetailRow('체감 온도', tempDesc),
              _buildDetailRow('습도', humDesc),
              _buildDetailRow('풍속', windDesc),
              _buildDetailRow('자외선', uvDesc),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: CustomTextStyle.bodySmallWhite70()),
          Text(value, style: CustomTextStyle.bodySmallBoldWhite70()),
        ],
      ),
    );
  }
}
