import 'package:flutter/material.dart';
import 'package:ous/Nav/account.dart';
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