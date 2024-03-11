import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

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

      final imageFile = File(pickedFile.path);
      Fluttertoast.showToast(msg: 'アップロードを開始します...');
      const CircularProgressIndicator();

      final fileName = path.basename(imageFile.path);
      final storageRef =
          FirebaseStorage.instance.ref('userImages/$uid/$fileName');
      final uploadTask = storageRef.putFile(imageFile);

      // アップロード完了を待つ
      await uploadTask.whenComplete(() => null);
      final downloadURL = await storageRef.getDownloadURL();

      // Firestoreに画像URLを保存
      await firestore
          .collection('users')
          .doc(uid)
          .update({'photoURL': downloadURL});
      Fluttertoast.showToast(msg: 'アップロードが完了しました');
    } catch (e) {
      Fluttertoast.showToast(msg: 'アップロードに失敗しました: $e');
    }
  }
}
