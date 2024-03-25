// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VersionCheckService {
  Future<void> checkVersion(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('config')
          .doc('3wmNMFXQArQHWpJA20je')
          .get();
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      String latestVersion = data?['version'];

      if (currentVersion != latestVersion) {
        if (!context.mounted) return;

        _showUpdateDialog(context);
      }
    } catch (e) {
      debugPrint('Version check failed: $e');
    }
  }

  void _showUpdateDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('アプリのアップデートがあるぞ！'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: '見てくれ',
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "アップデートのお知らせ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image(
                          image: AssetImage('assets/icon/rocket.gif'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        'アプリのアップデートがあります！\n新機能などが追加されたので\nアップデートをよろしくお願いします。',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    // ボタン領域
                    ElevatedButton(
                      child: const Text("後で"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    if (!kIsWeb && Platform.isIOS)
                      ElevatedButton(
                        child: const Text("おっけー"),
                        onPressed: () {
                          launchUrlString(
                            'https://apps.apple.com/jp/app/%E5%B2%A1%E7%90%86%E3%82%A2%E3%83%97%E3%83%AA/id1671546931',
                          );
                        },
                      ),
                    if (!kIsWeb && Platform.isAndroid)
                      ElevatedButton(
                        child: const Text("おっけー"),
                        onPressed: () {
                          launchUrlString(
                            'https://play.google.com/store/apps/details?id=com.ous.unoffical.app',
                          );
                        },
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
