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
  String _infoText = ""; // ログインに関する情報を表示

  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';
  final auth_error = Authentication_error_to_ja();


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
                    SizedBox(height: 5.0.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '',
                          style: TextStyle(fontFamily: 'Montserrat'),
                        ),
                        SizedBox(width: 5.0.w),
                        InkWell(
                          onTap: () => launch(
                              'https://tan-q-bot-unofficial.com/terms_of_service/'),
                          child: Text(
                            '利用規約に同意する必要があります。',
                            style: TextStyle(
                                color: Colors.lightGreen,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0.h),
                    Container(
                      alignment: Alignment(-1.0, 0.0),
                      padding: EdgeInsets.only(top: 15.0, left: 6.0),
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
                        child: Text(
                          _infoText,
                          style: TextStyle(color: Colors.red),
                        ),
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
                                  _infoText =auth_error.login_error_msg(e.hashCode, e.toString());

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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignupPage()),
                              );
                          },
                          child: Center(
                            child: Text(
                              'サインアップ',
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
class Authentication_error_to_ja {
  // ログイン時の日本語エラーメッセージ
  login_error_msg(int error_code, String org_error_msg) {
    String error_msg;

    if (error_code == 513544714) {
      error_msg = '有効なメールアドレスを入力してください。';
    } else if (error_code == 505284406) {
      // 入力されたメールアドレスが登録されていない場合
      error_msg = 'メールアドレスかパスワードが間違っています。';
    } else if (error_code == 185768934) {
      // 入力されたパスワードが間違っている場合
      error_msg = 'メールアドレスかパスワードが間違っています。';
    } else if (error_code == 55182036) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      error_msg = 'メールアドレスが無効であるか、パスワードが間違っています。';
    }
    else if (error_code == 298063151) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      error_msg = '何回も間違えたため一時的にログインが無効になりました。パスワードをリセットするか時間を空けてもう一度ログインしてください。';
    } else {
      error_msg = org_error_msg + '[' + error_code.toString() + ']';
    }

    return error_msg;
  }

  // アカウント登録時の日本語エラーメッセージ
  register_error_msg(int error_code, String org_error_msg) {
    String error_msg;

    if (error_code == 360587416) {
      error_msg = '有効なメールアドレスを入力してください。';
    } else if (error_code == 34618382) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      error_msg = '既に登録済みのメールアドレスです。';
    } else if (error_code == 447031946) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      error_msg = 'メールアドレスとパスワードを入力してください。';
    } else {
      error_msg = org_error_msg + '[' + error_code.toString() + ']';
    }

    return error_msg;
  }
}