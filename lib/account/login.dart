import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ous/account/tutorial.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'authentication_error.dart';
import 'signuppage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ous/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ous/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'email_check.dart';
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
  String _login_forgot_Email = ""; // 入力されたパスワード

  String _infoText = ""; // ログインに関する情報を表示

  // エラーメッセージを日本語化するためのクラス
  final auth_error = Authentication_error_to_ja();

  //ユーザー情報保存
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> Register() {
    // 上で定義したメンバ変数を格納すると、usersコレクションに、
    // メールアドレスとパスワードも保存できる。
    return users
        .add({
      'email': _login_Email,
    })
        .then((value) => print("新規登録に成功"))
        .catchError((error) => print("新規登録に失敗しました!: $error"));
  }



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
        context, MaterialPageRoute(builder: (context) {
      return MyHomePage(title: 'home');

    }));
    Fluttertoast.showToast(msg: "ログインしました");


    print(appleCredential);
    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }
//ゲストモード
  Future<void> _onSignInWithAnonymousUser() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try{
      await firebaseAuth.signInAnonymously();

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return MyHomePage(title: 'home');
          })
      );
      Fluttertoast.showToast(msg: "ゲストでログインしました");

    } catch(e) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('エラー'),
              content: Text(e.toString()),
            );
          }
      );
    }
  }


