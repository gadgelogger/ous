import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

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
  void initState(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
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

    appBar:PreferredSize(
      preferredSize: Size.fromHeight(160.0),
      child: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 150.0,
        backgroundColor: const Color(0xff8bc34a),
        elevation: 0.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(//アカウント画像
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Text(name ?? 'guest',
                    style: GoogleFonts.notoSans( // フォントをnotoSansに指定(
                      textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white

                      ),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(0,0,100,0),
                ),
                Container(
                  width: 110.0,
                  height: 110.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            image ?? 'https://pbs.twimg.com/profile_images/1439164154502287361/1dyVrzQO_400x400.jpg'                        ),                )
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    ),

    body: Stack(
      children: [
        Container(
          color: Colors.white,
          child: Text('ここに要素追加'),
        ),
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
          size.width * 0.04, 0.0, //x1,y1
          0.0, 0.04, //x2,y2
          0.0, 0.1 * size.width //x3,y3
      );

    Path path_2 = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * .92, 0.0)
      ..cubicTo(
          size.width * .96, 0.0, //x1,y1
          size.width, 0.96, //x2,y2
          size.width, 0.1 * size.width //x3,y3
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
