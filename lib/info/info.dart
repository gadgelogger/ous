// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
// Project imports:
import 'package:ous/NavBar.dart';
import 'package:ous/analytics_service.dart';
import 'package:ous/info/2.dart';
import 'package:ous/info/3.dart';
import 'package:ous/info/4.dart';
import 'package:ous/info/5.dart';
import 'package:ous/info/7.dart';
import 'package:ous/info/all.dart';
import 'package:ous/info/dev_info.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          elevation: 0,
          title: const Text('ニュース'),
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            tabs: const [
              Text(
                '全て',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              Text(
                '重要',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              Text(
                '開発者から',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              Text(
                'お知らせ',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              Text(
                '学科レポート',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              Text(
                '理大レポート',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              Text(
                'キャリア支援センター',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
        body: const PopScope(
          canPop: false,
          child: TabBarView(
            children: [
              All(),
              Important(),
              DevInfo(),
              News(),
              Departmentreport(),
              Report(),
              Business(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Analytics
    AnalyticsService().setCurrentScreen(AnalyticsServiceScreenName.info);
  }
}
