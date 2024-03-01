// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;
// Project imports:
import 'package:ous/apikey.dart';

class WeatherApiClient {
  String apiKey = weatherKey;
  Future<dynamic> getWeatherData(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&lang=ja';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<dynamic> getWeatherForecast(String city) async {
    final url =
        "http://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['list'];
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
//todo:dynamicはあまり使わないようにする。型を指定することでエラーを防げる
