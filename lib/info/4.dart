import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/io_client.dart';
import 'package:url_launcher/url_launcher.dart';

class Article {
  final String title;
  final String date;
  final String url;

  Article({
    required this.title,
    required this.date,
    required this.url,
  });
}

class Departmentreport extends StatefulWidget {
  @override
  _DepartmentreportState createState() => _DepartmentreportState();
}

class _DepartmentreportState extends State<Departmentreport> {
  List<Article> _articles = [];
  int _page = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getWebsiteData();
  }

  Future<void> _getWebsiteData() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    final http = new IOClient(client);

    final response = await http
        .get(Uri.parse('https://www.ous.ac.jp/topics/?cat=7&page=$_page'));
    final document = parser.parse(response.body);

    final titles = document
        .querySelectorAll("dl > dd > a")
        .map((element) => element.text)
        .toList();
    final dates = document
        .querySelectorAll("div > .p10 > dt")
        .map((element) => element.text)
        .toList();
    final urls = document.querySelectorAll("dl > dd > a").map((element) {
      var href = element.attributes["href"]!;
      // リンクが相対パスの場合、絶対URLに変換する
      if (!href.startsWith('http')) {
        href = 'https://www.ous.ac.jp$href';
      }
      return href;
    }).toList();

    final articles = List.generate(
      titles.length,
      (index) => Article(
        title: titles[index],
        date: dates[index],
        url: urls[index],
      ),
    );

    setState(() {
      if (_page == 1) {
        _articles = articles;
      } else {
        _articles.addAll(articles);
      }
      _isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    _page = 1;
    _articles.clear();
    await _getWebsiteData();
  }

  Future<void> _onLoadMore() async {
    _page++;
    await _getWebsiteData();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: _onRefresh,
      child: Center(
        child: (_articles.isEmpty)
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: _articles.length + 1,
                itemBuilder: (context, index) {
                  if (index == _articles.length) {
                    if (_isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      _onLoadMore();
                      return const Center(
                        child: LinearProgressIndicator(),
                      );
                    }
                  }
                  final article = _articles[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          article.title,
                          style: TextStyle(fontSize: 15.sp),
                        ),
                        subtitle: Text(
                          article.date.substring(0, 10),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp),
                        ),
                        onTap: () async {
                          if (await canLaunchUrl(Uri.parse(article.url))) {
                            await launchUrl(Uri.parse(article.url),
                                mode: LaunchMode.platformDefault);
                          } else {
                            throw 'Could not launch ${article.url}';
                          }
                        },
                      ),
                      const Divider(),
                      //区切り線
                    ],
                  );
                },
              ),
      ),
    ));
  }
}
