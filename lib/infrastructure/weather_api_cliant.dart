import 'package:http/http.dart' as http; //分ける
import 'dart:convert';

import 'package:ous/apikey.dart';

class WeatherApiClient {
  static const _baseWeatherURL = "http://api.openweathermap.org/data/2.5";
  static const _apiKey = Weatherkey;

  final http.Client httpClient;

  WeatherApiClient({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    final url = '$_baseWeatherURL/weather?q=$city&appid=$_apiKey&lang=ja';
    final response = await httpClient.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<dynamic>> fetchWeatherForecast(String city) async {
    final url = '$_baseWeatherURL/forecast?q=$city&appid=$_apiKey';
    final response = await httpClient.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['list'] as List;
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }
}
