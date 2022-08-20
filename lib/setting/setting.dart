import 'package:flutter/material.dart';
import 'package:ous/NavBar.dart';
import 'package:ous/login.dart';
import 'package:ous/setting/music.dart';
import 'package:ous/Nav/userpolicie.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:ous/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../main.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  ThemeData current = ThemeData.light();
  bool _isDark = false;

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
    Navigator.of(context, rootNavigator: useRootNavigator).push(MaterialPageRoute<void>(
      builder: (BuildContext context) =>
          LicensePage(
        applicationName: "非公式岡理アプリ",
        applicationIcon:
       Container(
          width: 100,
          height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset('assets/images/icon.jpeg'),
            ),
        ),
        applicationLegalese: "@TAN_Q_BOT_LOCAL",
      ),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: NavBar(),
    appBar: AppBar(
      title: Text('アプリの設定'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return MyHomePage(title: 'home');
            }),          );
        },
      ),
    ),
    body: SettingsList(
      sections: [
        SettingsSection(
          title: Text('基本的な設定'),
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
        SettingsSection(
          title: Text('その他'),
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
                launch(
                    'https://tan-q-bot-unofficial.com/terms_of_service/');
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
              leading: Icon(Icons.rate_review),
              title: Text('このアプリを評価する'),
              onPressed: (BuildContext context) async {
                final InAppReview inAppReview = InAppReview.instance;
                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                }
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.terminal),
              title: Text('ライセンスについて'),
                onPressed: (context) {
                  showLicensePage(
                    context: context,
                    applicationName: "非公式岡理アプリ",
                    applicationIcon:Image.asset("assets/icon/icon.png"),
                    applicationLegalese: "@TAN_Q_BOT_LOCAL",
                  );
                }
            ),
          ],
        ),
        SettingsSection(
          title: Text('ログアウト'),
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
                        FlatButton(
                          child: Text("ダメやで"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FlatButton(
                          child: Text("ええで"),
                          onPressed: () async {
                            // ログアウト処理
                            // 内部で保持しているログイン情報等が初期化される
                            // （現時点ではログアウト時はこの処理を呼び出せばOKと、思うぐらいで大丈夫です）
                            await FirebaseAuth.instance.signOut();
                            // ログイン画面に遷移＋チャット画面を破棄
                            await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                                return AuthPage();
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
          ],
        ),
      ],
    ),
  );
}
