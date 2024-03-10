import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 200,
              height: 200,
              child: Image(
                image: AssetImage('assets/icon/maintenance.gif'),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'メンテナンス中です！\nメンテナンス終了までお待ち下さい。',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                launchUrlString('https://twitter.com/TAN_Q_BOT_LOCAL');
              },
              child: const Text('詳しくは開発者のTwitterをご確認ください。'),
            ),
          ],
        ),
      ),
    );
  }
}
