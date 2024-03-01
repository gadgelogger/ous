// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Project imports:
import 'package:ous/review/detail_view.dart';
import 'package:ous/review/post.dart';

class ReviewView extends StatefulWidget {
  final String gakubu;
  final String title;
  const ReviewView({
    Key? key,
    required this.gakubu,
    required this.title,
  }) : super(key: key);
  @override
  ReviewViewState createState() => ReviewViewState();
}

class ReviewViewState extends State<ReviewView> {
  //値わたし
  late String state;

  int _filterCount = 0;

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
    state = widget.gakubu;
  }

  @override
  Widget build(BuildContext context) {
    // 背景の明るさをチェック
    bool isBackgroundBright = Theme.of(context).brightness == Brightness.light;

// 明るい背景の場合は黒、暗い背景の場合は白
    Color textColor = isBackgroundBright ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection(widget.gakubu).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final data = snapshot.data!.docs.where((document) {
                if (_filterCount == 1) {
                  // Filter Rakutan only
                  Fluttertoast.showToast(msg: "ラク単のみ表示");

                  return document['bumon'] == 'ラク単';
                } else if (_filterCount == 2) {
                  // Filter Egutan only
                  Fluttertoast.showToast(msg: "エグ単のみ表示");

                  return document['bumon'] == 'エグ単';
                } else {
                  Fluttertoast.showToast(msg: "全て表示");

                  // Return all data
                  return true;
                }
              }).toList();
              return Scrollbar(
                child: AnimationLimiter(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final document = data[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                //firebase

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                      zyugyoumei: data[index]['zyugyoumei'],
                                      gakki: data[index]['gakki'],
                                      bumon: data[index]['bumon'],
                                      kousimei: data[index]['kousimei'],
                                      tannisuu: data[index]['tannisuu'],
                                      zyugyoukeisiki: data[index]
                                          ['zyugyoukeisiki'],
                                      syusseki: data[index]['syusseki'],
                                      kyoukasyo: data[index]['kyoukasyo'],
                                      tesutokeisiki: data[index]
                                          ['tesutokeisiki'],
                                      omosirosa: data[index]['omosirosa'],
                                      toriyasusa: data[index]['toriyasusa'],
                                      sougouhyouka: data[index]['sougouhyouka'],
                                      komento: data[index]['komento'],
                                      name: data[index]['name'],
                                      senden: data[index]['senden'],
                                      nenndo: data[index]['nenndo'],
                                      date: data[index]['date'].toDate(),
                                      tesutokeikou: data[index]['tesutokeikou'],
                                      id: document.id,
                                    ),
                                  ),
                                );
                              },
                              child: (SizedBox(
                                  width: 200.w,
                                  height: 30.h,
                                  child: Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Stack(
                                      children: <Widget>[
                                        // 既存のウィジェット
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Align(
                                            alignment:
                                                const Alignment(-0.8, -0.5),
                                            child: Text(
                                              data[index]['zyugyoumei'],
                                              style: TextStyle(fontSize: 20.sp),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: const Alignment(-0.8, 0.4),
                                          child: Text(
                                            data[index]['gakki'],
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 15.sp),
                                          ),
                                        ),
                                        Align(
                                          alignment: const Alignment(-0.8, 0.8),
                                          child: Text(
                                            data[index]['kousimei'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 15.sp),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 6),
                                            decoration: BoxDecoration(
                                              color:
                                                  data[index]['bumon'] == 'エグ単'
                                                      ? Colors.red
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              data[index]['bumon'],
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: textColor),
                                            ),
                                          ),
                                        ),
                                        // アイコンを追加する Positioned ウィジェット
                                      ],
                                    ),
                                  ))),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: showFloatingActionButton
          ? Column(
              verticalDirection: VerticalDirection.up,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const post()),
                          );
                        },
                        child: const Icon(Icons.upload_outlined),
                      ),
                    )
                  ],
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(
                      () {
                        _filterCount = (_filterCount + 1) % 3;
                      },
                    );
                  },
                  child: const Icon(Icons.filter_list),
                ),
              ],
            )
          : FloatingActionButton(
              onPressed: () {
                setState(
                  () {
                    _filterCount = (_filterCount + 1) % 3;
                  },
                );
              },
              child: const Icon(Icons.filter_list),
            ),
    );
  }
}
