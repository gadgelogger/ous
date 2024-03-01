// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/io_client.dart';
import 'package:url_launcher/url_launcher.dart';

class Article {
  final String url;
  final String title;
  final String date;

  const Article({
    required this.url,
    required this.title,
    required this.date,
  });
}

class Business extends StatefulWidget {
  const Business({Key? key}) : super(key: key);

  @override
  State<Business> createState() => _BusinessState();
}

class _BusinessState extends State<Business>
    with AutomaticKeepAliveClientMixin {
  List<Article> articles = [];
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          debugPrint('Loading New Data');
          await getWebsiteData();
        },
        child: Center(
          child: (articles.isEmpty)
              ? const CircularProgressIndicator()
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
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
                              fontSize: 15.sp,
                            ),
                          ),
                          onTap: () async {
                            if (await canLaunchUrl(Uri.parse(article.url))) {
                              await launchUrl(
                                Uri.parse(article.url),
                                mode: LaunchMode.platformDefault,
                              );
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
      ),
    );
  }

  Future<void> getWebsiteData() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    final http = IOClient(client);
    final response =
        await http.get(Uri.parse('https://career.office.ous.ac.jp/current'));
    final document = parser.parse(response.body);
    final posts =
        document.querySelectorAll('#main > div.newsbox > div.newsbody > div');
    final articles = posts.map((post) {
      final title = post.querySelector('a > div.posttext > div')?.text ?? '';
      final url = post.querySelector('a')?.attributes['href'] ?? '';
      final date = post.querySelector('a > div.postdate')?.text ?? '';
      return Article(title: title, url: url, date: date);
    }).toList();
    setState(() {
      this.articles = articles;
    });
  }

  @override
  void initState() {
    super.initState();
    getWebsiteData();
  }
}
