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
import 'package:showcaseview/showcaseview.dart';
import 'package:ous/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'email_check.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  //利用規約に同意したかの確認
  bool isChecked = false;

  // Firebase 認証
  final auth = FirebaseAuth.instance;

  String loginEmail = ""; // 入力されたメールアドレス
  String loginPassword = ""; // 入力されたパスワード
  String loginForgotEmail = ""; // 入力されたパスワード

  String infoText = ""; // ログインに関する情報を表示

  final DateTime now = DateTime.now();
  //スポットライト
  final GlobalKey spot = GlobalKey();
  //ユーザー情報保存
  CollectionReference users = FirebaseFirestore.instance.collection('users');

//Appleサインイン

  Future<UserCredential?> appleSignIn() async {
    final navigator =
        Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const MyHomePage(title: 'home');
    }));
    final rawNonce = generateNonce();

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

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
    await navigator;
    Fluttertoast.showToast(msg: "Appleでログインしました");

    return authResult;
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

    Future<bool> willPopCallback() async {
      return true;
    }

    return ShowCaseWidget(
      builder: Builder(
          builder: (context) => WillPopScope(
              onWillPop: willPopCallback,
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(15),
                                  top: ScreenUtil().setWidth(110),
                                ),
                                child: Text('Hello',
                                    style: TextStyle(
                                        fontSize: 80.0.sp,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(13),
                                    top: ScreenUtil().setWidth(180)),
                                child: Text('OUS',
                                    style: TextStyle(
                                        fontSize: 80.0.sp,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
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
                                        loginEmail = value;
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
                                        loginPassword = value;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 5.0.h,
                                  ),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Showcase(
                                        // このkeyは重複してはいけません
                                        key: spot,
                                        title: '利用規約に同意してね！',
                                        description: '利用規約に同意してチェックマークを入れてください',
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0,
                                                    color: Colors.transparent),
                                              ),
                                              child: Checkbox(
                                                value: isChecked,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    isChecked = value ?? false;
                                                  });
                                                },
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  final url = Uri.parse(
                                                      'https://tan-q-bot-unofficial.com/terms_of_service/');
                                                  launchUrl(url);
                                                },
                                                child: const Text(
                                                  '利用規約に同意した？',
                                                  style: TextStyle(
                                                      color: Colors.lightGreen,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: TextDecoration
                                                          .underline),
                                                )),
                                          ],
                                        ),
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
                                                      textAlign:
                                                          TextAlign.center,
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
                                                                fit: BoxFit
                                                                    .cover,
                                                              )),
                                                          const Text(
                                                            '下のテキストボックスにメールアドレスを入力して、リセットボタンを押してください。',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          TextField(
                                                            decoration: const InputDecoration(
                                                                labelText:
                                                                    'メールアドレス',
                                                                labelStyle: TextStyle(
                                                                    fontFamily:
                                                                        'Montserrat',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .grey),
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.lightGreen))),
                                                            onChanged:
                                                                (String value) {
                                                              setState(() {
                                                                loginForgotEmail =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ]),
                                                    actions: <Widget>[
                                                      // ボタン領域
                                                      TextButton(
                                                        child: const Text(
                                                            "やっぱやめる"),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                      ),
                                                      TextButton(
                                                          child: const Text(
                                                              "リセットする"),
                                                          onPressed: () {
                                                            auth.sendPasswordResetEmail(
                                                                email:
                                                                    loginForgotEmail);

                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (_) {
                                                                  return AlertDialog(
                                                                    title:
                                                                        const Text(
                                                                      "パスワードリセット完了",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                                                              image: AssetImage('assets/icon/rocket.gif'),
                                                                              fit: BoxFit.cover,
                                                                            )),
                                                                        Text(
                                                                          "入力してくれたメールアドレス宛にパスワードリセットをするメールを送信しました。\nもし届いていない場合は迷惑メールフォルダーを確認してください。",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        child: const Text(
                                                                            "オッケー"),
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
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
                                  ElevatedButton(
                                    onPressed: isChecked
                                        ? () async {
                                            Fluttertoast.showToast(
                                                msg: "ログイン中です\nちょっと待ってね。");
                                            try {
                                              // メール/パスワードでログイン
                                              UserCredential result = await auth
                                                  .signInWithEmailAndPassword(
                                                email: loginEmail,
                                                password: loginPassword,
                                              );

                                              // ログイン成功
                                              User user = result
                                                  .user!; // ログインユーザーのIDを取得

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
                                                      'email': loginEmail,
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
                                                    print(
                                                        "User already exists");
                                                  }
                                                });
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Emailcheck(
                                                              email: loginEmail,
                                                              pswd:
                                                                  loginPassword,
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
                                                errorMessage =
                                                    'そのメールアドレスは既に登録されています';
                                              } else if (e.code ==
                                                  'invalid-email') {
                                                errorMessage = '無効なメールアドレスです';
                                              } else if (e.code ==
                                                  'user-not-found') {
                                                errorMessage =
                                                    'ユーザーが見つかりませんでした';
                                              } else if (e.code ==
                                                  'wrong-password') {
                                                errorMessage = 'パスワードが間違っています';
                                              } else {
                                                errorMessage = 'エラーが発生しました';
                                              }
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('エラー'),
                                                    content: Text(infoText),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text('OK'),
                                                        onPressed: () {
                                                          // OKボタンが押されたときの処理
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              print(
                                                  'FirebaseAuthのエラー: $errorMessage');
                                              setState(() {
                                                infoText = errorMessage;
                                              });
                                            }
                                          }
                                        : () {
                                            // ボタンが無効なときの処理
                                            ShowCaseWidget.of(context)
                                                .startShowCase([spot]);
                                          },
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: const Size.fromWidth(
                                            double.maxFinite),
                                        backgroundColor: Colors.lightGreen,
                                        splashFactory: InkSplash.splashFactory),
                                    child: Text('大学のアカウントでサインイン',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat')),
                                  ),

                                  //ログインボタンここまで
                                  SizedBox(height: 20.0.h),
                                  //大学のアカウントでログイン
                                  GestureDetector(
                                    onTap: isChecked
                                        ? () async {
                                            Fluttertoast.showToast(
                                                msg: "ログイン中です\nちょっと待ってね。");
                                            try {
                                              // メール/パスワードでログイン
                                              // ignore: unused_local_variable
                                              final userCredential =
                                                  await signInWithGoogle();
                                              // ログインに成功した場合
                                              // チャット画面に遷移＋ログイン画面を破棄
                                              await Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                return const MyHomePage(
                                                    title: 'home');
                                              }),
                                                      result: Fluttertoast
                                                          .showToast(
                                                              msg:
                                                                  "大学のアカウントでログインしました"));
                                            } on PlatformException {}
                                          }
                                        : () {
                                            ShowCaseWidget.of(context)
                                                .startShowCase([spot]);
                                          },
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        fixedSize: const Size.fromWidth(
                                            double.maxFinite), //横幅に最大限のサイズを
                                        shape: const StadiumBorder(),
                                        side: const BorderSide(
                                            color: Colors.lightGreen),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Registration()),
                                        );
                                      },
                                      child: const Text(
                                        '大学のアカウントでサインイン',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ),
                                  ),
                                  //大学のアカウントでログイン（ここまで）
                                  SizedBox(height: 20.0.h),
                                  //Appleでサインイン

                                  if (Platform.isIOS)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0,
                                          right: 0,
                                          bottom: 20,
                                          left: 0),
                                      child: GestureDetector(
                                        onTap: isChecked
                                            ? () async {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "注意",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      content: const Text(
                                                        "大学のアカウント以外でログインしようとしています。\n講義評価など一部の機能が使えないですがよろしいですか？\n※新入生の人は大学のアカウントが発行されるまで待ってね。",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      actions: <Widget>[
                                                        // ボタン領域
                                                        TextButton(
                                                          child: const Text(
                                                              "やっぱやめる"),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                        ),
                                                        TextButton(
                                                            child: const Text(
                                                                "ええで"),
                                                            onPressed:
                                                                () async {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "ログイン中です\nちょっと待ってね。");
                                                              appleSignIn(); // ボタンをタップしたときの処理
                                                            }),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            : () {
                                                ShowCaseWidget.of(context)
                                                    .startShowCase(
                                                        [spot]); // ボタンが無効なときの処理
                                              },
                                        child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              fixedSize: const Size.fromWidth(
                                                  double
                                                      .maxFinite), //横幅に最大限のサイズを
                                              shape: const StadiumBorder(),
                                              side: const BorderSide(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Registration()),
                                              );
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.apple,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  'Appleでサインイン',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.black),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),

                                  if (Platform.isAndroid) SizedBox(height: 0.h),

                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      fixedSize: const Size.fromWidth(
                                          double.maxFinite), //横幅に最大限のサイズを
                                      shape: const StadiumBorder(),
                                      side: const BorderSide(
                                          color: Colors.lightGreen),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Registration()),
                                      );
                                    },
                                    child: const Text(
                                      'サインアップ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                  //Appleでサインイン（ここまで）

                                  SizedBox(height: 20.0.h),
                                  //ゲストモード
                                  InkWell(
                                    child: const Text(
                                      'ゲストモードでログイン',
                                      style: TextStyle(
                                          color: Colors.lightGreen,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat',
                                          decoration: TextDecoration.underline),
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text(
                                              "注意",
                                              textAlign: TextAlign.center,
                                            ),
                                            content: const Text(
                                              "ゲストモードでログインしようとしています。\n講義評価など一部の機能が使えません\nまた30日後にアカウントが自動的に削除されます",
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
                                                    signInAnonymously();
                                                  }),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(height: 50.0.h),
                                ],
                              )),
                        ],
                      )))))),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // GoogleSignInインスタンスを作成
    final GoogleSignIn googleSignIn = GoogleSignIn(
      // 制限したいドメインを指定
      hostedDomain: 'ous.jp',
    );

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

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

//匿名ログイン
  Future<UserCredential?> signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      return userCredential;
    } catch (e) {
      // Handle any errors that occur during the login process
      print('Error signing in anonymously: $e');
      return null;
    }
  }
}
