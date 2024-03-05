import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class ImageUploader {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  bool isUploading = false;

  Future<void> pickAndUploadImage(BuildContext context) async {
    try {
      // 画像をギャラリーから選択
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final File imageFile = File(pickedFile.path);
      Fluttertoast.showToast(msg: "アップロードを開始します...");

      String fileName = path.basename(imageFile.path);
      Reference storageRef =
          FirebaseStorage.instance.ref('userImages/$uid/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // アップロード完了を待つ
      await uploadTask.whenComplete(() => null);
      String downloadURL = await storageRef.getDownloadURL();

      // Firestoreに画像URLを保存
      await firestore
          .collection("users")
          .doc(uid)
          .update({"photoURL": downloadURL});
      Fluttertoast.showToast(msg: "アップロードが完了しました");
    } catch (e) {
      Fluttertoast.showToast(msg: "アップロードに失敗しました: $e");
    }
  }
}

class UserHeader extends StatelessWidget {
  final String name;
  final String status;
  final String image;
  final String email;
  final String uid;

  const UserHeader({
    Key? key,
    required this.name,
    required this.status,
    required this.image,
    required this.email,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ユーザー情報のヘッダーUIに集中
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              ImageUploader().pickAndUploadImage(context);
            },
            child: ImageUploader().isUploading
                ? const CircularProgressIndicator()
                : SizedBox(
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
                                onPressed: () {},
                                elevation: 2.0,
                                fillColor: const Color(0xFFF5F6F9),
                                padding: const EdgeInsets.all(7.0),
                                shape: const CircleBorder(),
                                child: Icon(
                                  Icons.photo_camera_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        const Divider(),
        const SizedBox(height: 16),
        const Text(
          'アカウント名',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: name,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '役職',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: status,
            border: const OutlineInputBorder(),
            enabled: false,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'メールアドレス',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: email,
            border: const OutlineInputBorder(),
            enabled: false,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'ID',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: uid,
            border: const OutlineInputBorder(),
          ),
          enabled: false,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class UserInfo extends StatelessWidget {
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Firestoreからユーザー情報の取得と表示に集中
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const Text('データが見つかりませんでした。');
        }
        final data = snapshot.data!.data() as Map<String, dynamic>;
        // ユーザーヘッダーにデータを渡す
        return UserHeader(
          name: data['displayName'] ?? '名前なし',
          status: data['email'].contains('@ous.jp') ? '生徒' : '教職員',
          image: data['photoURL'] ?? 'デフォルトの画像URL',
          email: data['email'] ?? 'メールアドレスなし',
          uid: uid,
        );
      },
    );
  }
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    // UIの構築に集中
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('アカウント'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: UserInfo(),
        ),
      ),
    );
  }
}
