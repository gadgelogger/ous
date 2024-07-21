// Flutter imports:
// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final postProvider = ChangeNotifierProvider((ref) => PostModel());

class PostModel extends ChangeNotifier {
  String category = 'rigaku';
  String bumon = 'ラク単';
  String nenndo = '';
  String gakki = '春１';
  String tanni = '1';
  String zyugyoukeisiki = 'オンライン(VOD)';
  String syusseki = '毎日出席を取る';
  String kyoukasyo = 'あり';
  double hyouka = 3;
  double omosirosa = 3;
  double toriyasusa = 3;

  final zyugyoumeiController = TextEditingController();
  final kousimeiController = TextEditingController();
  final komentoController = TextEditingController();
  final tesutokeisikiController = TextEditingController();
  final tesutokeikouController = TextEditingController();
  final nameController = TextEditingController();
  final sendenController = TextEditingController();

  Map<String, String> _errorMessages = {};

  Map<String, String> get errorMessages => _errorMessages;

  void setErrorMessages(Map<String, String> errorMessages) {
    _errorMessages = errorMessages;
    notifyListeners();
  }

  void clearErrorMessages() {
    _errorMessages.clear();
    notifyListeners();
  }

  void setBumon(String value) {
    bumon = value;
    notifyListeners();
  }

  void setCategory(String value) {
    category = value;
    notifyListeners();
  }

  void setGakki(String value) {
    gakki = value;
    notifyListeners();
  }

  void setHyouka(double value) {
    hyouka = value;
    notifyListeners();
  }

  void setKyoukasyo(String value) {
    kyoukasyo = value;
    notifyListeners();
  }

  void setNendo(String value) {
    nenndo = value;
    notifyListeners();
  }

  void setOmosirosa(double value) {
    omosirosa = value;
    notifyListeners();
  }

  void setSyusseki(String value) {
    syusseki = value;
    notifyListeners();
  }

  void setTanni(String value) {
    tanni = value;
    notifyListeners();
  }

  void setToriyasusa(double value) {
    toriyasusa = value;
    notifyListeners();
  }

  void setZyugyoukeisiki(String value) {
    zyugyoukeisiki = value;
    notifyListeners();
  }

  Future<bool> submit() async {
    final errorMessages = validateForm();
    if (errorMessages.isNotEmpty) {
      setErrorMessages(_errorMessages); // エラーメッセージを設定
      return false;
    }

    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final postId = const Uuid().v4();

    await FirebaseFirestore.instance.collection(category).doc(postId).set({
      'ID': postId,
      'accountemail': user?.email,
      'accountname': user?.displayName,
      'accountuid': uid,
      'bumon': bumon,
      'gakki': gakki,
      'tannisuu': tanni,
      'zyugyoukeisiki': zyugyoukeisiki,
      'syusseki': syusseki,
      'kyoukasyo': kyoukasyo,
      'sougouhyouka': hyouka,
      'omosirosa': omosirosa,
      'toriyasusa': toriyasusa,
      'nenndo': nenndo,
      'zyugyoumei': zyugyoumeiController.text,
      'kousimei': kousimeiController.text,
      'komento': komentoController.text,
      'tesutokeisiki': tesutokeisikiController.text,
      'tesutokeikou': tesutokeikouController.text,
      'name': nameController.text,
      'senden': sendenController.text,
      'date': DateTime.now(),
    });
    zyugyoumeiController.clear();
    kousimeiController.clear();
    komentoController.clear();
    tesutokeisikiController.clear();
    tesutokeikouController.clear();
    nameController.clear();
    sendenController.clear();

    return true;
  }

  List<String> validateForm() {
    final List<String> errorMessages = [];
    _errorMessages.clear();

    if (zyugyoumeiController.text.isEmpty) {
      errorMessages.add('授業名が未入力です。');
      _errorMessages['zyugyoumei'] = '授業名が未入力です。';
    }
    if (kousimeiController.text.isEmpty) {
      errorMessages.add('講師名が未入力です。');
      _errorMessages['kousimei'] = '講師名が未入力です。';
    }
    if (tesutokeisikiController.text.isEmpty) {
      errorMessages.add('テスト形式が未入力です。');
      _errorMessages['tesutokeisiki'] = 'テスト形式が未入力です。';
    }
    if (tesutokeikouController.text.isEmpty) {
      errorMessages.add('テストの傾向が未入力です。');
      _errorMessages['tesutokeikou'] = 'テストの傾向が未入力です。';
    }
    if (nameController.text.isEmpty) {
      errorMessages.add('投稿者名が未入力です。');
      _errorMessages['name'] = '投稿者名が未入力です。';
    }
    if (nenndo.isEmpty) {
      errorMessages.add('年度が未選択です。');
      _errorMessages['nenndo'] = '年度が未選択です。';
    }
    if (komentoController.text.isEmpty) {
      errorMessages.add('レビューが未入力です。');
      _errorMessages['komento'] = 'レビューが未入力です。';
    }

    return errorMessages;
  }
}
