import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class debug extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: firestore.collection('users').doc('og3SuDgvfKZ4yhcl87huvperGYv2').get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('エラーが発生しました');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // Firestoreから取得したデータを取り出す
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          String value = data['email'] ?? '値が見つかりませんでした';

          // テキストを表示する
          return Text(value);
        }

        // データを取得中の場合は、ローディング表示をする
        return CircularProgressIndicator();
      },
    );
  }
}
