import 'package:flutter/material.dart';
import 'package:ous/Nav/account.dart';
import 'package:ous/Nav/link.dart';
import 'package:ous/account/login.dart';
import 'package:ous/main.dart';
import 'package:ous/setting/setting.dart';
import 'package:ous/Nav/tcp.dart';
import 'package:ous/Nav/Calendar/calendar.dart';
import 'package:ous/Nav/call.dart';
import 'package:ous/Nav/userpolicie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

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
            child:
          UserAccountsDrawerHeader(
            accountName: Text('開発者',style: TextStyle(color: Colors.white),),
            accountEmail: Text('test@gmail.com',style: TextStyle(color: Colors.white),),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://pbs.twimg.com/profile_images/1494938183448281089/xXIv3xmE_400x400.jpg',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              image: DecorationImage(
                image: NetworkImage(
                  'https://pbs.twimg.com/profile_banners/1394312681209749510/1634787753/1500x500',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('行事予定'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Calender()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.link),
            title: Text('各種リンク集'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Link()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.call),
            title: Text('各種連絡先'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Call()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.launch),
            title: Text('TCPはこちら'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => tcp()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
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