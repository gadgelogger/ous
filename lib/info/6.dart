
import 'package:html/dom.dart' as UserModel;
import "package:universal_html/controller.dart";
import 'package:flutter/material.dart';
import 'package:universal_html/parsing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';



class movie extends StatefulWidget {
  const movie({Key? key}) : super(key: key);

  @override
  State<movie> createState() => _movieState();
}

class _movieState extends State<movie> {
  List<Article> articles = [];
  @override
  void initState(){
    super .initState();
    getWebsiteData();


  }
  Future getWebsiteData() async {
    final controller = WindowController();
    await controller.openHttp(
      method: 'GET',
      uri: Uri.parse('https://www.youtube.com/channel/UCMuC2oINOXry-Ya6Lw7Pu4Q/videos'),
    );
    final document = controller.window!.document;

    final titles = document
        .querySelectorAll('title')
        .map((element) => element.innerText)
        .toList();

    final urls = document
        .querySelectorAll("dl > dd > a  ")
        .map((element) => 'https://www.ous.ac.jp${element.getAttribute("href")}')
        .toList();
    final dates = document
        .querySelectorAll("div > .p10 > dt")
        .map((element) => element.innerText)
        .toList();

    setState((){
      articles = List.generate(
        titles.length,
            (index) => Article(
          title: titles[index],
          url: urls[index],
          date:dates[index],
        ),
      );
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            print('Loading New Data');
            await getWebsiteData();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Column(
                children:[
                  ListTile(
                    title: Text(article.title),
                    subtitle: Text(article.url.replaceAll('./detail', '/detail')),
                    onTap: () => launch(article.url),

                  ),
                  Divider(),//区切り線
                ],
              );
            },
          ),
        )
    );
  }
}


class Article {
  final String url;
  final String title;

  const Article({
    required this.url,
    required this.title, required String date,

  });
}



