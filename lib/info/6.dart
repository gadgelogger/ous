
import 'package:html/dom.dart' as UserModel;
import "package:universal_html/controller.dart";
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



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
    print('Loading New Data');
    final controller = WindowController();
    await controller.openHttp(
      method: 'GET',
      uri: Uri.parse('https://www.youtube.com/channel/UCMuC2oINOXry-Ya6Lw7Pu4Q/videos'),
    );
    final document = controller.window!.document;

    final titles = document
        .querySelectorAll("ytd-grid-video-renderer < div< h3 < a")
        .map((element) => element.id)
        .toList();

    final urls = document
        .querySelectorAll("ytd-grid-video-renderer < div < h3 < a")
        .map((element) => element.id)
        .toList();
    print('Count: ${titles.length}');

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
                    subtitle: Text(article.url.replaceAll('./detail', '/detail')),
                    onTap: () => launch(article.url.replaceAll('./detail', '/detail')),

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
    required this.title,

  });
}



