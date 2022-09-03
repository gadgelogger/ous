import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ous/home.dart';
import 'package:ous/main.dart';
import 'package:ous/signuppage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // メッセージ表示用
  String infoText = '';

  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';

  final auth_error = Authentication_error();


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Hello',
                        style: TextStyle(
                            fontSize: 80.0.sp, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(13.0, 180.0, 0.0, 0.0),
                    child: Text('OUS',
                        style: TextStyle(
                            fontSize: 80.0.sp, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(168.0, 175.0, 0.0, 0.0),
                    child: Text('.',
                        style: TextStyle(
                            fontSize: 80.0.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen)),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'メールアドレス',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.lightGreen))),
                      onChanged: (String value) {
                        setState(() {
                          email = value;
                        });
                      },
                      inputFormatters: [],
                    ),
                    SizedBox(height: 20.0.h),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'パスワード',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.lightGreen))),
                      obscureText: true,
                      onChanged: (String value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    SizedBox(height: 5.0.h),
                    Container(
                      alignment: Alignment(1.0, 0.0),
                      padding: EdgeInsets.only(top: 15.0, left: 20.0),
                      child: InkWell(
                        child: Text(
                          'パスワードを忘れた方へ',
                          style: TextStyle(
                              color: Colors.lightGreen,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    Center(
                      child:  Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
                        child:Text(infoText,
                          style: TextStyle(color: Colors.red),),
                      ),
                    ),
                    SizedBox(height: 40.0.h),
                    Container(
                      height: 40.0.h,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.lightGreen,
                        elevation: 7.0,
                        child: GestureDetector(
                            onTap: () async {
                              try {
                                // メール/パスワードでログイン
                                final FirebaseAuth auth = FirebaseAuth.instance;
                                await auth.signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                // ログインに成功した場合
                                // チャット画面に遷移＋ログイン画面を破棄
                                await Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                    return MyHomePage(title: 'home');
                                  }),
                                );
                              }   catch(e) {
                                // ログインに失敗した場合
                                setState(() {
                                  infoText = "ログインに失敗しました:${auth_error.login_error_msg(e.toString())}";
                                });
                              }
                            },
                            child: Container(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Text(
                                    'ログイン',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                )
                              ],
                            ))),
                      ),
                    ),
                    SizedBox(height: 20.0.h),
                    Container(
                      height: 40.0.h,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightGreen,
                                style: BorderStyle.solid,
                                width: 1.0.w),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              // メール/パスワードでログイン
                              final userCredential = await signInWithGoogle();
                              // ログインに成功した場合
                              // チャット画面に遷移＋ログイン画面を破棄
                              await Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                                  return MyHomePage(title: 'home');
                                }),
                              );
                            } on PlatformException catch(e) {
                            }
                          },
                          child: Center(
                            child: Text(
                              '大学のアカウントでログイン',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 15.0.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '会員登録がお済みでない方',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0.w),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Text(
                    'こちら',
                    style: TextStyle(
                        color: Colors.lightGreen,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '利用規約については',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0.w),
                InkWell(
                  onTap: () => launch(
                      'https://tan-q-bot-unofficial.com/terms_of_service/'),
                  child: Text(
                    'こちら',
                    style: TextStyle(
                        color: Colors.lightGreen,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}



  // Firebase Authentication利用時の日本語エラーメッセージ
  class Authentication_error {

    // ログイン時の日本語エラーメッセージ
    String login_error_msg(String error_code) {
      String error_msg;

      if (error_code == 'ERROR_INVALID_EMAIL') {
        error_msg = '有効なメールアドレスを入力してください。';
      } else if (error_code == 'ERROR_USER_NOT_FOUND') {
        // 入力されたメールアドレスが登ていない場合
        error_msg = 'メールアドレスかパスワードが間違っています。';
      } else if (error_code == 'ERROR_WRONG_PASSWORD') {
        // 入力されたパスワードが間違っている場合
        error_msg = 'メールアドレスかパスワードが間違っています。';
      } else if (error_code == '[firebase_auth/wrong-password]') {
        // メールアドレスかパスワードがEmpty or Nullの場合
        error_msg = 'メールアドレスとパスワードを入力してください。';
      } else {
        error_msg = error_code;
      }

      return error_msg;
    }
  }