//初回チュートリアル表示
  void _showTutorial(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();

    if (pref.getBool('isAlreadyFirstLaunch') != true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => tutorial(),
          fullscreenDialog: true,
        ),
      );
      pref.setBool('isAlreadyFirstLaunch', true);
    }
  }







  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showTutorial(context));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Scrollbar(
            isAlwaysShown: true,
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child:Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(15),
                                top:ScreenUtil().setWidth(110),
                              ),
                              child: Text('Hello',
                                  style: TextStyle(
                                      fontSize: 80.0.sp,
                                      fontWeight: FontWeight.bold)),
                            ) ,
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(left: ScreenUtil().setWidth(13),top:ScreenUtil().setWidth(180)),
                              child: Container(
                                child: Text('OUS',
                                    style: TextStyle(
                                        fontSize: 80.0.sp,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            top: 35.0, left: 20.0, right: 20.0),
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
                                  onTap: () =>
                                      launch(
                                          'https://tan-q-bot-unofficial.com/terms_of_service/'),
                                  child: Text(
                                    '利用規約はこちら',
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
                                onTap: (){
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: Text("パスワードを忘れた人へ",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                                        content: Column(
                                            mainAxisSize: MainAxisSize.min,

                                            children: <Widget>[
                                              Container(
                                                  width: 100,
                                                  height: 100,
                                                  child:
                                                  Image(
                                                    image: AssetImage('assets/icon/password.gif'),
                                                    fit: BoxFit.cover,
                                                  )),
                                              Text('下のテキストボックスにメールアドレスを入力して、リセットボタンを押してください。',textAlign: TextAlign.center,),
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
                                                    _login_forgot_Email = value;
                                                  });
                                                },
                                              ),



                                            ]
                                        ),
                                        actions: <Widget>[
                                          // ボタン領域
                                          TextButton(
                                            child: Text("やっぱやめる"),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          TextButton(
                                            child: Text("リセットする"),
                                            onPressed: (){
                                              _auth.sendPasswordResetEmail(
                                                  email: _login_forgot_Email);


                                              showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "パスワードリセット完了",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      content: Column(
                                                        mainAxisSize: MainAxisSize.min,

                                                        children: [
                                                          Container(
                                                              width: 100,
                                                              height: 100,
                                                              child:
                                                              Image(
                                                                image: AssetImage('assets/icon/rocket.gif'),
                                                                fit: BoxFit.cover,
                                                              )),
                                                          Text(
                                                            "入力してくれたメールアドレス宛にパスワードリセットをするメールを送信しました。\nもし届いていない場合は迷惑メールフォルダーを確認してください。",
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ],
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text("オッケー"),
                                                          onPressed: () => Navigator.pop(context),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }

                              ),
                            ),
                            //エラー表示
                            Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    20.0, 0, 20.0, 5.0),
                                child: Text(
                                  _infoText,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                            //エラー表示（ここまで）
                            SizedBox(height: 10.0.h),
                            //ログインボタン
                            Container(
                              height: 40.0.h,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.lightGreen[200],
                                child: GestureDetector(
                                    onTap: () async {
                                      try {
                                        Register();
                                        // メール/パスワードでログイン
                                        UserCredential _result =
                                        await _auth.signInWithEmailAndPassword(
                                          email: _login_Email,
                                          password: _login_Password,
                                        );

                                        // ログイン成功
                                        User _user = _result
                                            .user!; // ログインユーザーのIDを取得

                                        // Email確認が済んでいる場合のみHome画面へ
                                        if (_user.emailVerified) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return MyHomePage(
                                                        title: 'home');
                                                  }));
                                          Fluttertoast.showToast(msg: "ログインしました");
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Emailcheck(
                                                        email: _login_Email,
                                                        pswd: _login_Password,
                                                        from: 2)),
                                          );
                                          Fluttertoast.showToast(msg: "ログインしました");
                                        }
                                      } catch (e) {
                                        // ログインに失敗した場合
                                        setState(() {
                                          _infoText =
                                              auth_error.login_error_msg(
                                                  e.hashCode, e.toString());
                                        });
                                      }
                                    },
                                    child: Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceEvenly,
                                          children: [
                                            Center(
                                              child: Text(
                                                'ログイン',
                                                style: TextStyle(
                                                    color: Colors.green[900],
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Montserrat'),
                                              ),
                                            )
                                          ],
                                        ))),
                              ),
                            ),
                            //ログインボタンここまで
                            SizedBox(height: 20.0.h),
                            //大学のアカウントでログイン
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
                                      Register();
                                      // ログインに成功した場合
                                      // チャット画面に遷移＋ログイン画面を破棄
                                      await Navigator.of(context)
                                          .pushReplacement(
                                        MaterialPageRoute(builder: (context) {
                                          return MyHomePage(title: 'home');
                                        }),
                                          result: Fluttertoast.showToast(msg: "大学のアカウントでログインしました")

                                      );
                                    } on PlatformException catch (e) {}
                                  },
                                  child: Center(
                                    child: Text(
                                      '大学のアカウントでログイン',
                                      style: TextStyle(
                                          color: Colors.green[900],
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //大学のアカウントでログイン（ここまで）
                            SizedBox(height: 20.0.h),
                            //Appleでサインイン
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
                                          fontFamily: 'Montserrat',
                                          color: Colors.green[900]
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //Appleでサインイン（ここまで）
                            SizedBox(height: 20.0.h),
                            //サインアップ
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
                                    AppleSignIn();
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
                            //サインアップ（ここまで）
                            SizedBox(height: 20.0.h),
                            //ゲストモード
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
                                   onTap: (){
                                     showDialog(
                                       context: context,
                                       builder: (_) {
                                         return AlertDialog(
                                           title: Text("⚠️注意⚠️",textAlign: TextAlign.center,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                           content: Column(
                                               mainAxisSize: MainAxisSize.min,

                                               children: <Widget>[

                                                 Text('会員登録なしで続行します。\n\nただセキュリティ上の理由により',textAlign: TextAlign.center,),
                                                 Text('30日後にアカウントが消去されます',textAlign: TextAlign.center,style: TextStyle(color: Colors.red,decoration: TextDecoration.underline),),
                                                 Text('データを保存する場合は登録をするか\n大学のアカウントでログインしてください\n\n',textAlign: TextAlign.center,),
                                                 Text('また講義評価の書き込みなど一部の機能は使用できません。\n',textAlign: TextAlign.center,),



                                               ]
                                           ),
                                           actions: <Widget>[
                                             // ボタン領域
                                             TextButton(
                                               child: Text("やっぱやめる"),
                                               onPressed: () => Navigator.pop(context),
                                             ),
                                             TextButton(
                                               child: Text("構わんよ"),
                                               onPressed: () => _onSignInWithAnonymousUser(),
                                             ),
                                           ],
                                         );
                                       },
                                     );
                                   },
                                  child: Center(
                                    child: Text(
                                      'ゲストモードで使用',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat',
                                          color: Colors.green[900]

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //ゲストモード（ここまで）
                            SizedBox(height: 50.0.h),

                          ],
                        )),
                  ],
                ))));
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


