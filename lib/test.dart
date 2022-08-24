import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ous/NavBar.dart';
import 'package:ous/test/debug.dart';
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
                  title: Text(
                    '削除フォーム(教授向け）',
                    style: TextStyle(fontSize: 15),
                  ),
                  onTap: () {
                    launch(
                        'https://docs.google.com/forms/d/e/1FAIpQLSdhv3t-MJ7nh1J7p47ovwJKAdTRrKpTHkoHK2Ar13DMEh7UTg/viewform?usp=sf_link');
                  }),
            ),
            Card(
              child: ListTile(
                tileColor: Colors.lightGreen,
                leading: Icon(Icons.warning_amber_outlined),
                title: Text(
                  'debug',
                  style: TextStyle(fontSize: 15),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => debug(),
                )),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              //モーダルの背景の色、透過
              backgroundColor: Colors.transparent,
              //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Container(
                    margin: EdgeInsets.only(top: 450),
                    decoration: BoxDecoration(
                      //モーダル自体の色
                      color: Colors.white,
                      //角丸にする
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: (
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('過去問をアップロード',style: TextStyle(fontSize:30,fontWeight: FontWeight.bold),),
                          LimitedBox(
                            maxHeight: 200,
                            child: ListView(
                              children: [
                                Card(
                                  child: ListTile(
                                    leading: Icon(Icons.photo_library),
                                    trailing: Icon(Icons.chevron_right),
                                    title: Text('アルバムから選択'),
                                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => kiban(),
                                    )),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading: Icon(Icons.camera),
                                    trailing: Icon(Icons.chevron_right),
                                    title: Text('写真を撮る'),
                                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Gakubu(),
                                    )),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading: Icon(Icons.file_copy_outlined),
                                    trailing: Icon(Icons.chevron_right),
                                    title: Text('ファイル（PDF,wordなど）'),
                                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => kyousyoku(),
                                    )),
                                  ),
                                ),
                              ],

                            ),
                          ),
                          Text('投稿ありがとうございます！',style: TextStyle(fontSize:20,fontWeight: FontWeight.normal),),
                        ],
                      )
                      ),
                    )
                );
              });
        },
        child: const Icon(Icons.upload_rounded),
      ),
    );
  }
}
