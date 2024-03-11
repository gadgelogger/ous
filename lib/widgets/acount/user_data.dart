import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ous/widgets/acount/user_header.dart';

class UserData extends StatelessWidget {
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  UserData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const Text('データが見つかりませんでした。');
        }
        final data = snapshot.data!.data()! as Map<String, dynamic>;
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
