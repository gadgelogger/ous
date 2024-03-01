// Dart imports:
import 'dart:io';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_review/in_app_review.dart';
// Project imports:
import 'package:ous/account/login.dart';
import 'package:ous/setting/music.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share/share.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isDarkModeEnabled = false;

  //アプリバージョン表示
  String _version = '';

  Future getVer() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  //退会処理
  void deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;

    // ユーザーを削除
    await user?.delete();
    await FirebaseAuth.instance.signOut();
    debugPrint('ユーザーを削除しました!');
    Fluttertoast.showToast(msg: "アカウントを削除しました\nご利用ありがとうございました。");
  }

//退会処理

  ThemeData current = ThemeData.light();

  void showLicensePage({
    required BuildContext context,
    String? applicationName,
    String? applicationVersion,
    Widget? applicationIcon,
    String? applicationLegalese,
    bool useRootNavigator = false,
  }) {
    Navigator.of(context, rootNavigator: useRootNavigator)
        .push(MaterialPageRoute<void>(
      builder: (BuildContext context) => LicensePage(
        applicationName: "岡理アプリ",
        applicationIcon: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset('assets/images/icon.png'),
            ),
          ),
        ),
        applicationLegalese: "@TAN_Q_BOT_LOCAL",
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    getVer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('アプリの設定'),
      ),
      body: SettingsList(sections: [
        SettingsSection(
          title: Text(
            '基本的な設定',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
                leading: const Icon(Icons.music_note),
                title: const Text('校歌'),
                onPressed: (context) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const Music(),
                  ));
                }),
            SettingsTile.navigation(
              leading: const Icon(Icons.description),
              title: const Text('利用規約について'),
              onPressed: (context) {
                launchUrlString(
                    'https://tan-q-bot-unofficial.com/terms_of_service/');
              },
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.reply),
              title: const Text('記事の掲載元'),
              onPressed: (context) {
                launchUrlString('https://www.ous.ac.jp/topics/');
              },
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.email),
              title: const Text('お問合わせ'),
              onPressed: (context) {
                launchUrlString('https://twitter.com/notifications');
              },
            ),
            SettingsTile.navigation(
                leading: const Icon(Icons.terminal),
                title: const Text('ライセンスについて'),
                onPressed: (context) {
                  showLicensePage(context: context);
                }),
            SettingsTile.navigation(
              leading: const Icon(Icons.description),
              title: const Text('開発ロードマップ'),
              onPressed: (context) {
                launchUrlString(
                    'https://laced-egret-3b6.notion.site/7f9bc72309ab4fa2a5dcb1dc7aa256ea');
              },
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.rate_review),
              title: const Text('このアプリを評価する'),
              onPressed: (BuildContext context) async {
                final InAppReview inAppReview = InAppReview.instance;
                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                }
              },
            ),
            if (Platform.isIOS)
              SettingsTile.navigation(
                leading: const Icon(Icons.share),
                title: const Text('このアプリをシェアする'),
                onPressed: (BuildContext context) async {
                  Share.share(
                      'https://apps.apple.com/jp/app/%E5%B2%A1%E7%90%86%E3%82%A2%E3%83%97%E3%83%AA/id1671546931');
                },
              ),
            if (Platform.isAndroid)
              SettingsTile.navigation(
                leading: const Icon(Icons.share),
                title: const Text('このアプリをシェアする'),
                onPressed: (BuildContext context) async {
                  Share.share(
                      'https://play.google.com/store/apps/details?id=com.ous.unoffical.app');
                },
              ),
            if (Platform.isIOS)
              SettingsTile.navigation(
                leading: const Icon(Icons.public_outlined),
                title: const Text('アプリの公式サイト'),
                onPressed: (context) {
                  launchUrlString('https://ous-unoffical-app.studio.site');
                },
              ),
          ],
        ),
        SettingsSection(
          title: Text(
            'アプリについて',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          tiles: <SettingsTile>[
            SettingsTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('アプリのバージョン'),
              value: Text(_version),
            ),
          ],
        ),
        SettingsSection(
          title: Text(
            'アカウント関連',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'ログアウトする',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: (BuildContext context) async {
                showDialog(
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
                            // ログアウト処理
                            // 内部で保持しているログイン情報等が初期化される
                            FirebaseAuth.instance.signOut();
                            // ログイン画面に遷移＋チャット画面を破棄
                            await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                                return const Login();
                              }),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'アカウントを削除する。',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: (BuildContext context) async {
                showDialog(
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
                                        outerColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        text: 'スライドして退会',
                                        textStyle:
                                            const TextStyle(fontSize: 20),
                                        onSubmit: () async {
                                          //退会処理
                                          deleteUser();
                                          debugPrint('ユーザーを削除しました!');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Login()));
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ]),
    );
  }
}
