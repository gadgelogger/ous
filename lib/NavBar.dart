import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ous/account/account.dart';
import 'package:ous/Nav/link.dart';
import 'package:ous/account/login.dart';
import 'package:ous/main.dart';
import 'package:ous/setting/setting.dart';
import 'package:ous/Nav/Calendar/calendar.dart';
import 'package:ous/Nav/call.dart';
import 'package:ous/Nav/userpolicie.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key,  }) : super(key: key);
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String? uid;
  @override
  void initState(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user != null) {
        // here, don't declare new variables, set the members instead
        setState(() {

          uid = user.uid;
        });
      }
    });
  }


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
                MaterialPageRoute(builder: (context) => account()),
              );
            },
            child:FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Text('データが見つかりませんでした。');
                }

                final displayName = snapshot.data!['displayName'] as String?;
                final email = snapshot.data!['email'] as String?;
                final image = snapshot.data!['photoURL'] as String?;

                return  UserAccountsDrawerHeader(
                  accountName:    Text(displayName ?? 'ゲストユーザー'),//I want it to appear here
                  accountEmail: Text(email ?? '' ,style: TextStyle(color: Colors.white),),//I want it to appear here
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        image ?? 'https://pbs.twimg.com/profile_images/1439164154502287361/1dyVrzQO_400x400.jpg',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    image: DecorationImage(
                      image: NetworkImage('https://pbs.twimg.com/profile_banners/1394312681209749510/1634787753/1500x500',
                      ),
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
              launch('https://www.ous.ac.jp/common/files//285/20220311164731084854.pdf');
            },
          ),
          ListTile(
            leading: Icon(Icons.public_outlined),
            title: Text('マイログ'),
            onTap: () {
              launchUrl(Uri.https('mylog.pub.ous.ac.jp', '/uprx/up/pk/pky501/Pky50101.xhtml'),mode:LaunchMode.externalApplication );

            },
          ),
          ListTile(
            leading: Icon(Icons.book_outlined),
            title: Text('学生便覧'),
            onTap: () {
              launch('https://edu.career-tasu.jp/p/digital_pamph/frame.aspx?id=7540000-3-30&FL=0');
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('学内マップ'),
            onTap: () {
              launch('http://www1.ous.ac.jp/gakusyu/2017rikadaimap2.pdf');
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






