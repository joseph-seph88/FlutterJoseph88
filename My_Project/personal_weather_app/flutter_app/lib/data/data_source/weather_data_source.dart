import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WeatherDataSource extends GetxService {
  final String _apiKey = dotenv.env['WEATHER_API_KEY'] ?? 'default_value';

  Future<Map<String, dynamic>> fetchForecast(String city) async {
    try {
      final url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$_apiKey&units=metric&lang=kr");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('[DS] fetchForecast Error');
      }
    } catch (e) {
      throw Exception('[DS] fetchForecast Error ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getUvIndex(String city) async {
    try {
      final geoData = await _getGeo(city);
      final double lat = geoData['lat'];
      final double lon = geoData['lon'];

      final uvUrl = Uri.parse(
          'https://api.openweathermap.org/data/2.5/uvi?lat=$lat&lon=$lon&appid=$_apiKey');
      final uvResponse = await http.get(uvUrl);

      if (uvResponse.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(uvResponse.body);
        return jsonResponse;
      } else {
        throw Exception('[DS] getUvIndex Error');
      }
    } catch (e) {
      throw Exception('[DS] getUvIndex Error ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> _getGeo(String city) async {
    try {
      final geoUrl = Uri.parse(
          'https://api.openweathermap.org/geo/1.0/direct?q=$city&limit=1&appid=$_apiKey');
      final geoResponse = await http.get(geoUrl);
      if (geoResponse.statusCode == 200) {
        final geoData = jsonDecode(geoResponse.body);
        final Map<String, dynamic> geoList = geoData[0];
        return geoList;
      } else {
        throw Exception('[DS] getGeo Error');
      }
    } catch (e) {
      throw Exception('[DS] getGeo Error ${e.toString()}');
    }
  }
}
