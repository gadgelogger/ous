import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ous/NavBar.dart';
import 'package:ous/review/gakubu/keieigakubu.dart';
import 'package:ous/review/gakubu/kibankamoku.dart';
import 'package:ous/review/gakubu/kougakubu.dart';
import 'package:ous/review/gakubu/kyouikugakubu.dart';
import 'package:ous/review/gakubu/kyousyokukamoku.dart';
import 'package:ous/review/gakubu/rigakubu.dart';
import 'package:ous/review/gakubu/seibututikyuugakubu.dart';
import 'package:ous/review/gakubu/seimeikagaku.dart';
import 'package:ous/review/gakubu/zyouhourikougakubu.dart';
import 'package:ous/review/gakubu/zyuuigakubu.dart';
import 'package:ous/review/post.dart';
import 'package:ous/test/zyouhourikou.dart';
import 'package:ous/test/zyuui.dart';
import 'package:path/path.dart';

class Review extends StatelessWidget {
  const Review({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: NavBar(),
    appBar: AppBar(
          elevation: 0,
          title: Text('講義評価'),
        ),
        body: WillPopScope(
          onWillPop: ()async => false,
          child: SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                              height: 176.h,
                              width: 180.w,
                              child: Column(
                                children: [
                                  Container(

                                    decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                   child: Image.asset(
                                      'assets/images/理学部.jpg',
                                      height: 110.h,
                                      width: 200.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  ListTile(
                                    title:  Text(
                                      '理学部',
                                      style: GoogleFonts.notoSans(
                                        // フォントをnotoSansに指定(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Rigakubu()),
                          );
                        },
                      ),
                      GestureDetector(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                              height: 176.h,
                              width: 180.w,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                    child: Image.asset(
                                      'assets/images/工学部.jpg',
                                      height: 110.h,
                                      width: 180.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  ListTile(
                                    title:  Text(
                                      '工学部',
                                      style: GoogleFonts.notoSans(
                                        // フォントをnotoSansに指定(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Kougakubu()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                              height: 176.h,
                              width: 180.w,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                    child: Image.asset(
                                      'assets/images/情報理工学部.jpg',
                                      height: 110.h,
                                      width: 180.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  ListTile(
                                    title:  Text(
                                      '情報理工学部',
                                      style: GoogleFonts.notoSans(
                                        // フォントをnotoSansに指定(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => zyouhourikougakubu()),
                          );
                        },
                      ),
                      GestureDetector(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                              height: 176.h,
                              width: 180.w,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                    child: Image.asset(
                                      'assets/images/生物地球学部.jpg',
                                      height: 110.h,
                                      width: 180.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  ListTile(
                                    title:  Text(
                                      '生物地球学部',
                                      style: GoogleFonts.notoSans(
                                        // フォントをnotoSansに指定(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => seibututikyuu()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                              height: 176.h,
                              width: 180.w,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                    child: Image.asset(
                                      'assets/images/教育学部.jpg',
                                      height: 110.h,
                                      width: 180.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  ListTile(
                                    title:  Text(
                                      '教育学部',
                                      style: GoogleFonts.notoSans(
                                        // フォントをnotoSansに指定(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => kyouikugakubu()),
                          );
                        },
                      ),
                      GestureDetector(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                              height: 176.h,
                              width: 180.w,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                    child: Image.asset(
                                      'assets/images/経営学部.jpg',
                                      height: 110.h,
                                      width: 180.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  ListTile(
                                    title:  Text(
                                      '経営学部',
                                      style: GoogleFonts.notoSans(
                                        // フォントをnotoSansに指定(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => keieigakubu()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                              height: 176.h,
                              width: 180.w,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                    child: Image.asset(
                                      'assets/images/獣医学部.jpg',
                                      height: 110.h,
                                      width: 180.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  ListTile(
                                    title:  Text(
                                      '獣医学部',
                                      style: GoogleFonts.notoSans(
                                        // フォントをnotoSansに指定(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => zyuuigakubu()),
                          );
                        },
                      ),
                      GestureDetector(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                              height: 176.h,
                              width: 180.w,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                    child: Image.asset(
                                      'assets/images/生命科学部.jpg',
                                      height: 110.h,
                                      width: 180.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  ListTile(
                                    title:  Text(
                                      '生命科学部',
                                      style: GoogleFonts.notoSans(
                                        // フォントをnotoSansに指定(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => seimei()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Divider(), //区切り線
                Text(
                  '共通科目はこちら',
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(onPressed: (){

                }, child: Text('aaaa')),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                              height: 100.h,
                              width: 180.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListTile(
                                    title: const Text(
                                      '基盤教育科目',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => kibankamoku()),
                          );
                        },
                      ),
                      GestureDetector(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                              height: 100.h,
                              width: 180.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListTile(
                                    title: const Text(
                                      '教職科目',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => kyousyokukamoku()),
                          );
                        },
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => post()),
        );
      },
      child: const Icon(Icons.upload_outlined),
    ),


      );
}
