// services/setting_service.dart

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:slide_to_act/slide_to_act.dart';

// Project imports:
import 'package:ous/presentation/pages/account/login_screen.dart';

class SettingService {
  static Future<void> deleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    await user?.delete();
    await FirebaseAuth.instance.signOut();
    debugPrint('ユーザーを削除しました!');
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
    );
    Fluttertoast.showToast(msg: "アカウントを削除しました\nご利用ありがとうございました。");
  }

  static Future<dynamic> deleteAccountDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "アカウントを削除します。",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text(
            "本当に良いか？\n全てのデータが消えるぞ。\n\n\n※一度アカウントを削除すると戻すことはできません。",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            // ボタン領域
            TextButton(
              child: const Text("やっぱやめる"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text(
                        "最終確認。",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      content: const Text(
                        "本当に良いか？\n引き返せないで。\n※画面外をタップで戻れます",
                        textAlign: TextAlign.center,
                      ),
                      actions: <Widget>[
                        SlideAction(
                          outerColor: Theme.of(context).colorScheme.secondary,
                          text: 'スライドして退会',
                          textStyle: const TextStyle(fontSize: 20),
                          onSubmit: () async {
                            //退会処理
                            SettingService.deleteAccount(
                              context,
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
    );
    Fluttertoast.showToast(msg: "ログアウトしました");
  }

  static Future<dynamic> logoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("ログアウトします。"),
          content: const Text("ログインページに戻るけどいい？"),
          actions: <Widget>[
            // ボタン領域
            TextButton(
              child: const Text("ダメやで"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("ええで"),
              onPressed: () async {
                SettingService.logout(context);
              },
            ),
          ],
        );
      },
    );
  }
}
