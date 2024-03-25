// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountNameUpdater {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateDisplayName(String newName, BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    try {
      await firestore
          .collection('users')
          .doc(uid)
          .update({'displayName': newName});
      Fluttertoast.showToast(msg: 'アカウント名が更新されました。');
    } catch (e) {
      Fluttertoast.showToast(msg: 'アカウント名の更新に失敗しました: $e');
    }
  }
}
