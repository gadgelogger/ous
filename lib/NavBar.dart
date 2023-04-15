import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_plugin_ios_android/flutter_webview_plugin_ios_android.dart';
import 'package:ous/Nav/Calendar/calender.dart';
import 'package:ous/Nav/map.dart';
import 'package:ous/account/account.dart';
import 'package:ous/Nav/link.dart';
import 'package:ous/account/login.dart';
import 'package:ous/main.dart';
import 'package:ous/setting/setting.dart';
import 'package:ous/Nav/call.dart';
import 'package:ous/Nav/userpolicie.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';



class NavBar extends StatefulWidget {
  const NavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
//firestoreキャッシュ
  Stream<DocumentSnapshot>? _stream;
  late DocumentSnapshot _data;

  @override
  void initState() {
    super.initState();

    _stream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();


  }

//UIDをFirebaseAythから取得
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final uid = FirebaseAuth.instance.currentUser?.uid;






  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return account();
                }),
              );
            },
            child: StreamBuilder<DocumentSnapshot>(
              stream: _stream,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Text('エラーが発生しました。');
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return Text('データが見つかりませんでした。');
                }

                _data = snapshot.data!;

                final displayName = _data['displayName'] as String?;
                final email = _data['email'] as String?;
                final image = _data['photoURL'] as String?;

                return UserAccountsDrawerHeader(
                  accountName: Text(displayName ?? 'ゲストユーザー'),
                  accountEmail:
                      Text(email ?? '', style: TextStyle(color: Colors.white)),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        image ??
                            'https://pbs.twimg.com/profile_images/1439164154502287361/1dyVrzQO_400x400.jpg',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://pbs.twimg.com/profile_banners/1394312681209749510/1634787753/1500x500'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.event_available_outlined),
            title: Text('行事予定'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarPage()),
              );            },
          ),
          ListTile(
            leading: Icon(Icons.public_outlined),
            title: Text('マイログ'),
            onTap: () {
              launchUrl(
                  Uri.https('mylog.pub.ous.ac.jp',
                      '/uprx/up/pk/pky501/Pky50101.xhtml'),
                  mode: LaunchMode.externalApplication);
            },
          ),
          ListTile(
            leading: Icon(Icons.public_outlined),
            title: Text('TCP'),
            onTap: () {
                  launchUrl(
                      Uri.https('app.tcpapp.net',
                          '/tcpapp/login.html'),
                      mode: LaunchMode.externalApplication);
            },
          ),

          ListTile(
            leading: Icon(Icons.book_outlined),
            title: Text('学生便覧'),
            onTap: () {
              launch('https://www.ous.ac.jp/outline/disclosure/handbook/');
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('学内マップ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Map()),
              );
            },
          ),

          Divider(),
          ListTile(
            leading: Icon(Icons.link_outlined),
            title: Text('各種リンク集'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Link()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.call_outlined),
            title: Text('各種連絡先'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Call()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('設定/その他'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Setting()),
              );
            },
          ),
        ],
      ),
    );
  }
}
