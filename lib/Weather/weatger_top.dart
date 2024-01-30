// 再利用可能なコンポーネントを分ける
// ))などの間にカンマを入れるように警告を出すLintをつける　//教えてもらう
// 通信処理と画面のUIを分ける
// Freezedを使ってみる //教えてもらう
// fontSize: 20.sp, //themedataを使えば書き方が簡単になるので調べてみる

// weatherData['main']['temp_max'] - 273.15
// 気温を計算する部分を関数にしてあげる

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ous/apikey.dart';
import 'package:ous/component/weather_component.dart';

class Weather extends StatefulWidget {
  const Weather({
    Key? key,
    required this.city,
  }) : super(key: key);
  final String city;
  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  dynamic weatherData;
  List<dynamic> forecast = [];

  @override
  void initState() {
    super.initState();
    getWeatherData();
    getWeatherForecast();
  }

  void getWeatherData() async {
    String city = "Okayama";
    String apiKey = Weatherkey;
    String url =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&lang=ja";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        weatherData = jsonData;
      });
    }
  }

  void getWeatherForecast() async {
    String city = "Okayama";
    String apiKey = Weatherkey;
    String url =
        "http://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        forecast = jsonData['list'];
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('天気'),
        ),
        body: weatherData != null
            ? WeatherWidget(
                weatherData: weatherData,
                forecast: forecast,
                city: widget.city,
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      );
}
