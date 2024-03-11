// lib/api/service/tutorial_service.dart

import 'package:flutter/material.dart';
import 'package:ous/screens/tutorial_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialService {
  static Future<void> showTutorialIfNeeded(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    final isAlreadyFirstLaunch = pref.getBool('isAlreadyFirstLaunch') ?? false;

    if (!isAlreadyFirstLaunch) {
      // 初回起動時にチュートリアル画面を表示
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Tutorial(),
          fullscreenDialog: true,
        ),
      );
      await pref.setBool('isAlreadyFirstLaunch', true);
    }
  }
}
