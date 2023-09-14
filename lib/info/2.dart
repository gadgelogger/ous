import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:universal_html/controller.dart";
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Important extends StatefulWidget {
  const Important({Key? key}) : super(key: key);

  @override
  State<Important> createState() => _ImportantState();
}

class _ImportantState extends State<Important>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<Article> articles = [];
  @override
  void initState() {
    super.initState();
    getWebsiteData();
  }

  Future getWebsiteData() async {
    final controller = WindowController();
    await controller.openHttp(
      method: 'GET',
      uri: Uri.parse('https://www.ous.ac.jp/topics/?cat=1'),
    );
    final document = controller.window.document;

    final titles = document
        .querySelectorAll("dl > dd >a")
        .map((element) => element.innerText)
        .toList();

    final urls = document.querySelectorAll("dl > dd > a").map((element) {
      var href = element.getAttribute("href")!;
      // リンクが相対パスの場合、絶対URLに変換する
      if (!href.startsWith('http')) {
        href = 'https://www.ous.ac.jp$href';
      }
      return href;
    }).toList();

    final dates = document
        .querySelectorAll("div > .p10 > dt")
        .map((element) => element.innerText)
        .toList();

    setState(() {
      articles = List.generate(
        titles.length,
        (index) {
          if (!titles[index]
              .toLowerCase()
              .contains('【まとめ】新型コロナウイルス感染症に関する特設ページ')) {
            return Article(
              title: titles[index],
              url: urls[index],
              date: dates[index],
            );
          }
        },
      ).where((element) => element != null).cast<Article>().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        print('Loading New Data');
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
