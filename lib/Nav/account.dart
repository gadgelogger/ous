import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class account extends StatefulWidget {
  const account({Key? key}) : super(key: key);

  @override
  State<account> createState() => _accountState();
}

class _accountState extends State<account> {
  String? name;
  String? email;
  String? image;
  String? uid;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // here, don't declare new variables, set the members instead
        setState(() {
          name = user.displayName; // <-- User ID
          email = user.email; // <-- Their email
          image = user.photoURL;
          uid = user.uid;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(160.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 150.0,
            backgroundColor: const Color(0xff8bc34a),
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return MyHomePage(title: 'home');
                  }),
                );
              },
            ),
            title: WillPopScope(
              onWillPop: () async => false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    //アカウント画像
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            //for horizontal scrolling
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              name ?? 'ゲストユーザー',
                              maxLines: 1,
                              style: GoogleFonts.notoSans(
                                // フォントをnotoSansに指定(
                                textStyle: TextStyle(
                                  fontSize: 30,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )),
                      Align(
                        alignment: const Alignment(-0.8, 0.4),
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(image ??
                                    'https://pbs.twimg.com/profile_images/1439164154502287361/1dyVrzQO_400x400.jpg'),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
                child: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: 600,
                  child: Card(
                    child: Text(
                      '歩数計',
                      style: TextStyle(fontSize: 50),
                    ),
                    color: Colors.white,
                    // Card自体の色
                    margin: EdgeInsets.all(30),
                    elevation: 10,
                    // 影の離れ具合
                    shadowColor: Colors.black, // 影の色
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        child: SizedBox(
                          width: 330,
                          child: Card(
                            child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/green neutrals desktop.jpeg'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '開発者のTwitterはこちら',
                                    maxLines: 1,
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                          ),
                        ),
                        onTap: (){
                          launch('https://twitter.com/TAN_Q_BOT_LOCAL');
                        },
                      ),
                      GestureDetector(
                        child:
                      SizedBox(
                        width: 330,
                        child: Card(
                          child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/green neutrals desktop.jpeg'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'アプリ公式サイトはこちら',
                                  maxLines: 1,
                                  style: GoogleFonts.notoSans(
                                    // フォントをnotoSansに指定(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                        ),
                      ),
                        onTap: (){
                          launch('https://tan-q-bot-unofficial.com/');
                        },
                      ),
                    ],
                    shrinkWrap: true,
                  ),
                ),
              ],
            )),
            CustomPaint(
              painter: AppBarPainter(),
              child: Container(height: 0),
            ),
          ],
        ),
      );
}

//AppBar改造
class AppBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_1 = Paint()
      ..color = const Color(0xff8bc34a)
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
      ..color = const Color(0xff8bc34a)
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
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
