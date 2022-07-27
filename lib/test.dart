import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ous/NavBar.dart';
import 'package:ous/test/gakubu.dart';
import 'package:ous/test/kiban.dart';
import 'package:ous/test/kyousyoku.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late File _image;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('過去問まとめ'),
      ),
      body: Container(
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                title: Text('基盤教育科目'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => kiban(),
                )),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                title: Text('学部別'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Gakubu(),
                )),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                title: Text('教職科目'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => kyousyoku(),
                )),
              ),
            ),
            Card(
              child: ListTile(
                tileColor: Colors.lightGreen,
                leading: Icon(Icons.warning_amber_outlined),
                title: Text('削除フォーム(教授向け）',style: TextStyle(fontSize: 15) ,),
                onTap: (){
                  launch('https://docs.google.com/forms/d/e/1FAIpQLSdhv3t-MJ7nh1J7p47ovwJKAdTRrKpTHkoHK2Ar13DMEh7UTg/viewform?usp=sf_link');
                }
              ),
            ),          ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => launch('https://forms.gle/7Jtu8svujxtRa4yg7'),
        child: const Icon(Icons.upload_rounded),
      ),
    );
  }
}
