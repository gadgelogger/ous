import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:ous/account/login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class tutorial extends StatelessWidget {
  tutorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OverBoard(
        pages: pages,
        showBullets: true,
        skipCallback: () {
          // when user select SKIP
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              // 遷移先のクラス
              builder: (BuildContext context) => const Login(),
            ),
          );
        },
        finishCallback: () {
          // when user select NEXT
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              // 遷移先のクラス
              builder: (BuildContext context) => const Login(),
            ),
          );
        },
      ),
    );
  }

  final pages = [
    PageModel.withChild(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Column(
              children: [
                Image.asset('assets/images/mockup.PNG',
                    width: 250.0.w, height: 550.0.h),
                Text(
                  "非公式岡理アプリ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "入りたてほやほやの新入生と\n単位ギリギリの人が\n単位を取れますように。",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            )),
        color: Colors.lightGreen,
        doAnimateChild: true),
    PageModel.withChild(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Column(
              children: [
                Image.asset('assets/icon/book.png',
                    width: 250.0.w, height: 550.0.h),
                Text(
                  "豊富な講義評価",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "100以上の\n講義評価をどこからでも。",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            )),
        color: const Color(0xFF56BCA7),
        doAnimateChild: true),
    PageModel.withChild(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Column(
              children: [
                Image.asset('assets/icon/news.png',
                    width: 250.0.w, height: 550.0.h),
                Text(
                  "最新ニュース",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "大学サイトよりも\n見やすく、シンプル。",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            )),
        color: const Color(0xff4fadf8),
        doAnimateChild: true),
    PageModel.withChild(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Column(
              children: [
                Image.asset('assets/icon/book.png',
                    width: 250.0.w, height: 550.0.h),
                Text(
                  "機能は随時追加中",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "どんどん進化します。",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            )),
        color: const Color(0xfffc7f7f),
        doAnimateChild: true),
    PageModel.withChild(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Text(
              "さあ、始めよう！",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
              ),
            )),
        color: Colors.lightGreen,
        doAnimateChild: true)
  ];
}
