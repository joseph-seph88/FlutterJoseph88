import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WeatherDataSource extends GetxService {
  final String _apiKey = dotenv.env['WEATHER_API_KEY'] ?? 'default_value';
  final String _city = "Seoul";

  Future<http.Response> fetchWeather() async {
    try {
      final url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$_apiKey&units=metric&lang=kr");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('[DS] FetchWeather Error');
      }
    } catch (e) {
      throw Exception('[DS] FetchWeather Error ${e.toString()}');
    }
  }

  Future<http.Response> fetchForecast(String city) async {
    try {
      final url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$_apiKey&units=metric&lang=kr");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('[DS] fetchForecast Error');
      }
    } catch (e) {
      throw Exception('[DS] fetchForecast Error ${e.toString()}');
    }
  }

  Future<http.Response> getGeo(String city) async {
    try {
      final geoUrl = Uri.parse(
          'https://api.openweathermap.org/geo/1.0/direct?q=$city&limit=1&appid=$_apiKey');
      final geoResponse = await http.get(geoUrl);
      if (geoResponse.statusCode == 200) {
        return geoResponse;
      } else {
        throw Exception('[DS] getGeo Error');
      }
    } catch (e) {
      throw Exception('[DS] getGeo Error ${e.toString()}');
    }
  }

  Future<http.Response> getUvIndex(String city) async {
    try {
      final geoResponse = await getGeo(city);
      final List<dynamic> geoData = jsonDecode(geoResponse.body);
      if (geoData.isNotEmpty) {
        final double lat = geoData[0]['lat'];
        final double lon = geoData[0]['lon'];

        final uvUrl = Uri.parse(
            'https://api.openweathermap.org/data/2.5/uvi?lat=$lat&lon=$lon&appid=$_apiKey');
        final uvResponse = await http.get(uvUrl);

        if (uvResponse.statusCode == 200) {
          return uvResponse;
        } else {
          throw Exception('[DS] getUvIndex Error');
        }
      } else {
        throw Exception('[DS] getUvIndex Error');
      }
    } catch (e) {
      throw Exception('[DS] getUvIndex Error ${e.toString()}');
    }
  }
}
