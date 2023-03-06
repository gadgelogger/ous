import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ous/home.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class account_edit extends StatefulWidget {
  const account_edit({Key? key}) : super(key: key);

  @override
  State<account_edit> createState() => _account_editState();
}

class _account_editState extends State<account_edit> {
//画像
  XFile? _image;
  final imagePicker = ImagePicker();
//UIDをFirebaseAythから取得
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  TextEditingController _controller = TextEditingController();
  String _text = '';


// テキストの編集が完了したときに呼び出されるコールバック
  void _onTextEditingComplete() {
    String text = _controller.text;
    writeToFirestore(text);

  }

  void textview() {
    String text = _controller.text;
    setState(() {
      _text = text;
    });
  }

  // Firestore にデータを書き込むなどの処理を行う関数
  void writeToFirestore(String text) {
    final firestore = FirebaseFirestore.instance;

    firestore
        .collection("users")
        .doc(uid)
        .update({"displayName": text})
        .then((value) => print("Document updated successfully."))
        .catchError((error) => print("Failed to update document: $error"));
    // Firestore にデータを書き込むなどの処理を行う
  }



  // ギャラリーから画像を取得するメソッド
  Future getImageFromGarally() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('プロフィール変更'),
      ),
      body: SafeArea(
        child:FutureBuilder<DocumentSnapshot>(
            future: firestore.collection('users').doc(uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // データ読み込み中の場合の処理
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data == null) {
                // データが取得できなかった場合の処理
                return Text('データが見つかりませんでした。');
              }
              // データが正常に取得できた場合の処理
              final data = snapshot.data!.data() as Map<String, dynamic>;
              final email = data['email'] as String;
              final name = data['displayName'] as String;
              final isStudent = email.contains('@ous.jp');
              final isStaff = email.contains('@ous.ac.jp');
              final image = data['photoURL'] as String;
              String text = _controller.text;

              return  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Center(
                        child: GestureDetector(
                          onTap: (){
                            getImageFromGarally();
                          },
                          child: Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(image ??
                                      'https://pbs.twimg.com/profile_images/1439164154502287361/1dyVrzQO_400x400.jpg'),
                                )),
                          ),
                        )
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: Text(
                        'ユーザー名',
                        style: GoogleFonts.notoSans(
                          // フォントをnotoSansに指定(
                          textStyle: TextStyle(
                            fontSize: 30,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),

                  TextField(
                    controller: _controller,

                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('ゲストユーザー'))
                    ],
                    decoration: InputDecoration(
                      hintText: name??"ゲストユーザー",
                      suffixIcon: IconButton(
                        onPressed: () {
                          textview();
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("注意"),
                                content: Text("アカウント情報を$nameから$_textに変更しますか？"),
                                actions: <Widget>[
                                  // ボタン領域
                                  ElevatedButton(
                                    child: Text("やっぱやめる"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  ElevatedButton(
                                    child: Text("いいよ"),
                                    onPressed: (){
                                      _onTextEditingComplete();

                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                              builder: (context) {
                                                return MyHomePage(
                                                    title: 'home');
                                              }));},
                                  ),
                                ],
                              );
                            },
                          );                  },
                        icon: Icon(Icons.arrow_circle_right),
                      ),
                    ),

                  ),
                  Center(
                      child: Text(
                        '登録アカウント',
                        style: GoogleFonts.notoSans(
                          // フォントをnotoSansに指定(
                          textStyle: TextStyle(
                            fontSize: 30,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                  SizedBox(height: 20,),
                  Center(
                      child: Text(email ?? '',style: TextStyle(fontSize: 20),)),





                ],
              );
            }),
      ),
    );
  }
}
