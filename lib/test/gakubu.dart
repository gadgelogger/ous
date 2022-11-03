import 'package:flutter/material.dart';
import 'package:ous/test/keiei.dart';
import 'package:ous/test/kiban.dart';
import 'package:ous/test/kougakubu.dart';
import 'package:ous/test/kyouiku.dart';
import 'package:ous/test/kyousyoku.dart';
import 'package:ous/test/rigaku.dart';
import 'package:ous/test/seibutu.dart';
import 'package:ous/test/seimei.dart';
import 'package:ous/test/zyouhourikou.dart';
import 'package:ous/test/zyuui.dart';
import 'package:url_launcher/url_launcher.dart';

class Gakubu extends StatefulWidget {
  const Gakubu({Key? key}) : super(key: key);

  @override
  State<Gakubu> createState() => _GakubuState();
}

class _GakubuState extends State<Gakubu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('学部'),
      ),
      body: Container(
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                title: Text('工学部'),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => kougaku(),
                    )
                    ),
              ),
            ),
            Card(
              child: ListTile(
                  leading: Icon(Icons.folder),
                  trailing: Icon(Icons.chevron_right),
                  title: Text('情報理工学部'),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => zyouhourikou(),
                    )
                    ),              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                title: Text('教育学部'),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => kyouiku(),
                    )
                    ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                title: Text('獣医学部'),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => zyuui(),
                    )
                    ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                title: Text('理学部'),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => rigaku(),
                    )
                    ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                title: Text('生命科学部'),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => seimei(),
                    )
                    ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                title: Text('生物地球学部'),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => seibutu(),
                    )
                    ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                title: Text('経営学部'),
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => keiei(),
                    )
                    ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //ポップアップメニュー実装
          showModalBottomSheet(
            //モーダルの背景の色、透過
              backgroundColor: Colors.transparent,
              //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  margin: EdgeInsets.only(top: 150),
                  decoration: BoxDecoration(
                    //モーダル自体の色
                    color: Colors.white,
                    //角丸にする
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '過去問をアップロード',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0), //マージン
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.photo_library),
                            label: Text(
                              'アルバムから選択',
                              textAlign: TextAlign.left,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0), //マージン
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.camera),
                            label: Text(
                              '写真を撮る',
                              textAlign: TextAlign.left,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0), //マージン
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                              icon: Icon(Icons.folder),
                              label: Text(
                                '複数以上のファイル',
                                textAlign: TextAlign.left,
                              ),
                              onPressed: () => launch(
                                  'https://docs.google.com/forms/d/e/1FAIpQLSda45WF5uVd9mRFs_4nPCiM6bxFqpUKZSApYFWUVlAVtDlg_g/viewform?usp=sf_link')),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0), //マージン
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                              icon: Icon(Icons.link),
                              label: Text(
                                'ドライブなどのURL',
                                textAlign: TextAlign.left,
                              ),
                              onPressed: () => launch(
                                  'https://docs.google.com/forms/d/e/1FAIpQLSdEIS3eOynTihQ3AEk0zrp7mSpmcfqpEGxTOUIDp6Mzi19jqA/viewform?usp=sf_link')),
                        ),
                      ),
                      Text(
                        'アップロードあざます！',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        child: const Icon(Icons.upload_rounded),
      )
      ,
    );
  }
}
