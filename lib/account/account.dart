import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ous/Account/Account_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class account extends StatefulWidget {
  const account({Key? key}) : super(key: key);

  @override
  State<account> createState() => _accountState();
}

class _accountState extends State<account> {
//firestoreキャッシュ
  Stream<DocumentSnapshot>? _stream;
  late DocumentSnapshot _data;

  @override
  void initState() {
    super.initState();

    _stream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(160.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 150.0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const MyHomePage(
                      title: 'home',
                    );
                  }),
                );
              },
            ),
            title: WillPopScope(
              onWillPop: () async => false,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: _stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // データ読み込み中の場合の処理
                      return const CircularProgressIndicator();
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      // データが取得できなかった場合の処理
                      return const Text('データが見つかりませんでした。');
                    }
                    // データが正常に取得できた場合の処理
                    _data = snapshot.data!;
                    final email = _data['email'] as String;
                    final name = _data['displayName'] as String;
                    final isStudent = email.contains('@ous.jp');
                    final isStaff = email.contains('@ous.ac.jp');
                    final image = _data['photoURL'] as String;
                    final status = isStudent
                        ? '生徒'
                        : isStaff
                            ? '教職員'
                            : '外部';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Row(
                            //アカウント画像
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    //for horizontal scrolling
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      name,
                                      maxLines: 1,
                                      style: GoogleFonts.notoSans(
                                        // フォントをnotoSansに指定(
                                        textStyle: const TextStyle(
                                          fontSize: 30,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  fit: StackFit.expand,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return const account_edit();
                                          }),
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(image),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: -25,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return const account_edit();
                                            }),
                                          );
                                        },
                                        elevation: 2.0,
                                        fillColor: const Color(0xFFF5F6F9),
                                        padding: const EdgeInsets.all(7.0),
                                        shape: const CircleBorder(),
                                        child: Icon(Icons.settings_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: const Alignment(-0.9, 0.4),
                              child: Text(
                                '役職: $status',
                                maxLines: 1,
                                style: GoogleFonts.notoSans(
                                  // フォントをnotoSansに指定(
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                // ここにリストアイテムを追加する
                // 画面中央下部に配置するウィジェット

                StreamBuilder<DocumentSnapshot>(
                  stream: firestore.collection('users').doc(uid).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print('error');
                    }

                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }

                    // Firestoreから取得したデータを取り出す
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    String day = data['day'] ?? '値が見つかりませんでした';
                    String displayname = data['displayName'] ?? '値が見つかりませんでした';
                    final DateFormat inputFormat =
                        DateFormat('yyyy/MM/dd(EEE) HH:mm:ss');
                    final DateFormat outputFormat = DateFormat('yyyy年MM月dd日');
                    final DateTime dateTime = inputFormat.parse(day);
                    final String formattedDate =
                        outputFormat.format(dateTime); // 登録した日付

                    final DateTime now = DateTime.now();
                    final Duration difference = now.difference(dateTime);

                    final int days = difference.inDays;
                    final int hours = difference.inHours % 24;
                    final int minutes = difference.inMinutes % 60;

                    final String differenceString =
                        '$days days $hours hours $minutes minutes ago';

                    print(formattedDate); // 2023/03/04
                    print(differenceString); // 740 days 0 hours 25 minutes

                    // テキストを表示する
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/images/icon2.jpg'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              child: Text(
                                '$displaynameさんご愛用ありがとうございます\nアプリを$formattedDateから使い始めて\n$days日が経過しました。',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSans(
                                  textStyle: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(184, 189, 211, 1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            CustomPaint(
              painter: AppBarPainter(context),
              child: Container(height: 0),
            ),
          ],
        ),
      );
}

//AppBar改造
class AppBarPainter extends CustomPainter {
  final BuildContext context;

  AppBarPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_1 = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..style = PaintingStyle.fill;

    Path path_1 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * .08, 0.0)
      ..cubicTo(
          size.width * 0.04,
          0.0, //x1,y1
          0.0,
          0.04, //x2,y2
          0.0,
          0.1 * size.width //x3,y3
          );

    Path path_2 = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * .92, 0.0)
      ..cubicTo(
          size.width * .96,
          0.0, //x1,y1
          size.width,
          0.96, //x2,y2
          size.width,
          0.1 * size.width //x3,y3
          );

    Paint paint_2 = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    Path path_3 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path_1, paint_1);
    canvas.drawPath(path_2, paint_1);
    canvas.drawPath(path_3, paint_2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
