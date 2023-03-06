
import 'package:gallery_saver/files.dart';
import 'package:html/dom.dart' as UserModel;
import 'package:html/parser.dart';
import 'package:path/path.dart';
import "package:universal_html/controller.dart";
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class all extends StatefulWidget {
  const all({Key? key}) : super(key: key);

  @override
  State<all> createState() => _allState();
}

class _allState extends State<all> {
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
      uri: Uri.parse('https://www.ous.ac.jp/topics/'),
    );
    final document = controller.window!.document;

    final titles = document
        .querySelectorAll("dl > dd >a")
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
          child: Center(
              child: (articles == null || articles.length == 0)?
              CircularProgressIndicator():
              ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Column(
                    children:[
                      ListTile(
                        title: Text(article.title),
                        subtitle: Text(article.date.substring(0,10),style: TextStyle(color: Colors.lightGreen,fontWeight: FontWeight.bold),),

                        onTap: (){
                          launch(article.url);
                        }


                      ),
                      Divider(),
                      //区切り線
                    ],
                  );
                },
              ),
          ),
        )
    );
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

