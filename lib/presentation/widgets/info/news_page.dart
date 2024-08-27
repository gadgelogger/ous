import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

// 共通ウィジェット
class NewsPage extends StatefulWidget {
  final String categoryUrl;
  const NewsPage({
    Key? key,
    required this.categoryUrl,
  }) : super(key: key);

  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  List<Article> _articles = [];
  int _page = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Center(
          child: (_articles.isEmpty)
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: _articles.length + (_articles.length ~/ 5) + 1,
                  itemBuilder: (context, index) {
                    if (index % 6 == 5) {
                      return SizedBox(
                        height: 100,
                        child: AdWidget(
                          ad: BannerAd(
                            adUnitId: Platform.isAndroid
                                ? 'ca-app-pub-1882636743563952/9882211213' // Androidの広告ID
                                : 'ca-app-pub-1882636743563952/9882211213', // iOSの広告ID
                            size: AdSize.banner,
                            request: const AdRequest(),
                            listener: BannerAdListener(
                              onAdLoaded: (Ad ad) => print('Ad loaded.'),
                              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                                ad.dispose();
                                print('Ad failed to load: $error');
                              },
                              onAdClosed: (Ad ad) {
                                ad.dispose();
                              },
                            ),
                          )..load(),
                        ),
                      );
                    }

                    final articleIndex = index - (index ~/ 6);
                    if (articleIndex >= _articles.length) {
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

                    final article = _articles[articleIndex];
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
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        debugPrint('Loading URL: ${widget.categoryUrl}');
        _getWebsiteData();
      }
    });
  }

  Future<void> _getWebsiteData() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final url = "${widget.categoryUrl}=$_page";
      debugPrint('Fetching data from: $url');

      HttpClient client = HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      final http = IOClient(client);

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final titles = document
            .querySelectorAll("dl > dd > a")
            .map((element) => element.text.trim())
            .toList();
        final dates = document
            .querySelectorAll("div > .p10 > dt")
            .map((element) => element.text.trim())
            .toList();
        final urls = document.querySelectorAll("dl > dd > a").map((element) {
          var href = element.attributes["href"]!;
          if (!href.startsWith('http')) {
            href = 'https://www.ous.ac.jp$href';
          }
          return href;
        }).toList();

        final newArticles = List.generate(
          titles.length,
          (index) => Article(
            title: titles[index],
            date: dates[index],
            url: urls[index],
          ),
        );

        setState(() {
          if (_page == 1) {
            _articles = newArticles;
          } else {
            _articles.addAll(newArticles);
          }
        });
      } else {
        debugPrint('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      debugPrint('An error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _isLoading = false;
            _page++;
          });
        });
      }
    }
  }

  Future<void> _onLoadMore() async {
    if (!_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getWebsiteData();
      });
    }
  }

  Future<void> _onRefresh() async {
    _page = 1;
    _articles.clear();
    await _getWebsiteData();
  }
}
