import 'package:flutter/material.dart';
import 'package:ous/main.dart';
import 'package:ous/home.dart';
import 'package:url_launcher/url_launcher.dart';
class Call extends StatelessWidget {
  const Call({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.home),
        onPressed: (){
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => home()),
          );
        },
      ),
      title: Text('各種連絡先'),
    ),
    body: ListView(
      children: <Widget>[
        ListTile(
            title: Text('健康管理センター(外線)',),
            subtitle: Text('0862568434'),
            trailing: Icon(Icons.call),
            onTap: () => launch('tel:0862568434'),
        ),
        ListTile(
          title: Text('A1号館学部運営事務部'),
          subtitle: Text('0862568451'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568451'),
        ),
        ListTile(
          title: Text('学部運営事務部C2号館分室'),
          subtitle: Text('0862568003'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568003'),
        ),
        ListTile(
          title: Text('正面インフォメーション'),
          subtitle: Text('0862568439'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568439'),
        ),
        ListTile(
          title: Text('入試広報部'),
          subtitle: Text('0862568412'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568412	'),
        ),
        ListTile(
          title: Text('受験生ホットライン	'),
          subtitle: Text('08008881124'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:08008881124'),
        ),
        ListTile(
          title: Text('入試広報部'),
          subtitle: Text('0862568415'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568415'),
        ),
        ListTile(
          title: Text('庶務部'),
          subtitle: Text('0862568431'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568431'),
        ),
        ListTile(
          title: Text('学生支援部・コミュニケーション支援課	'),
          subtitle: Text('0862568464'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568464'),
        ),
        ListTile(
          title: Text('学生支援部・学生課'),
          subtitle: Text('0862568442'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568442'),
        ),
        ListTile(
          title: Text('学生支援部・学生課 学生係'),
          subtitle: Text('0862568442'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568442'),
        ),
        ListTile(
          title: Text('教学支援部・教務課'),
          subtitle: Text('0862568447'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568447'),
        ),
        ListTile(
          title: Text('経理部'),
          subtitle: Text('0862568449'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568449'),
        ),
        ListTile(
          title: Text('研究・社会連携部'),
          subtitle: Text('0862569731'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862569731'),
        ),
        ListTile(
          title: Text('キャリア支援センター'),
          subtitle: Text('0862568435'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568435'),
        ),
        ListTile(
          title: Text('教学支援部・教務課'),
          subtitle: Text('0862568447'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568447'),
        ),
        ListTile(
          title: Text('加計学園広報室'),
          subtitle: Text('0862568609'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568609'),
        ),
        ListTile(
          title: Text('健康管理センター'),
          subtitle: Text('0862568434'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568434'),
        ),
        ListTile(
          title: Text('学習支援センター'),
          subtitle: Text('0862568438'),
          trailing: Icon(Icons.call),
          onTap: () => launch('tel:0862568438'),
        ),
        new Divider(
          height: 1.0,
          indent: 1.0,
        ),
      ],
    ),  );
}
