// Flutter imports:
// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
// Project imports:
import 'package:ous/review/favorite.dart';
import 'package:ous/review/gpa.dart';
import 'package:ous/review/post.dart';
import 'package:ous/review/postuser.dart';
import 'package:ous/review/sabori.dart';
import 'package:ous/review/view.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String collection;

  const CustomCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.collection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 背景の明るさをチェック
    bool isBackgroundBright =
        Theme.of(context).primaryColor == Brightness.light;

    // 明るい背景の場合は黒、暗い背景の場合は白
    Color textColor = isBackgroundBright ? Colors.black : Colors.white;

    if (imagePath.isNotEmpty) {
      return GestureDetector(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 176.h,
            width: 180.w,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        imagePath,
                        height: 110.h,
                        width: 200.w,
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(collection)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final count = snapshot.data!.size;
                                return Text(
                                  '$count',
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    color: textColor,
                                  ),
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
                ),
                ListTile(
                  title: Text(
                    title,
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewView(
                gakubu: collection,
                title: title,
              ),
            ),
          );
        },
      );
    } else {
      return GestureDetector(
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
                        title,
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
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(collection)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final count = snapshot.data!.size;
                      return Text(
                        '$count',
                        style: TextStyle(fontSize: 16.0.sp, color: textColor),
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
                gakubu: collection,
                title: title,
              ),
            ),
          );
        },
      );
    }
  }
}

class FloatingButton extends StatelessWidget {
  const FloatingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            18.0,
          ),
        ), // adjust this value according to your button's height
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
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
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
                builder: (context) => const MultipleCollectionsPage(),
              ),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.info_outline),
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
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        // ignore: avoid_print
                        print("Can't launch $url");
                      }
                    },
                    child: const Text("おっけー"),
                  ),
                ],
              ),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.book_outlined),
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
          child: const Icon(Icons.calculate_outlined),
          label: "GPA計算機",
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Gpa()),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.directions_run_outlined),
          label: "サボりカウンター",
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Sabori()),
            );
          },
        ),
      ],
    );
  }
}
