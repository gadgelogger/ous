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
    if (_isLoading) return; // 既にデータ取得中の場合は処理をスキップ
    setState(() {
      _isLoading = true; // データ取得開始
    });

    try {
      // URLにページ番号を追加して更新
      final url = "${widget.categoryUrl}=$_page";
      debugPrint('Fetching data from: $url'); // デバッグ情報としてURLを表示

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
            href = 'https://www.ous.ac.jp$href'; // 相対パスを絶対URLに変換
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
            _articles.addAll(newArticles); // 既存のリストに新しい記事を追加
          }
        });
      } else {
        // エラーハンドリング: 応答コードが200以外の場合
        debugPrint('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      // 例外が発生した場合のエラーハンドリング
      debugPrint('An error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _isLoading = false; // データ取得終了
            _page++; // 次のページを取得する準備
          });
        });
      }
    }
  }

  Future<void> _onLoadMore() async {
    if (!_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 追加のデータ取得中でなければ
        _getWebsiteData(); // 次のページのデータを取得
      });
    }
  }

  Future<void> _onRefresh() async {
    _page = 1; // リフレッシュ時は1ページ目から再取得
    _articles.clear();
    await _getWebsiteData();
  }
}
