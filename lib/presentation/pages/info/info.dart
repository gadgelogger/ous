// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:ous/infrastructure/config/analytics_service.dart';
import 'package:ous/presentation/pages/info/dev_info.dart';
import 'package:ous/presentation/widgets/info/news_page.dart';
import 'package:ous/presentation/widgets/nav_bar.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class TabInfo {
  final String title;
  final Widget widget;

  TabInfo({
    required this.title,
    required this.widget,
  });
}

class _InfoState extends State<Info> {
  final List<TabInfo> _tabs = [
    TabInfo(
      title: '全て',
      widget: const NewsPage(categoryUrl: 'https://www.ous.ac.jp/topics/?page'),
    ),
    TabInfo(
      title: '開発者からお知らせ',
      widget: const DevInfo(),
    ),
    TabInfo(
      title: '重要',
      widget: const NewsPage(
        categoryUrl: 'https://www.ous.ac.jp/topics/?cat=1&page',
      ),
    ),
    TabInfo(
      title: 'お知らせ',
      widget: const NewsPage(
        categoryUrl: 'https://www.ous.ac.jp/topics/?cat=2&page',
      ),
    ),
    TabInfo(
      title: '学科レポート',
      widget: const NewsPage(
        categoryUrl: 'https://www.ous.ac.jp/topics/?cat=7&page',
      ),
    ),
    TabInfo(
      title: '理大レポート',
      widget: const NewsPage(
        categoryUrl: 'https://www.ous.ac.jp/topics/?cat=6&page',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: const Text('ニュース'),
          bottom: TabBar(
            isScrollable: true,
            tabs: _tabs.map((tab) => Tab(text: tab.title)).toList(),
          ),
        ),
        body: TabBarView(
          children: _tabs.map((tab) => tab.widget).toList(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    AnalyticsService().setCurrentScreen(AnalyticsServiceScreenName.info);
  }
}
