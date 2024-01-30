// 再利用可能なコンポーネントを分ける
// ))などの間にカンマを入れるように警告を出すLintをつける　//教えてもらう
// 通信処理と画面のUIを分ける
// Freezedを使ってみる //教えてもらう
// fontSize: 20.sp, //themedataを使えば書き方が簡単になるので調べてみる

// weatherData['main']['temp_max'] - 273.15
// 気温を計算する部分を関数にしてあげる

import 'package:flutter/material.dart';
import 'package:ous/component/weather_component.dart';
import 'package:ous/infrastructure/weather_api_cliant.dart';

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
  @override
  void initState() {
    super.initState();
    initWeatherData();
  }

  void initWeatherData() async {
    await WeatherApiClient().getWeatherData(widget.city);
    await WeatherApiClient().getWeatherForecast(widget.city);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('天気'),
        ),
        body: FutureBuilder(
          future: Future.wait([
            WeatherApiClient().getWeatherData(widget.city),
            WeatherApiClient().getWeatherForecast(widget.city),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasError) {
              // エラーが発生した場合の処理
              return Center(
                child: Text('エラーが発生しました: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return WeatherWidget(
                weatherData: snapshot.data?[0], // getWeatherDataから取得
                city: widget.city,
                forecast: snapshot.data?[1], // getWeatherForecastから取得
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
}
