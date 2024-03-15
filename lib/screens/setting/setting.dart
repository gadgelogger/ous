// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:ous/api/service/setting_service.dart';
import 'package:ous/constant/urls.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('アプリの設定'),
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final packageInfo = snapshot.data;
          return SettingsList(
            sections: [
              SettingsSection(
                title: Text(
                  '基本的な設定',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.description),
                    title: const Text('利用規約について'),
                    onPressed: (context) {
                      launchUrlString(
                        SettingUrls.license,
                      );
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.reply),
                    title: const Text('記事の掲載元'),
                    onPressed: (context) {
                      launchUrlString(
                        SettingUrls.source,
                      );
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.email),
                    title: const Text('お問合わせ'),
                    onPressed: (context) {
                      launchUrlString(
                        SettingUrls.contact,
                      );
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.terminal),
                    title: const Text('ライセンスについて'),
                    onPressed: (context) {
                      showLicensePage(
                        context: context,
                        applicationName: packageInfo?.appName ?? 'error',
                        applicationVersion: packageInfo?.version ?? 'error',
                      );
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.description),
                    title: const Text('開発ロードマップ'),
                    onPressed: (context) {
                      launchUrlString(
                        SettingUrls.loadMap,
                      );
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
                          StoreUrls.ios,
                        );
                      },
                    ),
                  if (Platform.isAndroid)
                    SettingsTile.navigation(
                      leading: const Icon(Icons.share),
                      title: const Text('このアプリをシェアする'),
                      onPressed: (BuildContext context) async {
                        Share.share(
                          StoreUrls.android,
                        );
                      },
                    ),
                  if (Platform.isIOS)
                    SettingsTile.navigation(
                      leading: const Icon(Icons.public_outlined),
                      title: const Text('アプリの公式サイト'),
                      onPressed: (context) {
                        launchUrlString(
                          SettingUrls.appWebSite,
                        );
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
                    title: const Text('バージョン'),
                    leading: const Icon(Icons.info_outline),
                    value: Text(packageInfo?.version ?? 'error'),
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
                      SettingService.logoutDialog(context);
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text(
                      'アカウントを削除する。',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: (BuildContext context) async {
                      SettingService.deleteAccountDialog(context);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
