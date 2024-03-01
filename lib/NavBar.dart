// Flutter imports:
// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Project imports:
import 'package:ous/Nav/Calendar/calender.dart';
import 'package:ous/Nav/call.dart';
import 'package:ous/Nav/link.dart';
import 'package:ous/Nav/map.dart';
import 'package:ous/Nav/tcp.dart';
import 'package:ous/account/account.dart';
import 'package:ous/setting/setting.dart';
import 'package:url_launcher/url_launcher.dart';

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

  //UIDをFirebaseAythから取得
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const Account();
                  },
                ),
              );
            },
            child: StreamBuilder<DocumentSnapshot>(
              stream: _stream,
              builder: (
                BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Text('エラーが発生しました。');
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('データが見つかりませんでした。');
                }

                _data = snapshot.data!;

                final displayName = _data['displayName'] as String? ?? '';
                final email = _data['email'] as String?;
                final image = _data['photoURL'] as String?;

                return UserAccountsDrawerHeader(
                  accountName: Text(displayName),
                  accountEmail: Text(
                    email ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
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
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.event_available_outlined),
            title: const Text('行事予定'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.public_outlined),
            title: const Text('マイログ'),
            onTap: () {
              launchUrl(
                Uri.https(
                  'mylog.pub.ous.ac.jp',
                  '/uprx/up/pk/pky501/Pky50101.xhtml',
                ),
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.public_outlined),
            title: const Text('TCP'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Tcp()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_outlined),
            title: const Text('学生便覧'),
            onTap: () {
              launch('https://www.ous.ac.jp/outline/disclosure/handbook/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('学内マップ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Map()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.link_outlined),
            title: const Text('各種リンク集'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Link()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.call_outlined),
            title: const Text('各種連絡先'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Call()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('設定/その他'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Setting()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _stream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }
}
