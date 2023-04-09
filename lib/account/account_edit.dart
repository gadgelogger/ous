import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ous/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../main.dart';

class account_edit extends StatefulWidget {
  const account_edit({Key? key}) : super(key: key);

  @override
  State<account_edit> createState() => _account_editState();
}

class _account_editState extends State<account_edit> {
  //firestoreキャッシュ

  Stream<DocumentSnapshot>? _stream;
  late DocumentSnapshot _data;
  bool _isUploading = false; // 読み込みマークを表示するための変数

//画像
  File? _imageFile; // 選択した画像ファイル
  String? _downloadURL; // Firebase Storageからダウンロードした画像のURL

  Future<void> _listenToChanges() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        String downloadURL = snapshot.data()!["photoURL"];
        if (downloadURL != _downloadURL) {
          setState(() {
            _downloadURL = downloadURL;
          });
        }
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _isUploading = true; // 読み込みマークを表示
        _imageFile = File(pickedFile.path);
      });
      await _uploadImage(); // awaitを追加して、アップロード完了まで待つ
      setState(() {
        _isUploading = false; // 読み込みマークを非表示
      });
    }
  }

  Future<void> _uploadImage() async {
    try {
      // Firebase Storageにアップロード
      String fileName = basename(_imageFile!.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child("users/$fileName");
      await storageRef.putFile(_imageFile!);
      // FirestoreのusersドキュメントのphotoURLフィールドに書き込む
      String downloadURL = await storageRef.getDownloadURL();
      FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({"photoURL": downloadURL});
      Fluttertoast.showToast(msg: "アカウント画像を変更しました");
      Center(
        child: CircularProgressIndicator(),
      );
    } catch (e) {
      print(e.toString());
    }
  }

//UIDをFirebaseAythから取得
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  TextEditingController _controller = TextEditingController();
  String _text = '';

// テキストの編集が完了したときに呼び出されるコールバック
  void _onTextEditingComplete() {
    String text = _controller.text;
    writeToFirestore(text);
    _controller.clear();
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

  @override
  void initState() {
    super.initState();
    _listenToChanges();

    _stream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('プロフィール変更'),
      ),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
            stream: _stream,
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
              _data = snapshot.data!;
              final email = _data['email'] as String;
              final name = _data['displayName'] as String;
              final isStudent = email.contains('@ous.jp');
              final isStaff = email.contains('@ous.ac.jp');
              final image = _data['photoURL'] as String;
              String text = _controller.text;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Center(
                        child: GestureDetector(
                      onTap: () {
                        _pickImage(ImageSource.gallery);
                        Fluttertoast.showToast(
                            msg: "アカウント画像を変更しています\反映されるまでちょっと待ってね。");
                      },
                      child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                fit: StackFit.expand,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(image),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: -25,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        _pickImage(ImageSource.gallery);
                                        Fluttertoast.showToast(
                                            msg: "アカウント画像を変更しています\反映されるまでちょっと待ってね。");
                                      },
                                      elevation: 2.0,
                                      fillColor: Color(0xFFF5F6F9),
                                      child: Icon(
                                        Icons.photo_camera_outlined,
                                        color: Theme.of(context).colorScheme.primary
                                      ),
                                      padding: EdgeInsets.all(7.0),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                child: _isUploading
                                    ? Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator()
                                    ],
                                  ),
                                )
                                    : SizedBox()
                              ),
                            ],
                          )),
                    )),
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
                      hintText: name ?? "ゲストユーザー",
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
                                    onPressed: () {
                                      _onTextEditingComplete();

                                      Navigator.pop(context);
                                      ;
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
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
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Text(
                    email ?? '',
                    style: TextStyle(fontSize: 20),
                  )),
                ],
              );
            }),
      ),

    );
  }
}
