// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';

// Project imports:
import 'package:ous/constant/urls.dart';
import 'package:ous/gen/assets.gen.dart';
import 'package:ous/infrastructure/bus_api.dart';
import 'package:ous/infrastructure/config/analytics_service.dart';
import 'package:ous/infrastructure/mylog_monitor_api.dart';
import 'package:ous/presentation/widgets/home/bus_info_button.dart';
import 'package:ous/presentation/widgets/home/mylog_status_button.dart';
import '../../widgets/drawer/drawer.dart';

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
                width: 500.w,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? Assets.images.homedark.path
                        : Assets.images.home.path,
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'バス運行情報',
                        style: TextStyle(
                          fontSize: 30.sp,
                        ),
                      ),
                      const Row(
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
                      const Row(
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: [
                      Text('マイログ稼働状況', style: TextStyle(fontSize: 30.sp)),
                      SizedBox(height: 10.h),
                      const MyLogStatusButton(),
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
