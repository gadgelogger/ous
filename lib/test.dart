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
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';


class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late File _image;

  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';


  Text? _text;


  _myDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text("アップロード完了"),
        content: const Text("アップロードありがとうございます！\nファイルは一週間以内に反映されます。"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("close"),
          )
        ],
      ),
    );
  }


  void uploadPic() async {
    try {
      /// 画像を選択
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      File file = File(image!.path);


      /// Firebase Cloud Storageにアップロード
      String generateNonce([int length = 32]) {
        const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
        final random = Random.secure();
        final randomStr = List.generate(
            length, (_) => charset[random.nextInt(charset.length)]).join();
        return randomStr;
      }
        String uploadName = generateNonce();
        final storageRef =
        FirebaseStorage.instance.ref().child('UP/$userID/$uploadName');
        final task = await storageRef.putFile(file);
      if(mounted) { // ←これを追加！！
        setState(() => _text =  _myDialog()
        );
      }
      }
    catch (e) {
      print(e);
    }
  }

  void uploadcamera() async {
    try {
      /// 画像を選択
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      File file = File(image!.path);


      /// Firebase Cloud Storageにアップロード
      String generateNonce([int length = 32]) {
        const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
        final random = Random.secure();
        final randomStr = List.generate(
            length, (_) => charset[random.nextInt(charset.length)]).join();
        return randomStr;
      }
      String uploadName = generateNonce();
      final storageRef =
      FirebaseStorage.instance.ref().child('UP/$userID/$uploadName');
      final task = await storageRef.putFile(file);
      if(mounted) { // ←これを追加！！
        setState(() => _text =  _myDialog()
        );
      }
    }
    catch (e)  {
      print(e);
    }
  }

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
                          Text('過去問をアップロード',style: TextStyle(fontSize:30,color:Colors.black,fontWeight: FontWeight.bold),),
                          LimitedBox(
                            maxHeight: 200,
                            child: ListView(
                              children: [
                                Card(
                                  child: ListTile(
                                    leading: Icon(Icons.photo_library),
                                    trailing: Icon(Icons.chevron_right),
                                    title: Text('アルバムから選択'),
                                    onTap: uploadPic,
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading: Icon(Icons.camera),
                                    trailing: Icon(Icons.chevron_right),
                                    title: Text('写真を撮る'),
                                    onTap: uploadcamera,

                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    leading: Icon(Icons.file_copy_outlined),
                                    trailing: Icon(Icons.chevron_right),
                                    title: Text('ファイル（PDF,wordなど）'),
                                    onTap: () =>
                                        launch('https://forms.gle/3JZkTzo1t3TuHpTs5'),
                                  ),
                                ),
                              ],

                            ),
                          ),
                          Text('投稿ありがとうございます！',style: TextStyle(fontSize:20,color:Colors.black,fontWeight: FontWeight.normal),),
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


