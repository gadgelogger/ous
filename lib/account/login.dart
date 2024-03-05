// Dart imports:
import 'dart:io';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
// Project imports:
import 'package:ous/account/tutorial.dart';
import 'package:ous/home.dart';
import 'package:ous/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  // Firebase 認証
  final auth = FirebaseAuth.instance;

  String infoText = ""; // ログインに関する情報を表示

  final DateTime now = DateTime.now();
  //ユーザー情報保存
  CollectionReference users = FirebaseFirestore.instance.collection('users');

//Appleサインイン

  Future<UserCredential?> appleSignIn() async {
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

    userRef.set(
      {
        'uid': firebaseUser?.uid ?? '未設定',
        'email': firebaseUser?.email ?? '未設定',
        'displayName': firebaseUser?.displayName ?? '名前未設定',
        'photoURL': firebaseUser?.photoURL ??
            'https://pbs.twimg.com/profile_images/1439164154502287361/1dyVrzQO_400x400.jpg',
        'day': DateFormat('yyyy/MM/dd(E) HH:mm:ss').format(now),

        // その他のユーザー情報を追加
      },
      SetOptions(merge: true),
    );

    // ログイン処理が終わった後に画面遷移を行う
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const MyHomePage(title: 'home');
        },
      ),
    );

    Fluttertoast.showToast(msg: "Appleでログインしました");

    return authResult;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showTutorial(context));

    return ShowCaseWidget(
      builder: Builder(
        builder: (context) => PopScope(
          canPop: false,
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
                          child: Text(
                            'Hello',
                            style: TextStyle(
                              fontSize: 80.0.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(13),
                            top: ScreenUtil().setWidth(180),
                          ),
                          child: Text(
                            'OUS',
                            style: TextStyle(
                              fontSize: 80.0.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 35.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20.0.h),
                          //大学のアカウントでログイン
                          GestureDetector(
                            onTap: () async {
                              Fluttertoast.showToast(
                                msg: "ログイン中です\nちょっと待ってね。",
                              );
                              try {
                                // メール/パスワードでログイン
                                // ignore: unused_local_variable
                                final userCredential = await signInWithGoogle();
                                // ログインに成功した場合
                                // チャット画面に遷移＋ログイン画面を破棄
                                await Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const MyHomePage(
                                        title: 'home',
                                      );
                                    },
                                  ),
                                  result: Fluttertoast.showToast(
                                    msg: "大学のアカウントでログインしました",
                                  ),
                                );
                              } on PlatformException {
                                Fluttertoast.showToast(
                                  msg: "ログインに失敗しました",
                                );
                              }
                            },
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                fixedSize: const Size.fromWidth(
                                  double.maxFinite,
                                ), //横幅に最大限のサイズを
                                shape: const StadiumBorder(),
                                side: const BorderSide(
                                  color: Colors.lightGreen,
                                ),
                              ),
                              onPressed: () async {
                                Fluttertoast.showToast(
                                  msg: "ログイン中です\nちょっと待ってね。",
                                );
                                try {
                                  // メール/パスワードでログイン
                                  // ignore: unused_local_variable
                                  final userCredential =
                                      await signInWithGoogle();
                                  // ログインに成功した場合
                                  // チャット画面に遷移＋ログイン画面を破棄
                                  await Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const MyHomePage(
                                          title: 'home',
                                        );
                                      },
                                    ),
                                    result: Fluttertoast.showToast(
                                      msg: "大学のアカウントでログインしました",
                                    ),
                                  );
                                } on PlatformException {
                                  Fluttertoast.showToast(
                                    msg: "ログインに失敗しました",
                                  );
                                }
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
                              padding: EdgeInsets.only(
                                bottom: 20.0.h,
                              ),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                onPressed: () async {
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
                                            child: const Text(
                                              "やっぱやめる",
                                            ),
                                            onPressed: () => Navigator.pop(
                                              context,
                                            ),
                                          ),
                                          TextButton(
                                            child: const Text(
                                              "ええで",
                                            ),
                                            onPressed: () async {
                                              Fluttertoast.showToast(
                                                msg: "ログイン中です\nちょっと待ってね。",
                                              );
                                              appleSignIn(); // ボタンをタップしたときの処理
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.apple,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    Text(
                                      'Appleでサインイン',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          if (Platform.isAndroid) SizedBox(height: 0.h),
                          const SizedBox(height: 0),
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
                                decoration: TextDecoration.underline,
                              ),
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
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: const Text("ええで"),
                                        onPressed: () async {
                                          Fluttertoast.showToast(
                                            msg: "ログイン中です\nちょっと待ってね。",
                                          );
                                          signInAnonymously();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 50.0.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 匿名ログイン
  Future<UserCredential?> signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();

      // Navigate to the next screen after successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );

      return userCredential;
    } catch (e) {
      // Handle any errors that occur during the login process
      debugPrint('Error signing in anonymously: $e');
      return null;
    }
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
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(
      GoogleAuthProvider.credential(
        idToken: credential.idToken,
        accessToken: credential.accessToken,
      ),
    );

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
          'day': DateFormat('yyyy/MM/dd(E) HH:mm:ss').format(now),
        });
        debugPrint("Created");
      } else {
        debugPrint("User already exists");
      }
    });

    return userCredential;
  }

//初回チュートリアル表示
  void _showTutorial(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();

    if (pref.getBool('isAlreadyFirstLaunch') != true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Tutorial(),
          fullscreenDialog: true,
        ),
      );
      pref.setBool('isAlreadyFirstLaunch', true);
    }
  }
}
