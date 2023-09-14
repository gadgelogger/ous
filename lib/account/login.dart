import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ous/account/tutorial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'signuppage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:ous/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'email_check.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

extension OnPrimary on Color {
  /// 輝度が高ければ黒, 低ければ白を返す
  Color get onPrimary {
    // 輝度により黒か白かを決定する
    if (computeLuminance() < 0.5) {
      return Colors.white;
    }
    return Colors.black;
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  //利用規約に同意したかの確認
  bool _isChecked = false;

  // Firebase 認証
  final _auth = FirebaseAuth.instance;

  String _login_Email = ""; // 入力されたメールアドレス
  String _login_Password = ""; // 入力されたパスワード
  String _login_forgot_Email = ""; // 入力されたパスワード

  String _infoText = ""; // ログインに関する情報を表示
  // エラーメッセージを日本語化するためのクラス
  final auth_error = Authentication_error_to_ja();

  final DateTime now = DateTime.now();

  //ユーザー情報保存
  CollectionReference users = FirebaseFirestore.instance.collection('users');

//Appleサインイン

  // 上のとほぼ一緒。登録とログインができる。
  Future<UserCredential?> AppleSignIn() async {
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

    try {
      final authResult =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final firebaseUser = authResult.user;

      final userRef =
          FirebaseFirestore.instance.collection('users').doc(firebaseUser?.uid);

      userRef.set({
        'uid': firebaseUser?.uid ?? '未設定',
        'email': firebaseUser?.email ?? '未設定',
        'displayName': firebaseUser?.displayName ?? '名前未設定',
        'photoURL': firebaseUser?.photoURL ??
            'https://pbs.twimg.com/profile_images/1439164154502287361/1dyVrzQO_400x400.jpg',
        'day': DateFormat('yyyy/MM/dd(E) HH:mm:ss').format(now)

        // その他のユーザー情報を追加
      }, SetOptions(merge: true));

      // ここに画面遷移をするコードを書く!
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MyHomePage(title: 'home');
      }));
      Fluttertoast.showToast(msg: "Appleでログインしました");

      print(appleCredential);
      return authResult;
    } catch (error) {
      print(error);
    }
    return null;
  }

