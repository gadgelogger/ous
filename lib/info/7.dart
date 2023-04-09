
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:universal_html/controller.dart';
import 'package:url_launcher/url_launcher.dart';

class business extends StatefulWidget {
  const business({Key? key}) : super(key: key);

  @override
  State<business> createState() => _businessState();
}

class _businessState extends State<business> {
  List<Article> articles = [];
  @override
  void initState(){
    super .initState();
    getWebsiteData();


  }
  Future<void> getWebsiteData() async {
    final response = await http.get(Uri.parse('https://career.office.ous.ac.jp/current'));
    final document = parser.parse(response.body);
    final posts = document.querySelectorAll('#main > div.newsbox > div.newsbody > div');
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
                      title: Text(article.title,style: TextStyle(fontSize: 15.sp),),
                      subtitle: Text(article.date.substring(0,10),style: TextStyle(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold,fontSize: 15.sp),),
                      onTap: () => launch(article.url),

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



