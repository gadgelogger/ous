// Dart imports:
import 'dart:io';

// Package imports:
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
// Project imports:
import 'package:ous/analytics_service.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:xml/xml.dart';

import 'NavBar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _current = 0;
  int counter = 0;

  dynamic weatherData;
  dynamic weatherData1;

  //Mylogの監視
  String? _title;

  String? _pubDate;

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
                  'https://apps.apple.com/jp/app/%E5%B2%A1%E7%90%86%E3%82%A2%E3%83%97%E3%83%AA/id1671546931',
                );
              },
            ),
          if (Platform.isAndroid)
            IconButton(
              icon: const Icon(Icons.ios_share),
              onPressed: () {
                Share.share(
                  'https://play.google.com/store/apps/details?id=com.ous.unoffical.app',
                );
              },
            ),
        ],
      ),
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 500.0.w,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'assets/images/homedark.jpeg'
                        : 'assets/images/home.jpg',
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: [
                      Text(
                        'バス運行情報',
                        style: TextStyle(
                          fontSize: 30.sp,
                        ),
                      ),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 80.h,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: false,
                          reverse: false,
                          autoPlay: false,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        items: [
                          //岡山駅西口発と理大正門発
                          Row(
                            children: [
                              ButtonBar(
                                children: [
                                  SizedBox(
                                    width: 178.w, //横幅
                                    height: 50.h, //高さ
                                    child: FilledButton.tonal(
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        // Foreground color
                                        // Background color
                                      ),
                                      onPressed: () {
                                        launchUrlString(
                                          'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=224&stopCdTo=763&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0',
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const FittedBox(
                                            child: Text(
                                              '岡山駅西口発',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          FutureBuilder<String>(
                                            future: fetchApproachCaption(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                var approachCaption =
                                                    snapshot.data;
                                                if (approachCaption!
                                                    .contains('あと')) {
                                                  return Text(approachCaption);
                                                } else {
                                                  var index = approachCaption
                                                      .indexOf(':');
                                                  var time = approachCaption
                                                      .substring(0, index + 3);
                                                  return Text(time);
                                                }
                                              } else if (snapshot.hasError) {
                                                return const Text("error");
                                              }
                                              return SizedBox(
                                                height: 20.h,
                                                width: 20.w,
                                                child:
                                                    const CircularProgressIndicator(),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 178.w, //横幅
                                    height: 50.h, //高さ
                                    child: FilledButton.tonal(
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        // Foreground color
                                        // Background color
                                      ),
                                      onPressed: () => launchUrlString(
                                        'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=763&stopCdTo=224&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0',
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const FittedBox(
                                            child: Text(
                                              '岡山理科大学正門発',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          FutureBuilder<String>(
                                            future: fetchApproachCaption1(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                var approachCaption =
                                                    snapshot.data;
                                                if (approachCaption!
                                                    .contains('あと')) {
                                                  var index = approachCaption
                                                      .indexOf('で到着予定');
                                                  var time =
                                                      approachCaption.substring(
                                                    0,
                                                    index,
                                                  );
                                                  return Text(time);
                                                } else {
                                                  var index = approachCaption
                                                      .indexOf(':');
                                                  var time =
                                                      approachCaption.substring(
                                                    0,
                                                    index + 3,
                                                  );
                                                  return Text(time);
                                                }
                                              } else if (snapshot.hasError) {
                                                return const Text("error");
                                              }
                                              return SizedBox(
                                                height: 20.h,
                                                width: 20.w,
                                                child:
                                                    const CircularProgressIndicator(),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //天満屋発と岡山理科大学発
                          Row(
                            children: [
                              ButtonBar(
                                children: [
                                  SizedBox(
                                    width: 178.w, //横幅
                                    height: 50.h, //高さ
                                    child: FilledButton.tonal(
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        // Foreground color
                                        // Background color
                                      ),
                                      onPressed: () {
                                        launchUrlString(
                                          'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=27&stopCdTo=768&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0',
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const FittedBox(
                                            child: Text(
                                              '岡山天満屋発',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          FutureBuilder<String>(
                                            future: fetchApproachCaption2(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                var approachCaption =
                                                    snapshot.data;
                                                if (approachCaption!
                                                    .contains('あと')) {
                                                  return Text(approachCaption);
                                                } else {
                                                  var index = approachCaption
                                                      .indexOf(':');
                                                  var time = approachCaption
                                                      .substring(0, index + 3);
                                                  return Text(time);
                                                }
                                              } else if (snapshot.hasError) {
                                                return const Text("error");
                                              }
                                              return SizedBox(
                                                height: 20.h,
                                                width: 20.w,
                                                child:
                                                    const CircularProgressIndicator(),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 178.w, //横幅
                                    height: 50.h, //高さ
                                    child: FilledButton.tonal(
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () => launchUrlString(
                                        'https://loc.bus-vision.jp/ryobi/view/approach.html?returnCdFrom=768&returnCdTo=27&returnHour=&returnMinute=&returnAD=-1&returnVehicleTypeCd=&returnCorpCd=&lang=0',
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const FittedBox(
                                            child: Text(
                                              '岡山理科大学東門発',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          FutureBuilder<String>(
                                            future: fetchApproachCaption3(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                var approachCaption =
                                                    snapshot.data;
                                                if (approachCaption!
                                                    .contains('あと')) {
                                                  var index = approachCaption
                                                      .indexOf('で到着予定');
                                                  var time =
                                                      approachCaption.substring(
                                                    0,
                                                    index,
                                                  );
                                                  return Text(time);
                                                } else {
                                                  var index = approachCaption
                                                      .indexOf(':');
                                                  var time =
                                                      approachCaption.substring(
                                                    0,
                                                    index + 3,
                                                  );
                                                  return Text(time);
                                                }
                                              } else if (snapshot.hasError) {
                                                return const Text("error");
                                              }
                                              return SizedBox(
                                                height: 20.h,
                                                width: 20.w,
                                                child:
                                                    const CircularProgressIndicator(),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          2, // ここは CarouselSlider のスライド数に合わせてください
                          (index) => Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 2.0,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? const Color.fromRGBO(
                                      0,
                                      0,
                                      0,
                                      0.9,
                                    ) // 選択中のドットの色
                                  : const Color.fromRGBO(
                                      0,
                                      0,
                                      0,
                                      0.4,
                                    ), // 非選択のドットの色
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: [
                      Text(
                        'マイログ稼働状況',
                        style: TextStyle(
                          fontSize: 30.sp,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          ButtonBar(
                            children: [
                              SizedBox(
                                width: 178.w, //横幅
                                height: 180.h, //高さ
                                child: FilledButton.tonal(
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    // Foreground color
                                    // Background color
                                  ),
                                  onPressed: () {
                                    final url = Uri.parse(
                                      'https://stats.uptimerobot.com/4KzW2hJvY6',
                                    );

                                    launchUrl(url);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FittedBox(
                                        child: Text(
                                          'PC版',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          '$_title',
                                          style: const TextStyle(
                                            fontSize: 19,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Text(
                                        '$_pubDate',
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 178.w, //横幅
                                height: 180.h, //高さ
                                child: FilledButton.tonal(
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    // Foreground color
                                    // Background color
                                  ),
                                  onPressed: () {
                                    final url = Uri.parse(
                                      'https://stats.uptimerobot.com/4KzW2hJvY6',
                                    );

                                    launchUrl(url);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FittedBox(
                                        child: Text(
                                          'スマホ版',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          '$_title',
                                          style: const TextStyle(
                                            fontSize: 19,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Text(
                                        '$_pubDate',
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //岡山駅
  Future<String> fetchApproachCaption() async {
    final response = await http.get(
      Uri.parse(
        'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=224&stopCdTo=763&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0',
      ),
    );

    if (response.statusCode == 200) {
      var document = parse(response.body);
      var approachCaption = document.getElementsByClassName('approachCaption');

      if (approachCaption.isNotEmpty) {
        return approachCaption[0].text.trim();
      } else {
        return '終了';
      }
    } else {
      throw Exception('Error');
    }
  }

//理大
  Future<String> fetchApproachCaption1() async {
    final response = await http.get(
      Uri.parse(
        'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=763&stopCdTo=224&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0',
      ),
    );

    if (response.statusCode == 200) {
      var document = parse(response.body);
      var approachCaption = document.getElementsByClassName('approachCaption');

      if (approachCaption.isNotEmpty) {
        return approachCaption[0].text.trim();
      } else {
        return '終了';
      }
    } else {
      throw Exception('Error');
    }
  }

//天満屋→岡山理科大学
  Future<String> fetchApproachCaption2() async {
    final response = await http.get(
      Uri.parse(
        'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=27&stopCdTo=768&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0',
      ),
    );

    if (response.statusCode == 200) {
      var document = parse(response.body);
      var approachCaption = document.getElementsByClassName('approachCaption');

      if (approachCaption.isNotEmpty) {
        return approachCaption[0].text.trim();
      } else {
        return '終了';
      }
    } else {
      throw Exception('Error');
    }
  }

//岡山理科大学→天満屋
  Future<String> fetchApproachCaption3() async {
    final response = await http.get(
      Uri.parse(
        'https://loc.bus-vision.jp/ryobi/view/approach.html?returnCdFrom=768&returnCdTo=27&returnHour=&returnMinute=&returnAD=-1&returnVehicleTypeCd=&returnCorpCd=&lang=0',
      ),
    );

    if (response.statusCode == 200) {
      var document = parse(response.body);
      var approachCaption = document.getElementsByClassName('approachCaption');

      if (approachCaption.isNotEmpty) {
        return approachCaption[0].text.trim();
      } else {
        return '終了';
      }
    } else {
      throw Exception('Error');
    }
  }

  //アプリレビュー
  Future<void> incrementCounterAndRequestReview() async {
    //カウントアップさせて保存
    final prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    await prefs.setInt('counter', counter);
    //レビュー表示させる処理
    if (counter % 10 == 0) {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    mylogMonitor();
    incrementCounterAndRequestReview();
    AnalyticsService().setCurrentScreen(AnalyticsServiceScreenName.home);
  }

  Future<void> mylogMonitor() async {
    try {
      var dio = Dio();
      dio.options.headers['Authorization'] =
          'Bearer glsa_gPHPHakicrtftk0xZ4iiDHOlD3kzYivC_478e8cde';

      Response response = await dio.get(
        'https://rss.uptimerobot.com/u1289833-0ef9796d57788bd318da8c890c598a93',
      );

      var document = XmlDocument.parse(response.data);
      var firstItem = document.findAllElements('item').first;

      var title = firstItem.findElements('title').single.innerText;
      var pubDate = firstItem.findElements('pubDate').single.innerText;

      // 日付の整形
      DateFormat originalFormat = DateFormat('E, d MMM yyyy HH:mm:ss Z');
      DateTime dateTime = originalFormat.parse(pubDate);
      String formattedDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(dateTime);

      // ステータスメッセージの設定
      String statusMessage;
      if (title.contains('is UP')) {
        statusMessage = '正常に稼働中';
      } else if (title.contains('is DOWN')) {
        statusMessage = '障害発生中';
      } else {
        statusMessage = '不明なステータス';
      }

      setState(() {
        _title = statusMessage;
        _pubDate = formattedDate;
      });
    } catch (e) {
      setState(() {
        _title = "error";
        _pubDate = "error";
      });
    }
  }
}