//ゲストモード
  Future<void> _onSignInWithAnonymousUser() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signInAnonymously();

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return const MyHomePage(title: 'home');
      }));
      Fluttertoast.showToast(msg: "ゲストでログインしました");
    } catch (e) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('エラー'),
              content: Text(e.toString()),
            );
          });
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

    Future<bool> _willPopCallback() async {
      return true;
    }

    final Color primaryColor;

    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(15),
                                top: ScreenUtil().setWidth(110),
                              ),
                              child: Text('Hello',
                                  style: TextStyle(
                                      fontSize: 80.0.sp,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(13),
                                  top: ScreenUtil().setWidth(180)),
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
                        padding: const EdgeInsets.only(
                            top: 35.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'メールアドレス',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightGreen))),
                              onChanged: (String value) {
                                setState(() {
                                  _login_Email = value;
                                });
                              },
                              inputFormatters: const [],
                            ),
                            SizedBox(height: 20.0.h),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'パスワード',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightGreen))),
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

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0,
                                            color: Colors.transparent),
                                      ),
                                      child: Checkbox(
                                        value: _isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _isChecked = value ?? false;
                                          });
                                        },
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          launch(
                                              'https://tan-q-bot-unofficial.com/terms_of_service/');
                                        },
                                        child: const Text(
                                          '利用規約に同意した？',
                                          style: TextStyle(
                                              color: Colors.lightGreen,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline),
                                        )),
                                  ],
                                ),
                                SizedBox(height: 5.0.h),
                                Container(
                                  alignment: const Alignment(-1.0, 0.0),
                                  padding: const EdgeInsets.only(
                                      top: 15.0, left: 10),
                                  child: InkWell(
                                      child: const Text(
                                        'パスワードを忘れた方へ',
                                        style: TextStyle(
                                            color: Colors.lightGreen,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat',
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              title: const Text(
                                                "パスワードを忘れた人へ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    const SizedBox(
                                                        width: 100,
                                                        height: 100,
                                                        child: Image(
                                                          image: AssetImage(
                                                              'assets/icon/password.gif'),
                                                          fit: BoxFit.cover,
                                                        )),
                                                    const Text(
                                                      '下のテキストボックスにメールアドレスを入力して、リセットボタンを押してください。',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    TextField(
                                                      decoration: const InputDecoration(
                                                          labelText: 'メールアドレス',
                                                          labelStyle: TextStyle(
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.grey),
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.lightGreen))),
                                                      onChanged:
                                                          (String value) {
                                                        setState(() {
                                                          _login_forgot_Email =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ]),
                                              actions: <Widget>[
                                                // ボタン領域
                                                TextButton(
                                                  child: const Text("やっぱやめる"),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                                TextButton(
                                                    child: const Text("リセットする"),
                                                    onPressed: () {
                                                      _auth.sendPasswordResetEmail(
                                                          email:
                                                              _login_forgot_Email);

                                                      showDialog(
                                                          context: context,
                                                          builder: (_) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                "パスワードリセット完了",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              content:
                                                                  const Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  SizedBox(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          Image(
                                                                        image: AssetImage(
                                                                            'assets/icon/rocket.gif'),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )),
                                                                  Text(
                                                                    "入力してくれたメールアドレス宛にパスワードリセットをするメールを送信しました。\nもし届いていない場合は迷惑メールフォルダーを確認してください。",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          "オッケー"),
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    }),
                                              ],
                                            );
                                          },
                                        );
                                      }),
                                ),
                              ],
                            ),
                            //エラー表示

                            //エラー表示（ここまで）
                            SizedBox(height: 10.0.h),

                            //ログインボタン
                            GestureDetector(
                              onTap: _isChecked
                                  ? () async {
                                      Fluttertoast.showToast(
                                          msg: "ログイン中です\nちょっと待ってね。");
                                      try {
                                        // メール/パスワードでログイン
                                        UserCredential result = await _auth
                                            .signInWithEmailAndPassword(
                                          email: _login_Email,
                                          password: _login_Password,
                                        );

                                        // ログイン成功
                                        User user =
                                            result.user!; // ログインユーザーのIDを取得

                                        // Email確認が済んでいる場合のみHome画面へ
                                        if (user.emailVerified) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return const MyHomePage(
                                                title: 'home');
                                          }));
                                          Fluttertoast.showToast(
                                              msg: "ログインしました");

                                          DocumentReference userDoc =
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user.uid);

                                          userDoc
                                              .get()
                                              .then((docSnapshot) async {
                                            if (!docSnapshot.exists) {
                                              await userDoc.set({
                                                'email': _login_Email,
                                                'uid': user.uid,
                                                'displayName': '名前未設定',
                                                'day': DateFormat(
                                                        'yyyy/MM/dd(E) HH:mm:ss')
                                                    .format(now),
                                                'photoURL':
                                                    'https://pbs.twimg.com/profile_images/1439164154502287361/1dyVrzQO_400x400.jpg',
                                              });
                                              print("Created");
                                            } else {
                                              print("User already exists");
                                            }
                                          });
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
                                          Fluttertoast.showToast(
                                              msg: "ログインしました");
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        String errorMessage;
                                        if (e.code == 'weak-password') {
                                          errorMessage = 'パスワードが弱すぎます';
                                        } else if (e.code ==
                                            'email-already-in-use') {
                                          errorMessage = 'そのメールアドレスは既に登録されています';
                                        } else if (e.code == 'invalid-email') {
                                          errorMessage = '無効なメールアドレスです';
                                        } else if (e.code == 'user-not-found') {
                                          errorMessage = 'ユーザーが見つかりませんでした';
                                        } else if (e.code == 'wrong-password') {
                                          errorMessage = 'パスワードが間違っています';
                                        } else {
                                          errorMessage = 'エラーが発生しました';
                                        }
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('エラー'),
                                              content: Text(_infoText),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('OK'),
                                                  onPressed: () {
                                                    // OKボタンが押されたときの処理
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        print(
                                            'FirebaseAuthのエラー: $errorMessage');
                                        setState(() {
                                          _infoText = errorMessage;
                                        });
                                      }
                                    }
                                  : () {
                                      Fluttertoast.showToast(
                                          msg: "利用規約に同意してね！"); // ボタンが無効なときの処理
                                    },
                              child: SizedBox(
                                height: 40.0.h,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.lightGreen[200],
                                  child: Container(
                                      child: const Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Center(
                                          child: Text(
                                        'サインイン',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ))
                                    ],
                                  )),
                                ),
                              ),
                            ),

                            //ログインボタンここまで
                            SizedBox(height: 20.0.h),
                            //大学のアカウントでログイン
                            GestureDetector(
                              onTap: _isChecked
                                  ? () async {
                                      Fluttertoast.showToast(
                                          msg: "ログイン中です\nちょっと待ってね。");
                                      try {
                                        // メール/パスワードでログイン
                                        final userCredential =
                                            await signInWithGoogle();
                                        // ログインに成功した場合
                                        // チャット画面に遷移＋ログイン画面を破棄
                                        await Navigator.of(context)
                                            .pushReplacement(
                                                MaterialPageRoute(builder:
                                                    (context) {
                                          return const MyHomePage(
                                              title: 'home');
                                        }),
                                                result: Fluttertoast.showToast(
                                                    msg: "大学のアカウントでログインしました"));
                                      } on PlatformException {}
                                    }
                                  : () {
                                      Fluttertoast.showToast(
                                          msg: "利用規約に同意してね！"); // ボタンが無効なときの処理
                                    },
                              child: SizedBox(
                                height: 40.0.h,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.lightGreen,
                                          style: BorderStyle.solid,
                                          width: 1.0.w),
                                      color: Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: const Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '大学のアカウントでサインイン',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            //大学のアカウントでログイン（ここまで）
                            SizedBox(height: 20.0.h),
                            //Appleでサインイン

                            if (Platform.isIOS)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, right: 0, bottom: 20, left: 0),
                                child: GestureDetector(
                                  onTap: _isChecked
                                      ? () async {
                                          showDialog(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                title: const Text(
                                                  "注意",
                                                  textAlign: TextAlign.center,
                                                ),
                                                content: const Text(
                                                  "大学のアカウント以外でログインしようとしています。\n講義評価など一部の機能が使えないですがよろしいですか？\n※新入生の人は大学のアカウントが発行されるまで待ってね。",
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: <Widget>[
                                                  // ボタン領域
                                                  TextButton(
                                                    child: const Text("やっぱやめる"),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                  TextButton(
                                                      child: const Text("ええで"),
                                                      onPressed: () async {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "ログイン中です\nちょっと待ってね。");
                                                        AppleSignIn(); // ボタンをタップしたときの処理
                                                      }),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      : () {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "利用規約に同意してね！"); // ボタンが無効なときの処理 // ボタンが無効なときの処理
                                        },
                                  child: SizedBox(
                                    height: 40.0.h,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                              style: BorderStyle.solid,
                                              width: 1.0.w),
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: const Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.apple, //設定したいアイコンのID
                                          ),
                                          Text(
                                            'Appleでサインイン',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                ),
                              ),

                            if (Platform.isAndroid) SizedBox(height: 0.h),

                            GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Registration()),
                                );
                              },
                              child: SizedBox(
                                height: 40.0.h,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.lightGreen,
                                          style: BorderStyle.solid,
                                          width: 1.0.w),
                                      color: Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: const Center(
                                    child: Text(
                                      'サインアップ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            //Appleでサインイン（ここまで）
                            SizedBox(height: 20.0.h),

                            //サインアップ

                            //サインアップ（ここまで）
                            //ゲストモード

                            /*  Container(
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
                                  onTap: _isChecked
                                      ? () async {
                                          showDialog(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                title: Text(
                                                  "⚠️注意⚠️",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        '会員登録なしで続行します。\n\nただセキュリティ上の理由により',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        '30日後にアカウントが消去されます',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                                      ),
                                                      Text(
                                                        'データを保存する場合は登録をするか\n大学のアカウントでログインしてください\n\n',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'また講義評価の書き込みなど一部の機能は使用できません。\n',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ]),
                                                actions: <Widget>[
                                                  // ボタン領域
                                                  TextButton(
                                                    child: Text("やっぱやめる"),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                  TextButton(
                                                    child: Text("構わんよ"),
                                                    onPressed: () =>
                                                        _onSignInWithAnonymousUser(),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      : () {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "利用規約に同意してね！"); // ボタンが無効なときの処理 // ボタンが無効なときの処理
                                        },
                                  child: Center(
                                    child: Text(
                                      'ゲストモードで使用',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            //ゲストモード（ここまで）
                           */
                            SizedBox(height: 50.0.h),
                          ],
                        )),
                  ],
                )))));
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'ユーザーによって操作が中止されました',
      );
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    // Sign in with the credential and return the UserCredential
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(GoogleAuthProvider.credential(
      idToken: credential.idToken,
      accessToken: credential.accessToken,
    ));

    // Firestoreにユーザー情報が存在しない場合、ユーザー情報を書き込む
    final User? user = userCredential.user;
    final firestoreInstance = FirebaseFirestore.instance;
    DocumentReference userDoc =
        firestoreInstance.collection('users').doc(user!.uid);

    userDoc.get().then((docSnapshot) async {
      if (!docSnapshot.exists) {
        await userDoc.set({
          'displayName': user.displayName,
          'uid': user.uid,
          'email': user.email,
          'photoURL': user.photoURL,
          'day': DateFormat('yyyy/MM/dd(E) HH:mm:ss').format(now)
        });
        print("Created");
      } else {
        print("User already exists");
      }
    });

    return userCredential;
  }
}

