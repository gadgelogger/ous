// Dart imports:
import 'dart:io';

import 'package:flutter/foundation.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ous/api/service/login_auth_service.dart';
import 'package:ous/screens/main_screen.dart';
// Project imports:
import 'package:ous/screens/tutorial_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showTutorial(context));

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_background.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SingleChildScrollView(
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
                            fontSize: 80.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
                            fontSize: 80.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 200,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.h),
                        //大学のアカウントでログイン
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen[300],
                            fixedSize: const Size.fromWidth(
                              double.maxFinite,
                            ), //横幅に最大限のサイズを
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () async {
                            Fluttertoast.showToast(msg: "ログイン中です\nちょっと待ってね。");
                            final userCredential =
                                await _authService.signInWithGoogle();
                            if (userCredential == null || !context.mounted) {
                              return;
                            }

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => MainScreen(),
                              ),
                            );
                            Fluttertoast.showToast(msg: "大学のアカウントでログインしました");
                          },
                          child: const Text(
                            '大学のアカウントでサインイン',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 46, 96, 47),
                            ),
                          ),
                        ),
                        //大学のアカウントでログイン（ここまで）
                        SizedBox(height: 20.h),
                        //Appleでサインイン

                        if (!kIsWeb && Platform.isIOS)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.black,
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
                                        "大学のアカウント以外でログインしようとしています。\n講義評価など一部の機能が使えないですがよろしいですか？\n\n※新入生の人は大学のアカウントが発行されるまで待ってね。",
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
                                            final result = await _authService
                                                .signInWithApple();
                                            if (!context.mounted ||
                                                result == null) {
                                              return; // ユーザーがサインインをキャンセルした場合はここで処理を終了
                                            }

                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MainScreen(),
                                              ),
                                            );
                                            Fluttertoast.showToast(
                                              msg: "Appleでログインしました",
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.apple,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Appleでサインイン',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        if (!kIsWeb && Platform.isAndroid)
                          const SizedBox(height: 0),
                        const SizedBox(height: 0),
                        //Appleでサインイン（ここまで）

                        const SizedBox(height: 20.0),
                        //ゲストモード
                        GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text(
                                    "注意",
                                    textAlign: TextAlign.center,
                                  ),
                                  content: const Text(
                                    "ゲストモードでログインしようとしています。\n講義評価など一部の機能が使えないですがよろしいですか？\n\n※新入生の人は大学のアカウントが発行されるまで待ってね。",
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
                                        Navigator.pop(context); // ダイアログを閉じる
                                        Fluttertoast.showToast(
                                          msg: "ログイン中です\nちょっと待ってね。",
                                        );
                                        final result = await _authService
                                            .signInAnonymously();
                                        if (result != null && context.mounted) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen(),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            '会員登録せずに使う（ゲストモード）',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () => launchUrlString(
                            'https://tan-q-bot-unofficial.com/terms_of_service/',
                          ),
                          child: const Text(
                            '利用規約はこちら',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 50.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//初回チュートリアル表示
  void _showTutorial(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();

    if (pref.getBool('isAlreadyFirstLaunch') != true) {
      if (!context.mounted) return;

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
