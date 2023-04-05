import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
import 'package:ous/review/postuser.dart';

import 'dart:async';


class Review extends StatefulWidget {
  const Review({Key? key}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {


//大学のアカウント以外は非表示にする
  late FirebaseAuth auth;
  bool showFloatingActionButton = false;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null && user.email != null && user.email!.endsWith('ous.jp')) {
      showFloatingActionButton = true;
    }
  }



  @override

    Widget build(BuildContext context) => Scaffold(

      drawer: NavBar(),
      appBar: AppBar(
        actions: [
          //ここにアイコン設置
            ],
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

                                  child: Stack(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/理学部.jpg',
                                        height: 110.h,
                                        width: 200.w,
                                        fit: BoxFit.contain,
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 6),
                                            decoration: BoxDecoration(
                                             color: Colors.lightGreen,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight: Radius.circular(8),
                                                ) // green shaped
                                            ),
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance.collection('rigaku').snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  final count = snapshot.data!.size;
                                                  return Text(
                                                    '$count',
                                                    style: TextStyle(fontSize: 16.0,color: Colors.black),
                                                  );
                                                } else {
                                                  return SizedBox(
                                                    height: 3,
                                                    width: 3,
                                                    child: Text('0'),
                                                  );
                                                }
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '理学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
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

                                  child: Stack(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/工学部.jpg',
                                        height: 110.h,
                                        width: 200.w,
                                        fit: BoxFit.contain,
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.lightGreen,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight: Radius.circular(8),
                                                ) // green shaped
                                            ),
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance.collection('kougakubu').snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  final count = snapshot.data!.size;
                                                  return Text(
                                                    '$count',
                                                    style: TextStyle(fontSize: 16.0,color: Colors.black),
                                                  );
                                                } else {
                                                  return SizedBox(
                                                    height: 3,
                                                    width: 3,
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '工学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
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
                      child:Card(

                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            height: 176.h,
                            width: 180.w,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.lightGreen[100]),

                                  child: Stack(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/情報理工学部.jpg',
                                        height: 110.h,
                                        width: 200.w,
                                        fit: BoxFit.contain,
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.lightGreen,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight: Radius.circular(8),
                                                ) // green shaped
                                            ),
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance.collection('zyouhou').snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  final count = snapshot.data!.size;
                                                  return Text(
                                                    '$count',
                                                    style: TextStyle(fontSize: 16.0,color: Colors.black),
                                                  );
                                                } else {
                                                  return SizedBox(
                                                    height: 3,
                                                    width: 3,
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '情報理工学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
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

                                  child: Stack(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/生物地球学部.jpg',
                                        height: 110.h,
                                        width: 200.w,
                                        fit: BoxFit.contain,
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.lightGreen,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight: Radius.circular(8),
                                                ) // green shaped
                                            ),
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance.collection('seibutu').snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  final count = snapshot.data!.size;
                                                  return Text(
                                                    '$count',
                                                    style: TextStyle(fontSize: 16.0,color: Colors.black),
                                                  );
                                                } else {
                                                  return SizedBox(
                                                    height: 3,
                                                    width: 3,
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '生物地球学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
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
                      child:Card(

                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            height: 176.h,
                            width: 180.w,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.lightGreen[100]),

                                  child: Stack(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/教育学部.jpg',
                                        height: 110.h,
                                        width: 200.w,
                                        fit: BoxFit.contain,
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.lightGreen,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight: Radius.circular(8),
                                                ) // green shaped
                                            ),
                                            child:StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance.collection('kyouiku').snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  final count = snapshot.data!.size;
                                                  return Text(
                                                    '$count',
                                                    style: TextStyle(fontSize: 16.0,color: Colors.black),
                                                  );
                                                } else {
                                                  return SizedBox(
                                                    height: 3,
                                                    width: 3,
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '教育学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
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

                                  child: Stack(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/経営学部.jpg',
                                        height: 110.h,
                                        width: 200.w,
                                        fit: BoxFit.contain,
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.lightGreen,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight: Radius.circular(8),
                                                ) // green shaped
                                            ),
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance.collection('keiei').snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  final count = snapshot.data!.size;
                                                  return Text(
                                                    '$count',
                                                    style: TextStyle(fontSize: 16.0,color: Colors.black),
                                                  );
                                                } else {
                                                  return SizedBox(
                                                    height: 3,
                                                    width: 3,
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '経営学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
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

                                  child: Stack(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/獣医学部.jpg',
                                        height: 110.h,
                                        width: 200.w,
                                        fit: BoxFit.contain,
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.lightGreen,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight: Radius.circular(8),
                                                ) // green shaped
                                            ),
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance.collection('zyuui').snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  final count = snapshot.data!.size;
                                                  return Text(
                                                    '$count',
                                                    style: TextStyle(fontSize: 16.0,color: Colors.black),
                                                  );
                                                } else {
                                                  return SizedBox(
                                                    height: 3,
                                                    width: 3,
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '獣医学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
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

                                  child: Stack(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/生命科学部.jpg',
                                        height: 110.h,
                                        width: 200.w,
                                        fit: BoxFit.contain,
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.lightGreen,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight: Radius.circular(8),
                                                ) // green shaped
                                            ),
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance.collection('seimei').snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  final count = snapshot.data!.size;
                                                  return Text(
                                                    '$count',
                                                    style: TextStyle(fontSize: 16.0,color: Colors.black),
                                                  );
                                                } else {
                                                  return SizedBox(
                                                    height: 3,
                                                    width: 3,
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '生命科学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
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

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child:Stack(
                        children: <Widget>[
                          Card(
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              height: 100.h,
                              width: 180.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListTile(
                                    title: Text(
                                      '基盤教育科目',
                                      style: GoogleFonts.notoSans(
                                        textStyle: TextStyle(
                                          fontSize: 20.sp,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('kiban').snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final count = snapshot.data!.size;
                                    return Text(
                                      '$count',
                                      style: TextStyle(fontSize: 16.0),
                                    );
                                  } else {
                                    return SizedBox(
                                      height: 3,
                                      width: 3,
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => kibankamoku()),
                        );
                      },
                    ),
                    GestureDetector(
                      child:Stack(
                        children: <Widget>[
                          Card(
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              height: 100.h,
                              width: 180.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListTile(
                                    title: Text(
                                      '教職関連科目',
                                      style: GoogleFonts.notoSans(
                                        textStyle: TextStyle(
                                          fontSize: 20.sp,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('kyousyoku').snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final count = snapshot.data!.size;
                                    return Text(
                                      '$count',
                                      style: TextStyle(fontSize: 16.0),
                                    );
                                  } else {
                                    return SizedBox(
                                      height: 3,
                                      width: 3,
                                      child: Text('0'),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
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
    floatingActionButton: showFloatingActionButton
        ? Column(
      verticalDirection: VerticalDirection.up,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          children: [
         /*   Container(
              margin: EdgeInsets.only(bottom: 16),
              child: FloatingActionButton(
                onPressed: () {
                  Fluttertoast.showToast(msg: "開発中です!完成まで待ってね。");

                },
                child: const Icon(Icons.favorite_border),
              ),
            ),*/
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MultipleCollectionsPage()),
                );
              },              child: Icon(Icons.person_2_outlined),
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => post()),
                  );
                },
                child: const Icon(Icons.upload_outlined),
              ),
            )
          ],
        ),
      ],
    )
        : null,




    );

}


