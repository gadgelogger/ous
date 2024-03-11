// Dart imports:
import 'dart:io';

import 'package:flutter/foundation.dart';
// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:ous/analytics_service.dart';
import 'package:ous/api/cliant/home/bus_api.dart';
import 'package:ous/api/cliant/home/mylog_monitor_api.dart';
import 'package:ous/constant/urls.dart';
import 'package:ous/widgets/home/bus_info_button.dart';
import 'package:ous/widgets/home/mylog_status_button.dart';
import 'package:share/share.dart';

import '../widgets/nav_bar.dart';

@override
void initState() {
  AnalyticsService().setCurrentScreen(AnalyticsServiceScreenName.home);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final BusService busService = BusService();
  final MylogMonitorApi mylogMonitorApi = MylogMonitorApi();
  final storeUrls = StoreUrls();
  final busUrls = BusUrls();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        elevation: 0,
        title: const Text('ホーム'),
        actions: [
          if (!kIsWeb && Platform.isIOS)
            IconButton(
              icon: const Icon(Icons.ios_share),
              onPressed: () {
                Share.share(
                  StoreUrls.ios,
                );
              },
            ),
          if (!kIsWeb && Platform.isAndroid)
            IconButton(
              icon: const Icon(Icons.ios_share),
              onPressed: () {
                Share.share(
                  StoreUrls.android,
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
                width: 500.0,
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
              const Card(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: [
                      Text(
                        'バス運行情報',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Row(
                        children: [
                          ButtonBar(
                            children: [
                              BusInfoButton(
                                label: '岡山駅西口発',
                                url: BusUrls.okayamaStation,
                              ),
                              BusInfoButton(
                                label: '岡山理科大学正門発',
                                url: BusUrls.okayamaRikaUniversity,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ButtonBar(
                            children: [
                              BusInfoButton(
                                label: '岡山天満屋発',
                                url: BusUrls.okayamaTenmaya,
                              ),
                              BusInfoButton(
                                label: '岡山理科大学東門発',
                                url: BusUrls.okayamaRikaUniversityEastGate,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Card(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: [
                      Text('マイログ稼働状況', style: TextStyle(fontSize: 30)),
                      SizedBox(height: 10),
                      MyLogStatusButton(),
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
}
