import 'dart:io';

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
  //取得データ
  String? name;
  String? email;
  String? image;
  String? uid;

  //更新用データ
  String newname = "";


//アカウント情報書き換え
  @override
  void Update() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // here, don't declare new variables, set the members instead
        setState(() {
        user.updateDisplayName(newname);
        user.updatePhotoURL(_image!.path);
        });
        print(_image!.path);
      }
    });
  }

//アカウント情報取得
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // here, don't declare new variables, set the members instead
        setState(() {
          name = user.displayName; // <-- User ID
          email = user.email; // <-- Their email
          image = user.photoURL;
          uid = user.uid;
        });
      }
    });
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
        child: Column(
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
            Container(
                width: double.infinity,
                child: Text(
                  'ユーザー名',
                  style: GoogleFonts.notoSans(
                    // フォントをnotoSansに指定(
                    textStyle: TextStyle(
                      fontSize: 30,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )),
            TextField(
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp('ゲストユーザー'))
              ],
              decoration: InputDecoration(
                hintText: name??"ゲストユーザー",
                suffixIcon: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("注意"),
                          content: Text("アカウント情報を$nameから$newnameに変更しますか？"),
                          actions: <Widget>[
                            // ボタン領域
                            ElevatedButton(
                              child: Text("やっぱやめる"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                              child: Text("いいよ"),
                              onPressed: (){
                                Update();
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (context) {
                                          return MyHomePage(
                                              title: 'home');
                                        }));
                              },
                            ),

                          ],
                        );
                      },
                    );                  },
                  icon: Icon(Icons.arrow_circle_right),
                ),
              ),
              onChanged: (String value) {
                setState(() {
                  newname = value;
                });
              },
            ),
            Container(
                width: double.infinity,
                child: Text(
                  '登録アカウント',
                  style: GoogleFonts.notoSans(
                    // フォントをnotoSansに指定(
                    textStyle: TextStyle(
                      fontSize: 30,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )),
            SizedBox(height: 20,),
            Container(width: double.infinity,
                child: Text(email ?? '',style: TextStyle(fontSize: 20),)),



          ],
        ),
      ),
    );
  }
}