// Firebase Authentication利用時の日本語エラーメッセージ
class Authentication_error_to_ja {
  // ログイン時の日本語エラーメッセージ
  login_error_msg(int errorCode, String orgErrorMsg) {
    String errorMsg;

    if (errorCode == 360587416) {
      errorMsg = '有効なメールアドレスを入力してください。';
    } else if (errorCode == 505284406) {
      // 入力されたメールアドレスが登録されていない場合
      errorMsg = 'メールアドレスかパスワードが間違っています。';
    } else if (errorCode == 185768934) {
      // 入力されたパスワードが間違っている場合
      errorMsg = 'メールアドレスかパスワードが間違っています。';
    } else if (errorCode == 362765553) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      errorMsg = 'メールアドレスとパスワードを入力してください。';
    } else {
      errorMsg = '$orgErrorMsg[$errorCode]';
    }

    return errorMsg;
  }

  // アカウント登録時の日本語エラーメッセージ
  register_error_msg(int errorCode, String orgErrorMsg) {
    String errorMsg;

    if (errorCode == 360587416) {
      errorMsg = '有効なメールアドレスを入力してください。';
    } else if (errorCode == 34618382) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      errorMsg = '既に登録済みのメールアドレスです。';
    } else if (errorCode == 447031946) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      errorMsg = 'メールアドレスとパスワードを入力してください。';
    } else {
      errorMsg = '$orgErrorMsg[$errorCode]';
    }

    return errorMsg;
  }
}
