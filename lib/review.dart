import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ous/NavBar.dart';
import 'package:ous/review/favorite.dart';
import 'package:ous/review/view.dart';
import 'package:ous/review/gpa.dart';
import 'package:ous/review/post.dart';
import 'package:ous/review/postuser.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Widget build(BuildContext context) {
    // 背景の明るさをチェック
    bool isBackgroundBright =
        Theme.of(context).primaryColor == Brightness.light;

    // 明るい背景の場合は黒、暗い背景の場合は白
    Color textColor = isBackgroundBright ? Colors.black : Colors.white;

    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        actions: const [
          //ここにアイコン設置
        ],
        elevation: 0,
        title: const Text('講義評価'),
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                          height: 176.h,
                          width: 180.w,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                ),
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 6),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ) // green shaped
                                              ),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('rigaku')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final count =
                                                    snapshot.data!.size;
                                                return Text(
                                                  '$count',
                                                  style: TextStyle(
                                                      fontSize: 16.0.sp,
                                                      color: textColor),
                                                );
                                              } else {
                                                return const SizedBox(
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
                                title: Text(
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
                        MaterialPageRoute(
                            builder: (context) => ReviewView(
                                  gakubu: 'rigaku',
                                  title: '理学部',
                                )),
                      );
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                          height: 176.h,
                          width: 180.w,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                ),
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 6),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ) // green shaped
                                              ),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('kougakubu')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final count =
                                                    snapshot.data!.size;
                                                return Text(
                                                  '$count',
                                                  style: TextStyle(
                                                      fontSize: 16.0.sp,
                                                      color: textColor),
                                                );
                                              } else {
                                                return const SizedBox(
                                                  height: 3,
                                                  width: 3,
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text(
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
                        MaterialPageRoute(
                            builder: (context) => ReviewView(
                                  gakubu: 'kougakubu',
                                  title: '工学部',
                                )),
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                          height: 176.h,
                          width: 180.w,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                ),
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 6),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ) // green shaped
                                              ),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('zyouhou')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final count =
                                                    snapshot.data!.size;
                                                return Text(
                                                  '$count',
                                                  style: TextStyle(
                                                      fontSize: 16.0.sp,
                                                      color: textColor),
                                                );
                                              } else {
                                                return const SizedBox(
                                                  height: 3,
                                                  width: 3,
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text(
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
                            builder: (context) => ReviewView(
                                  gakubu: 'zyouhou',
                                  title: '情報理工学部',
                                )),
                      );
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                          height: 176.h,
                          width: 180.w,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                ),
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 6),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ) // green shaped
                                              ),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('seibutu')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final count =
                                                    snapshot.data!.size;
                                                return Text(
                                                  '$count',
                                                  style: TextStyle(
                                                      fontSize: 16.0.sp,
                                                      color: textColor),
                                                );
                                              } else {
                                                return const SizedBox(
                                                  height: 3,
                                                  width: 3,
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text(
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
                            builder: (context) => ReviewView(
                                  gakubu: 'seibutu',
                                  title: '生物地球学部',
                                )),
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                          height: 176.h,
                          width: 180.w,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                ),
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 6),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ) // green shaped
                                              ),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('kyouiku')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final count =
                                                    snapshot.data!.size;
                                                return Text(
                                                  '$count',
                                                  style: TextStyle(
                                                      fontSize: 16.0.sp,
                                                      color: textColor),
                                                );
                                              } else {
                                                return const SizedBox(
                                                  height: 3,
                                                  width: 3,
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text(
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
                            builder: (context) => ReviewView(
                                  gakubu: 'kyouiku',
                                  title: '教育学部',
                                )),
                      );
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                          height: 176.h,
                          width: 180.w,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                ),
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 6),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ) // green shaped
                                              ),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('keiei')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final count =
                                                    snapshot.data!.size;
                                                return Text(
                                                  '$count',
                                                  style: TextStyle(
                                                      fontSize: 16.0.sp,
                                                      color: textColor),
                                                );
                                              } else {
                                                return const SizedBox(
                                                  height: 3,
                                                  width: 3,
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text(
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
                            builder: (context) => ReviewView(
                                  gakubu: 'keiei',
                                  title: '経営学部',
                                )),
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                          height: 176.h,
                          width: 180.w,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                ),
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 6),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ) // green shaped
                                              ),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('zyuui')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final count =
                                                    snapshot.data!.size;
                                                return Text(
                                                  '$count',
                                                  style: TextStyle(
                                                      fontSize: 16.0.sp,
                                                      color: textColor),
                                                );
                                              } else {
                                                return const SizedBox(
                                                  height: 3,
                                                  width: 3,
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text(
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
                            builder: (context) => ReviewView(
                                  gakubu: 'zyuui',
                                  title: '獣医学部',
                                )),
                      );
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                          height: 176.h,
                          width: 180.w,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                ),
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 6),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ) // green shaped
                                              ),
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('seimei')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final count =
                                                    snapshot.data!.size;
                                                return Text(
                                                  '$count',
                                                  style: TextStyle(
                                                      fontSize: 16.0.sp,
                                                      color: textColor),
                                                );
                                              } else {
                                                return const SizedBox(
                                                  height: 3,
                                                  width: 3,
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text(
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
                            builder: (context) => ReviewView(
                                  gakubu: 'seimei',
                                  title: '生命科学部',
                                )),
                      );
                    },
                  ),
                ],
              ),
              const Divider(), //区切り線
              Text(
                '共通科目はこちら',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        Card(
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('kiban')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final count = snapshot.data!.size;
                                  return Text(
                                    '$count',
                                    style: TextStyle(
                                        fontSize: 16.0.sp, color: textColor),
                                  );
                                } else {
                                  return const SizedBox(
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
                        MaterialPageRoute(
                            builder: (context) => ReviewView(
                                  gakubu: 'kiban',
                                  title: '基盤教育科目',
                                )),
                      );
                    },
                  ),
                  GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        Card(
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('kyousyoku')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final count = snapshot.data!.size;
                                  return Text(
                                    '$count',
                                    style: TextStyle(
                                        fontSize: 16.0.sp, color: textColor),
                                  );
                                } else {
                                  return const SizedBox(
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
                        MaterialPageRoute(
                            builder: (context) => ReviewView(
                                  gakubu: 'kyousyoku',
                                  title: '教職関連科目',
                                )),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: showFloatingActionButton
          ? SpeedDial(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(
                    18.0)), // adjust this value according to your button's height
              ),
              icon: Icons.menu,
              activeIcon: Icons.close,
              childPadding: const EdgeInsets.all(5),
              spaceBetweenChildren: 10,
              children: [
                  SpeedDialChild(
                    child: const Icon(Icons.upload_outlined),
                    label: "投稿",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const post()),
                      );
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.favorite_border),
                    label: "お気に入り",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FavoritesPage()),
                      );
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.person_2_outlined),
                    label: "自分の投稿",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MultipleCollectionsPage()),
                      );
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.info),
                    label: "教務ガイド（履修削除はこちら）",
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("注意"),
                          content: const Text(
                            "この先ログイン画面が表示されます\n大学のGoogleアカウントでログインしてください。",
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("やめる"),
                            ),
                            TextButton(
                              onPressed: () async {
                                final url = Uri.parse(
                                  'https://accounts.google.com/AccountChooser/signinchooser?continue=https%3A%2F%2Fsites.google.com%2Fous.ac.jp%2Facademicaffairs%2F%25E5%2590%2584%25E7%25A8%25AE%25E7%2594%25B3%25E8%25AB%258B%2F%25E5%25B1%25A5%25E4%25BF%25AE%25E9%2596%25A2%25E4%25BF%2582&flowName=GlifWebSignIn&flowEntry=AccountChooser',
                                );
                                if (await canLaunchUrl(url)) {
                                  launchUrl(url,
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  // ignore: avoid_print
                                  print("Can't launch $url");
                                }
                              },
                              child: const Text("おっけー"),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.book),
                    label: "シラバス",
                    onTap: () async {
                      final url = Uri.parse(
                        'https://mylog.pub.ous.ac.jp/uprx/up/pk/pky001/Pky00101.xhtml?guestlogin=Kmh006',
                      );
                      if (await canLaunchUrl(url)) {
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        // ignore: avoid_print
                        print("Can't launch $url");
                      }
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.calculate),
                    label: "GPA計算機",
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Gpa()),
                      );
                    },
                  ),
                ])
          : null,
    );
  }
}
