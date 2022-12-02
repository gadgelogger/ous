
import 'package:html/dom.dart' as UserModel;
import "package:universal_html/controller.dart";
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class sanyo extends StatefulWidget {
  const sanyo({Key? key}) : super(key: key);

  @override
  State<sanyo> createState() => _sanyoState();
}

class _sanyoState extends State<sanyo> {
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
      uri: Uri.parse('https://www.sanyonews.jp/okayama/syuyo'),
    );
    final document = controller.window!.document;

    final titles = document
        .querySelectorAll("> div.post_body > div.post_title > a")

        .map((element) => element.innerText)
        .toList();

    final urls = document
        .querySelectorAll(" div.post_body > div.post_title > a")
        .map((element) => 'https://www.sanyonews.jp${element.getAttribute("href")}')
        .toList();


    setState((){
      articles = List.generate(
        titles.length,
            (index) => Article(
          title: titles[index],
          url: urls[index],
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
                    onTap: () => launch(article.url),

                  ),
                  Divider(),
                  //区切り線
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
    required this.title,

  });
}


