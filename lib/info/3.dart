
import 'package:html/dom.dart' as UserModel;
import "package:universal_html/controller.dart";
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class news extends StatefulWidget {
  const news({Key? key}) : super(key: key);

  @override
  State<news> createState() => _newsState();
}

class _newsState extends State<news> {
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
      uri: Uri.parse('https://www.ous.ac.jp/topics/?cat=2'),
    );
    final document = controller.window!.document;

    final titles = document
        .querySelectorAll("dl > dd >a")
        .map((element) => element.innerText)
        .toList();

    final urls = document
        .querySelectorAll("dl > dd > a  ")
        .map((element) => 'https://www.ous.ac.jp/topics/${element.getAttribute("href")}')
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
          },          child: ListView.builder(
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



