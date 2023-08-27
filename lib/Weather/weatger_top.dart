import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ous/apikey.dart';

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  var weatherData;
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
            ? SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on_outlined),
                          Text('岡山')
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        DateFormat('M/d(E)HH:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                weatherData['dt'] * 1000)),
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 130.h,
                            width: 150.w,
                            child: Image.network(
                                "http://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@4x.png"),
                          ),
                          Text(
                            (weatherData['main']['temp'] - 273.15)
                                    .toStringAsFixed(0) +
                                "°",
                            style: TextStyle(
                                fontSize: 80.sp,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ],
                      ),
                      Text(
                        (weatherData['main']['temp_max'] - 273.15)
                                .toStringAsFixed(0) +
                            "°" +
                            "/" +
                            (weatherData['main']['temp_min'] - 273.15)
                                .toStringAsFixed(0) +
                            "°",
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        weatherData['weather'][0]['description'],
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  '降水量',
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                                Text(
                                  weatherData['rain'] != null
                                      ? "${weatherData['rain']['1h']}mm"
                                      : "0mm",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: 50.h, child: const VerticalDivider()),
                            Column(
                              children: [
                                Text(
                                  '湿度',
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                                Text(
                                  "${weatherData['main']['humidity']}%",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: 50.h, child: const VerticalDivider()),
                            Column(
                              children: [
                                Text(
                                  '風速',
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                                Text(
                                  "${weatherData['wind']['speed']}m/s",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: 50.h, child: const VerticalDivider()),
                            Column(
                              children: [
                                Text(
                                  '気圧',
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                                Text(
                                  "${weatherData['main']['pressure']}hPa",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: 50.h, child: const VerticalDivider()),
                            Column(
                              children: [
                                Text(
                                  '体感温度',
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                                Text(
                                  (weatherData['main']['feels_like'] - 273.15)
                                          .toStringAsFixed(0) +
                                      "°",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: 50.h, child: const VerticalDivider()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ), // 追加
                          height: 230.h,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: forecast.length,
                              itemBuilder: (context, index) {
                                String date = DateFormat('M/d').format(
                                    DateTime.parse(forecast[index]['dt_txt']));
                                return Container(
                                  width: 70,
                                  height: 150,
                                  margin: const EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      if (index == 0 ||
                                          date !=
                                              DateFormat('M/d').format(
                                                  DateTime.parse(
                                                      forecast[index - 1]
                                                          ['dt_txt'])))
                                        Text(
                                          date,
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              color: Colors.black),
                                        )
                                      else
                                        SizedBox(
                                          height: 28.h,
                                        ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background
                                              .withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              DateFormat('HH:mm').format(
                                                  DateTime.parse(forecast[index]
                                                      ['dt_txt'])),
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: Colors.black),
                                            ),
                                            Image.network(
                                              Uri.encodeFull(
                                                  "http://openweathermap.org/img/wn/${forecast[index]['weather'][0]['icon']}@2x.png"),
                                              width: 80,
                                            ),
                                            Text(
                                              "${(forecast[index]['main']['temp'] - 273.15).toStringAsFixed(0)}°",
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ))
                    ],
                  ),
                ),
              ))
            : const Center(
                child: CircularProgressIndicator(),
              ),
      );
}

class Imabari extends StatefulWidget {
  const Imabari({Key? key}) : super(key: key);

  @override
  State<Imabari> createState() => _ImabariState();
}

class _ImabariState extends State<Imabari> {
  var weatherData;
  List<dynamic> forecast = [];

  @override
  void initState() {
    super.initState();
    getWeatherData();
    getWeatherForecast();
  }

  void getWeatherData() async {
    String city = "Aichi-ken";
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
    String city = "Aichi-ken";
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
            ? SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.location_on_outlined), Text('今治')],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      DateFormat('M/d(E)HH:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              weatherData['dt'] * 1000)),
                      style: TextStyle(
                        fontSize: 20.sp,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 130.h,
                          width: 150.w,
                          child: Image.network(
                              "http://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@4x.png"),
                        ),
                        Text(
                          (weatherData['main']['temp'] - 273.15)
                                  .toStringAsFixed(0) +
                              "°",
                          style: TextStyle(
                              fontSize: 80.sp,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                    Text(
                      (weatherData['main']['temp_max'] - 273.15)
                              .toStringAsFixed(0) +
                          "°" +
                          "/" +
                          (weatherData['main']['temp_min'] - 273.15)
                              .toStringAsFixed(0) +
                          "°",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      weatherData['weather'][0]['description'],
                      style: TextStyle(
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                '降水量',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                              Text(
                                weatherData['rain'] != null
                                    ? "${weatherData['rain']['1h']}mm"
                                    : "0mm",
                                style: TextStyle(
                                  fontSize: 30.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: 50.h, child: const VerticalDivider()),
                          Column(
                            children: [
                              Text(
                                '湿度',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                              Text(
                                "${weatherData['main']['humidity']}%",
                                style: TextStyle(
                                  fontSize: 30.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: 50.h, child: const VerticalDivider()),
                          Column(
                            children: [
                              Text(
                                '風速',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                              Text(
                                "${weatherData['wind']['speed']}m/s",
                                style: TextStyle(
                                  fontSize: 30.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: 50.h, child: const VerticalDivider()),
                          Column(
                            children: [
                              Text(
                                '気圧',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                              Text(
                                "${weatherData['main']['pressure']}hPa",
                                style: TextStyle(
                                  fontSize: 30.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: 50.h, child: const VerticalDivider()),
                          Column(
                            children: [
                              Text(
                                '体感温度',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                              Text(
                                (weatherData['main']['feels_like'] - 273.15)
                                        .toStringAsFixed(0) +
                                    "°",
                                style: TextStyle(
                                  fontSize: 30.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: 50.h, child: const VerticalDivider()),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ), // 追加
                        height: 230.h,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: forecast.length,
                            itemBuilder: (context, index) {
                              String date = DateFormat('M/d').format(
                                  DateTime.parse(forecast[index]['dt_txt']));
                              return Container(
                                width: 70,
                                height: 150,
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    if (index == 0 ||
                                        date !=
                                            DateFormat('M/d').format(
                                                DateTime.parse(
                                                    forecast[index - 1]
                                                        ['dt_txt'])))
                                      Text(
                                        date,
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            color: Colors.black),
                                      )
                                    else
                                      SizedBox(
                                        height: 28.h,
                                      ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background
                                            .withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            DateFormat('HH:mm').format(
                                                DateTime.parse(
                                                    forecast[index]['dt_txt'])),
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                color: Colors.black),
                                          ),
                                          Image.network(
                                            Uri.encodeFull(
                                                "http://openweathermap.org/img/wn/${forecast[index]['weather'][0]['icon']}@2x.png"),
                                            width: 80,
                                          ),
                                          Text(
                                            "${(forecast[index]['main']['temp'] - 273.15).toStringAsFixed(0)}°",
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ))
                  ],
                ),
              ))
            : const Center(
                child: CircularProgressIndicator(),
              ),
      );
}
