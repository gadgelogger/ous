// Flutter imports:
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Call extends StatelessWidget {
  const Call({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isBackgroundBright =
        Theme.of(context).colorScheme.brightness == Brightness.light;
    Color textColor = isBackgroundBright ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('各種連絡先'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: ListTile(
              title: Text(
                "岡山キャンパス",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              '健康管理センター(外線)',
            ),
            subtitle: const Text('0862568434'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568434'),
          ),
          ListTile(
            title: const Text('A1号館学部運営事務部'),
            subtitle: const Text('0862568451'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568451'),
          ),
          ListTile(
            title: const Text('学部運営事務部C2号館分室'),
            subtitle: const Text('0862568003'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568003'),
          ),
          ListTile(
            title: const Text('正面インフォメーション'),
            subtitle: const Text('0862568439'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568439'),
          ),
          ListTile(
            title: const Text('入試広報部'),
            subtitle: const Text('0862568412'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568412	'),
          ),
          ListTile(
            title: const Text('受験生ホットライン	'),
            subtitle: const Text('08008881124'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:08008881124'),
          ),
          ListTile(
            title: const Text('入試広報部'),
            subtitle: const Text('0862568415'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568415'),
          ),
          ListTile(
            title: const Text('庶務部'),
            subtitle: const Text('0862568431'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568431'),
          ),
          ListTile(
            title: const Text('学生支援部・コミュニケーション支援課	'),
            subtitle: const Text('0862568464'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568464'),
          ),
          ListTile(
            title: const Text('学生支援部・学生課'),
            subtitle: const Text('0862568442'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568442'),
          ),
          ListTile(
            title: const Text('学生支援部・学生課 学生係'),
            subtitle: const Text('0862568442'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568442'),
          ),
          ListTile(
            title: const Text('教学支援部・教務課'),
            subtitle: const Text('0862568447'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568447'),
          ),
          ListTile(
            title: const Text('経理部'),
            subtitle: const Text('0862568449'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568449'),
          ),
          ListTile(
            title: const Text('研究・社会連携部'),
            subtitle: const Text('0862569731'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862569731'),
          ),
          ListTile(
            title: const Text('キャリア支援センター'),
            subtitle: const Text('0862568435'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568435'),
          ),
          ListTile(
            title: const Text('教学支援部・教務課'),
            subtitle: const Text('0862568447'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568447'),
          ),
          ListTile(
            title: const Text('加計学園広報室'),
            subtitle: const Text('0862568609'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568609'),
          ),
          ListTile(
            title: const Text('健康管理センター'),
            subtitle: const Text('0862568434'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568434'),
          ),
          ListTile(
            title: const Text('学習支援センター'),
            subtitle: const Text('0862568438'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862568438'),
          ),
          Container(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: ListTile(
              title: Text(
                "今治キャンパス",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('キャリア支援係'),
            subtitle: const Text('0898529017'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0898529017'),
          ),
          ListTile(
            title: const Text('教務係'),
            subtitle: const Text('0898529029'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0898529029'),
          ),
          ListTile(
            title: const Text('学生係'),
            subtitle: const Text('0898529019'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0898529019'),
          ),
          ListTile(
            title: const Text('庶務係'),
            subtitle: const Text('0898529021'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0898529021'),
          ),
          ListTile(
            title: const Text('経理係'),
            subtitle: const Text('0898529025'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0898529025'),
          ),
          ListTile(
            title: const Text('グローバル教育センター'),
            subtitle: const Text('0862569814'),
            trailing: const Icon(Icons.call),
            onTap: () => launchUrlString('tel:0862569814'),
          ),
        ],
      ),
    );
  }
}
