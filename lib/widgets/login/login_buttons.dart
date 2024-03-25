// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Project imports:
import 'package:ous/api/service/login_auth_service.dart';
import 'package:ous/screens/main_screen.dart';

class AppleSignInButton extends StatelessWidget {
  final AuthService _authService;

  const AppleSignInButton({
    Key? key,
    required AuthService authService,
  })  : _authService = authService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
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
                    final result = await _authService.signInWithApple();
                    if (!context.mounted || result == null) {
                      return; // ユーザーがサインインをキャンセルした場合はここで処理を終了
                    }

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
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
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final AuthService _authService;

  const GoogleSignInButton({
    Key? key,
    required AuthService authService,
  })  : _authService = authService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightGreen[300],
        fixedSize: const Size.fromWidth(
          double.maxFinite,
        ), //横幅に最大限のサイズを
        shape: const StadiumBorder(),
      ),
      onPressed: () async {
        Fluttertoast.showToast(msg: "ログイン中です\nちょっと待ってね。");
        final userCredential = await _authService.signInWithGoogle();
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
    );
  }
}

class GuestSignInButton extends StatelessWidget {
  final AuthService _authService;

  const GuestSignInButton({
    Key? key,
    required AuthService authService,
  })  : _authService = authService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                    final result = await _authService.signInAnonymously();
                    if (result != null && context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => MainScreen(),
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
    );
  }
}

class PrivacyPolicyButton extends StatelessWidget {
  const PrivacyPolicyButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
