import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
class tutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OverBoard(
        pages: pages,
        showBullets: true,
        skipCallback: () {
          // when user select SKIP
          Navigator.pop(context);
        },
        finishCallback: () {
          // when user select NEXT
          Navigator.pop(context);
        },
      ),
    );
  }

  final pages = [
    PageModel.withChild(
        child: Padding(
            padding: EdgeInsets.only(bottom: 0.0),
            child: Column(
              children: [
                Image.asset('assets/images/mockup.PNG', width: 300.0, height: 600.0),
                Text(
                  "非公式岡理アプリ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10,),
                Text(
                  "入りたてほやほやの新入生と\n単位ギリギリの人が\n単位を取れますように。",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,

                )
              ],
            )
        ),
        color: Colors.lightGreen,
        doAnimateChild: true),
    PageModel(
        color: const Color(0xFF56BCA7),
        imageAssetPath: 'assets/icon/book.png',
        title: '豊富な講義評価',
        body: '100以上の\n講義評価をどこからでも。',
        doAnimateImage: true),

    PageModel(
        color: const Color(0xff4fadf8),
        imageAssetPath: 'assets/icon/news.png',
        title: '最新ニュース',
        body: '大学サイトよりも\n見やすく、シンプル。',
        doAnimateImage: true),
    PageModel(
        color: const Color(0xfffc7f7f),
        imageAssetPath: 'assets/icon/update.png',
        title: '機能は随時追加中',
        body: 'どんどん進化します。',
        doAnimateImage: true),
    PageModel.withChild(
        child: Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: Text(
              "さあ、始めよう！",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
              ),
            )),
        color: Colors.lightGreen,
        doAnimateChild: true)
  ];
}