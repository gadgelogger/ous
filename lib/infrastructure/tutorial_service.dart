// lib/api/service/tutorial_service.dart

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:ous/presentation/pages/tutorial_screen.dart';

class TutorialService {
  static Future<void> showTutorialIfNeeded(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    final isAlreadyFirstLaunch = pref.getBool('isAlreadyFirstLaunch') ?? false;

    if (!isAlreadyFirstLaunch) {
      // 初回起動時にチュートリアル画面を表示
      if (!context.mounted) return;

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
