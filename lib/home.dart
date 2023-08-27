import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:ous/Weather/weatger_top.dart';
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx/webviewx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:calendar_timeline/calendar_timeline.dart';
import 'Nav/Calendar/calender.dart';
import 'NavBar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'apikey.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  var weatherData;
  var weatherData1;

  @override
  void initState() {
    super.initState();
    getWeatherData();
    getWeatherData1();
  }

  //天気予報　岡山
  void getWeatherData() async {
    String city = "Okayama";
    String url =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${Weatherkey}&lang=ja";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        weatherData = jsonData;
      });
    }
    print(url);
  }

  void getWeatherData1() async {
    String city = "Aichi-ken";
    String url =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${Weatherkey}&lang=ja";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        weatherData1 = jsonData;
      });
    }
    print(url);
  }

//岡山駅
  Stream<String> fetchApproachCaption() async* {
    while (true) {
      final response = await http.get(Uri.parse(
          'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=224&stopCdTo=763&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0'));

      if (response.statusCode == 200) {
        var document = parse(response.body);
        var approachCaption =
            document.getElementsByClassName('approachCaption');

        if (approachCaption.isNotEmpty) {
          yield approachCaption[0].text.trim();
        } else {
          yield '終了';
        }
      } else {
        throw Exception('Failed to load data');
      }

      await Future.delayed(Duration(seconds: 10));
    }
  }

//理大
  Stream<String> fetchApproachCaption1() async* {
    while (true) {
      final response = await http.get(Uri.parse(
          'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=763&stopCdTo=224&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0'));

      if (response.statusCode == 200) {
        var document = parse(response.body);
        var approachCaption =
            document.getElementsByClassName('approachCaption');

        if (approachCaption.isNotEmpty) {
          yield approachCaption[0].text.trim();
        } else {
          yield '終了';
        }
      } else {
        throw Exception('Failed to load data');
      }

      await Future.delayed(const Duration(seconds: 10));
    }
  }

  Future<void> addRandomIdToAllDocuments() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('zyuui').get();
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        querySnapshot.docs;
    final WriteBatch batch = FirebaseFirestore.instance.batch();

    for (QueryDocumentSnapshot<Map<String, dynamic>> document in documents) {
      batch.update(document.reference, {'ID': const Uuid().v4()});
    }

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ja_JP');
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        elevation: 0,
        title: const Text('ホーム'),
        actions: [
          if (Platform.isIOS)
            IconButton(
                icon: const Icon(Icons.ios_share),
                onPressed: () {
                  Share.share(
                      'https://apps.apple.com/jp/app/%E5%B2%A1%E7%90%86%E3%82%A2%E3%83%97%E3%83%AA/id1671546931');
                }),
          if (Platform.isAndroid)
            IconButton(
                icon: const Icon(Icons.ios_share),
                onPressed: () {
                  Share.share(
                      'https://play.google.com/store/apps/details?id=com.ous.unoffical.app');
                }),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: SingleChildScrollView(
            child: Column(children: [
          Stack(
            children: [
              SizedBox(
                width: 500.0.w,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'assets/images/homedark.jpeg'
                        : 'assets/images/home.jpg',
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 20,
                child: weatherData != null
                    ? Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const Weather(),
                              ));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '岡山',
                                      style: TextStyle(
                                          fontSize: 15.sp, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 50.h,
                                      width: 50.w,
                                      child: Image.network(
                                          "http://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@2x.png"),
                                    ),
                                    Text(
                                      (weatherData['main']['temp'] - 273.15)
                                              .toStringAsFixed(0) +
                                          "°C",
                                      style: TextStyle(
                                          fontSize: 15.sp, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              Positioned(
                top: 60,
                right: 20,
                child: weatherData1 != null
                    ? Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const imabari(),
                              ));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '今治',
                                      style: TextStyle(
                                          fontSize: 15.sp, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 50.h,
                                      width: 50.w,
                                      child: Image.network(
                                          "http://openweathermap.org/img/wn/${weatherData1['weather'][0]['icon']}@2x.png"),
                                    ),
                                    Text(
                                      (weatherData1['main']['temp'] - 273.15)
                                              .toStringAsFixed(0) +
                                          "°C",
                                      style: TextStyle(
                                          fontSize: 15.sp, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          ),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            GestureDetector(
              onDoubleTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => CalendarPage(),
                ));
              },
              child: CalendarTimeline(
                initialDate: DateTime.now(),
                firstDate: DateTime(2023, 1, 1),
                lastDate: DateTime(2023, 12, 31),
                onDateSelected: (date) => print(date),
                leftMargin: 20,
                monthColor: Colors.blueGrey,
                dayColor: Theme.of(context).colorScheme.primary,
                activeDayColor: Colors.white,
                activeBackgroundDayColor: Theme.of(context).colorScheme.primary,
                dotsColor: const Color(0xFF333A47),
                // 日本語ロケールを指定する
                locale: 'ja',
              ),
            ),
            Text(
              'バス運行情報',
              style: TextStyle(
                fontSize: 30.sp,
              ),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ButtonBar(children: [
              SizedBox(
                width: 180.w, //横幅
                height: 50.h, //高さ
                child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Foreground color
                      // Background color
                    ),
                    onPressed: () {
                      launch(
                          'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=224&stopCdTo=763&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '岡山駅西口発',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        StreamBuilder<String>(
                          stream: fetchApproachCaption(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var approachCaption = snapshot.data;
                              if (approachCaption!.contains('あと')) {
                                return Text(approachCaption);
                              } else {
                                var index = approachCaption.indexOf(':');
                                var time =
                                    approachCaption.substring(0, index + 3);
                                return Text(time);
                              }
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            return SizedBox(
                                height: 30.h,
                                width: 30.w,
                                child: const CircularProgressIndicator());
                          },
                        ),
                      ],
                    )),
              ),
              SizedBox(
                width: 180.w, //横幅
                height: 50.h, //高さ
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // Foreground color
                    // Background color
                  ),
                  onPressed: () => launch(
                      'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=763&stopCdTo=224&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '岡山理科大学\正門発',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<String>(
                        stream: fetchApproachCaption1(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var approachCaption = snapshot.data;
                            if (approachCaption!.contains('あと')) {
                              var index = approachCaption.indexOf('で到着予定');
                              var time = approachCaption.substring(0, index);
                              return Text(time);
                            } else {
                              var index = approachCaption.indexOf(':');
                              var time =
                                  approachCaption.substring(0, index + 3);
                              return Text(time);
                            }
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return SizedBox(
                              height: 30.h,
                              width: 30.w,
                              child: const CircularProgressIndicator());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ]),
          GestureDetector(
            onTap: () {},
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'マイログ稼働情報',
                style: TextStyle(
                  fontSize: 30.sp,
                ),
              ),
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: WebViewAware(
                    child: GestureDetector(
                      onTap: () {
                        launch(
                            'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=763&stopCdTo=224&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0');
                      },
                      child: WebViewX(
                        width: 400.w,
                        height: 400.h,
                        initialContent:
                            'https://stats.uptimerobot.com/4KzW2hJvY6',
                        initialSourceType: SourceType.url,
                      ),
                    ),
                  ))
            ]),
          )
        ])),
      ),
    );
  }
}
