import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ous/account/login.dart';
import 'package:ous/setting/music.dart';
import 'package:ous/Nav/userpolicie.dart';
import 'package:ous/setting/payment.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:ous/home.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'globals.dart';

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
    final uid = user?.uid;

    // ユーザーを削除
    await user?.delete();
    await FirebaseAuth.instance.signOut();
    print('ユーザーを削除しました!');
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
    assert(context != null);
    assert(useRootNavigator != null);
    Navigator.of(context, rootNavigator: useRootNavigator)
        .push(MaterialPageRoute<void>(
      builder: (BuildContext context) => LicensePage(
        applicationName: "非公式岡理アプリ",
        applicationIcon: Container(
          width: 100,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image.asset('assets/images/icon.png'),
          ),
        ),
        applicationLegalese: "@TAN_Q_BOT_LOCAL",
      ),
    ));
  }

  @override
  void initState() {
    getVer();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        context.watch<ThemeProvider>(); // ここで themeProvider を取得
// create some values
    Color pickerColor = Color(0xff443a49);
    Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
    void changeColor(Color color) {
      setState(() => pickerColor = color);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('アプリの設定'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return MyHomePage(title: 'home');
              }),
            );
          },
        ),
      ),
      body: SettingsList(sections: [
        /*  SettingsSection(
            title: Text('基本的な設定',style: TextStyle(color: Colors.lightGreen),),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('言語'),
                value: Text('日本語'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.notifications_none),
                title: Text('通知設定'),
              ),
            ],
          ),

         */
        SettingsSection(
          title: Text(
            'テーマ',
            style: TextStyle(color: Theme.of(context).colorScheme.primary,),
          ),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              title: Text('テーマ'),
              value: Text(themeProvider.themeMode == ThemeMode.system
                  ? 'システム設定に従う'
                  : (themeProvider.themeMode == ThemeMode.light
                      ? 'ライトモード'
                      : 'ダークモード')),
              leading: Icon(Icons.color_lens),
              onPressed: (context) async {
                ThemeMode? newThemeMode = await showDialog<ThemeMode>(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text('テーマを選択'),
                      children: [
                        SimpleDialogOption(
                          child: Text('システム設定に従う'),
                          onPressed: () {
                            Navigator.pop(context, ThemeMode.system);
                          },
                        ),
                        SimpleDialogOption(
                          child: const Text('ライトモード'),
                          onPressed: () {
                            Navigator.pop(context, ThemeMode.light);
                          },
                        ),
                        SimpleDialogOption(
                          child: const Text('ダークモード'),
                          onPressed: () {
                            Navigator.pop(context, ThemeMode.dark);
                          },
                        ),
                      ],
                    );
                  },
                );

                if (newThemeMode != null) {
                  switch (newThemeMode) {
                    case ThemeMode.system:
                      themeProvider.useSystemThemeMode();
                      break;
                    case ThemeMode.light:
                      themeProvider.light();
                      break;
                    case ThemeMode.dark:
                      themeProvider.dark();

                      break;
                  }
                }
              },
            ),
            SettingsTile.navigation(
                leading: Icon(Icons.color_lens_outlined),
                title: Text('色変更'),
             onPressed:(context){

                 showDialog(
                   context: context,
                   builder: (BuildContext context) {
                     Color pickerColor = currentColor;
                     void changeColor(Color color) {
                       pickerColor = color;
                     }
                     List<Color> availableColors = List<Color>.from(Colors.primaries)
                       ..removeWhere((color) => color.value == Colors.black);

                     return AlertDialog(
                       title: const Text('色変更'),
                       content: SingleChildScrollView(
                         child: BlockPicker(
                           pickerColor: pickerColor,
                           onColorChanged: changeColor,
                             availableColors: availableColors,
                         ),
                       ),
                       actions: <Widget>[
                         ElevatedButton(
                           child: const Text('初期状態に戻す'),
                           onPressed: () {
                             Provider.of<AppTheme>(context, listen: false).updateColor(Colors.lightGreen);
                             Navigator.of(context).pop();
                           },
                         ),
                         ElevatedButton(
                           child: const Text('これにする'),
                           onPressed: () {
                             Provider.of<AppTheme>(context, listen: false).updateColor(pickerColor);
                             Navigator.of(context).pop();
                           },
                         ),

                       ],
                     );
                   },
                 );
             }
                ),
          ],
        ),
        SettingsSection(
          title: Text(
            '基本的な設定',
            style: TextStyle(color: Theme.of(context).colorScheme.primary,),
          ),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
                leading: Icon(Icons.music_note),
                title: Text('校歌'),
                onPressed: (context) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => Music(),
                  ));
                }),
            SettingsTile.navigation(
              leading: Icon(Icons.description),
              title: Text('利用規約について'),
              onPressed: (context) {
                launch('https://tan-q-bot-unofficial.com/terms_of_service/');
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.reply),
              title: Text('記事の掲載元'),
              onPressed: (context) {
                launch('https://www.ous.ac.jp/topics/');
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.email),
              title: Text('お問合わせ'),
              onPressed: (context) {
                launch('https://twitter.com/notifications');
              },
            ),
            SettingsTile.navigation(
                leading: Icon(Icons.terminal),
                title: Text('ライセンスについて'),
                onPressed: (context) {
                  showLicensePage(
                    context: context,
                    applicationName: "非公式岡理アプリ",
                    applicationIcon: Image.asset("assets/images/icon.png"),
                    applicationLegalese: "@TAN_Q_BOT_LOCAL",
                  );
                }),
            SettingsTile.navigation(
              leading: Icon(Icons.rate_review),
              title: Text('このアプリを評価する'),
              onPressed: (BuildContext context) async {
                final InAppReview inAppReview = InAppReview.instance;
                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                }
              },
            ),
            if (Platform.isIOS)
              SettingsTile.navigation(
                leading: Icon(Icons.share),
                title: Text('このアプリをシェアする'),
                onPressed: (BuildContext context) async {
                  Share.share(
                      'https://apps.apple.com/jp/app/%E5%B2%A1%E7%90%86%E3%82%A2%E3%83%97%E3%83%AA/id1671546931');
                },
              ),
            if (Platform.isAndroid)
              SettingsTile.navigation(
                leading: Icon(Icons.share),
                title: Text('このアプリをシェアする'),
                onPressed: (BuildContext context) async {
                  Share.share(
                      'https://play.google.com/store/apps/details?id=com.ous.unoffical.app');
                },
              ),
            if (Platform.isIOS)
              SettingsTile.navigation(
                leading: Icon(Icons.public_outlined),
                title: Text('アプリの公式サイト'),
                onPressed: (context) {
                  launch('https://ous-unoffical-app.studio.site');
                },
              ),
          ],
        ),
        SettingsSection(
          title:  Text(
            'アプリについて',
            style: TextStyle(color: Theme.of(context).colorScheme.primary,),
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
            style: TextStyle(color: Theme.of(context).colorScheme.primary,),
          ),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'ログアウトする',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: (BuildContext context) async {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text("ログアウトします。"),
                      content: Text("ログインページに戻るけどいい？"),
                      actions: <Widget>[
                        // ボタン領域
                        TextButton(
                          child: Text("ダメやで"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text("ええで"),
                          onPressed: () async {
                            // ログアウト処理
                            // 内部で保持しているログイン情報等が初期化される
                            await FirebaseAuth.instance.signOut();
                            // ログイン画面に遷移＋チャット画面を破棄
                            await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                                return Login();
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
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'アカウントを削除する。',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: (BuildContext context) async {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text(
                        "アカウントを削除します。",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      content: Text(
                        "本当に良いか？\n全てのデータが消えるぞ。\n\n\n※一度アカウントを削除すると戻すことはできません。",
                        textAlign: TextAlign.center,
                      ),
                      actions: <Widget>[
                        // ボタン領域
                        TextButton(
                          child: Text("やっぱやめる"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text("OK"),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text(
                                      "最終確認。",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    content: Text(
                                      "本当に良いか？\n引き返せないで。\n※画面外をタップで戻れます",
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: <Widget>[
                                      SlideAction(
                                        outerColor: Theme.of(context).colorScheme.primary,
                                        text: 'スライドして退会',
                                        textStyle:
                                            const TextStyle(fontSize: 20),
                                        onSubmit: () async {
                                          //退会処理
                                          deleteUser();
                                          print('ユーザーを削除しました!');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()));
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


