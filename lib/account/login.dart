import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'authentication_error.dart';
import 'signuppage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ous/home.dart';
import 'package:ous/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'email_check.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  // Firebase 認証
  final _auth = FirebaseAuth.instance;

  String _login_Email = ""; // 入力されたメールアドレス
  String _login_Password = ""; // 入力されたパスワード
  String _infoText = ""; // ログインに関する情報を表示

  // エラーメッセージを日本語化するためのクラス
  final auth_error = Authentication_error_to_ja();



  //Appleサインイン

  // 公式のを参考に作ったユーザー登録の関数
  Future<UserCredential> signInWithApple() async {
    print('AppSignInを実行');

    final rawNonce = generateNonce();

    // 現在サインインしているAppleアカウントのクレデンシャルを要求する。
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(appleCredential);
    // Apple から返されたクレデンシャルから `OAuthCredential` を作成します。
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    print(appleCredential);
    // Firebaseでユーザーにサインインします。もし、先ほど生成したnonceが
    // が `appleCredential.identityToken` の nonce と一致しない場合、サインインに失敗します。
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  // 上のとほぼ一緒。登録とログインができる。
  Future<UserCredential> AppleSignIn() async {
    print('AppSignInを実行');
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(appleCredential);
    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    // ここに画面遷移をするコードを書く!
    Navigator.push(
        context,MaterialPageRoute(builder: (context) {
      return MyHomePage(title: 'home');
    }));
    print(appleCredential);
    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  //Appleサインイン




  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          _login_Email = value;
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
                          _login_Password = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 5.0.h,
                    ),
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
                        onTap: () =>
                            _auth.sendPasswordResetEmail(email: _login_Email),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
                        child: Text(
                          _infoText,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0.h),
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
                                UserCredential _result =
                                    await _auth.signInWithEmailAndPassword(
                                  email: _login_Email,
                                  password: _login_Password,
                                );

                                // ログイン成功
                                User _user = _result.user!; // ログインユーザーのIDを取得

                                // Email確認が済んでいる場合のみHome画面へ
                                if (_user.emailVerified) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MyHomePage(title: 'home');
                                  }));
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Emailcheck(
                                            email: _login_Email,
                                            pswd: _login_Password,
                                            from: 2)),
                                  );
                                }
                              } catch (e) {
                                // ログインに失敗した場合
                                setState(() {
                                  _infoText = auth_error.login_error_msg(
                                      e.hashCode, e.toString());
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
                            } on PlatformException catch (e) {}
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
                    //Appleでサインイン
                    Container(
                      height: 40.0.h,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0.w),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: GestureDetector(
                          onTap: () async {
                            signInWithApple();
                          },
                          child: Center(
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                    Icons.apple, //設定したいアイコンのID
                                    color: Colors.black // 色
                                ),
                                Text(
                                  'Appleでサインイン',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),                              ],
                            )
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
                              MaterialPageRoute(
                                  builder: (context) => Registration()),
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




