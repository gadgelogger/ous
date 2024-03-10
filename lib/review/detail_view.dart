// Dart imports:
// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  final zyugyoumei;
  final kousimei;
  final gakki;
  final bumon;
  final tannisuu;
  final zyugyoukeisiki;
  final syusseki;
  final kyoukasyo;
  final tesutokeisiki;
  final omosirosa;
  final toriyasusa;
  final sougouhyouka;
  final komento;
  final name;
  final senden;
  final nenndo;
  final date;
  final tesutokeikou;
  final id;

  const DetailsScreen({
    Key? key,
    required this.nenndo,
    required this.zyugyoumei,
    required this.kousimei,
    required this.gakki,
    required this.bumon,
    required this.tannisuu,
    required this.zyugyoukeisiki,
    required this.syusseki,
    required this.kyoukasyo,
    required this.tesutokeisiki,
    required this.omosirosa,
    required this.toriyasusa,
    required this.sougouhyouka,
    required this.komento,
    required this.name,
    required this.senden,
    required this.date,
    required this.tesutokeikou,
    required this.id,
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  //いいね機能のボタン
  bool _isFavorite = false;

  final GlobalKey shareKey = GlobalKey(); //追加

  Future<void> addToFavorites(String documentId, String userId) async {
    final userRef = FirebaseFirestore.instance.collection('users');
    final favoriteRef = userRef.doc(userId).collection('favorite');
    final originalDocRef =
        FirebaseFirestore.instance.collection('rigaku').doc(documentId);

    final favoriteDoc = await favoriteRef.doc(documentId).get();

    if (favoriteDoc.exists) {
      await favoriteRef.doc(documentId).delete();
      setState(() {
        _isFavorite = false;
      });
    } else {
      await favoriteRef.doc(documentId).set({
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'originalDocRef': originalDocRef,
      });
      setState(() {
        _isFavorite = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.zyugyoumei),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '講義名',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: SelectableText(
                  widget.zyugyoumei ?? '不明',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Text(
                '講師名',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: SelectableText(
                  widget.kousimei ?? '不明',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Text(
                '年度',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SelectableText(
                  widget.nenndo ?? '不明'.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Text(
                '単位数',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SelectableText(
                  widget.tannisuu.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Text(
                '授業形式',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: SelectableText(
                  widget.zyugyoukeisiki,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Text(
                '出席確認の有無',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: SelectableText(
                  widget.syusseki,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Text(
                '教科書の有無',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: SelectableText(
                  widget.kyoukasyo,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Text(
                'テスト形式',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: SelectableText(
                  widget.tesutokeisiki ?? '不明',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              const Divider(),
              Container(
                child: Column(
                  children: [
                    Text(
                      '講義の面白さ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(
                      height: 200.h,
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 5,
                            showLabels: false,
                            showTicks: false,
                            axisLineStyle: const AxisLineStyle(
                              thickness: 0.2,
                              cornerStyle: CornerStyle.bothCurve,
                              color: Color.fromARGB(
                                139,
                                134,
                                134,
                                134,
                              ),
                              thicknessUnit: GaugeSizeUnit.factor,
                            ),
                            pointers: <GaugePointer>[
                              RangePointer(
                                value: widget.omosirosa.toDouble(),
                                cornerStyle: CornerStyle.bothCurve,
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.2,
                                sizeUnit: GaugeSizeUnit.factor,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                positionFactor: 0.1,
                                angle: 90,
                                widget: Text(
                                  widget.omosirosa
                                          .toDouble()
                                          .toStringAsFixed(0) +
                                      ' / 5',
                                  style: TextStyle(
                                    fontSize: 50.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '単位の取りやすさ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(
                      height: 200.h,
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 5,
                            showLabels: false,
                            showTicks: false,
                            axisLineStyle: const AxisLineStyle(
                              thickness: 0.2,
                              cornerStyle: CornerStyle.bothCurve,
                              color: Color.fromARGB(139, 134, 134, 134),
                              thicknessUnit: GaugeSizeUnit.factor,
                            ),
                            pointers: <GaugePointer>[
                              RangePointer(
                                value: widget.toriyasusa.toDouble(),
                                cornerStyle: CornerStyle.bothCurve,
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.2,
                                sizeUnit: GaugeSizeUnit.factor,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                positionFactor: 0.1,
                                angle: 90,
                                widget: Text(
                                  widget.toriyasusa
                                          .toDouble()
                                          .toStringAsFixed(0) +
                                      ' / 5',
                                  style: TextStyle(
                                    fontSize: 50.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '総合評価',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(
                      height: 200.h,
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 5,
                            showLabels: false,
                            showTicks: false,
                            axisLineStyle: const AxisLineStyle(
                              thickness: 0.2,
                              cornerStyle: CornerStyle.bothCurve,
                              color: Color.fromARGB(139, 134, 134, 134),
                              thicknessUnit: GaugeSizeUnit.factor,
                            ),
                            pointers: <GaugePointer>[
                              RangePointer(
                                value: widget.sougouhyouka.toDouble(),
                                cornerStyle: CornerStyle.bothCurve,
                                color: Theme.of(context).colorScheme.primary,
                                width: 0.2,
                                sizeUnit: GaugeSizeUnit.factor,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                positionFactor: 0.1,
                                angle: 90,
                                widget: Text(
                                  widget.sougouhyouka
                                          .toDouble()
                                          .toStringAsFixed(0) +
                                      ' / 5',
                                  style: TextStyle(
                                    fontSize: 50.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '講義に関するコメント',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  SelectableText(
                    widget.komento ?? '不明',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    'テスト傾向',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Text(widget.tesutokeikou),
                  ),
                  Text(
                    'ニックネーム',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      top: 10,
                    ),
                    child: SelectableText(
                      widget.name ?? '不明',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  Text(
                    '投稿日・更新日',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Text(
                      DateFormat('yyyy年MM月dd日 HH:mm').format(widget.date),
                      style: TextStyle(fontSize: 15.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '宣伝',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      top: 10,
                    ),
                    child: SelectableText(
                      widget.senden?.toString() ?? '不明',
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ),
                  SizedBox(height: 20.0.h),
                  SizedBox(
                    height: 40.0.h,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          style: BorderStyle.solid,
                          width: 1.0.w,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          //ここにブロック関数
                          launch(
                            'https://docs.google.com/forms/d/e/1FAIpQLSepC82BWAoARJVh4WeGCFOuIpWLyaPfqqXn524SqxyBSA9LwQ/viewform',
                          );
                        },
                        child: const Center(
                          child: Text(
                            'この投稿を開発者に報告する',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0.h),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: FloatingActionButton(
                  onPressed: () async {
                    if (userId != null) {
                      addToFavorites(widget.id, userId);
                    }
                    HapticFeedback.heavyImpact(); // ライトインパクトの振動フィードバック
                  },
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.pink : null,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: FloatingActionButton(
                  onPressed: () async {},
                  child: const Icon(Icons.ios_share),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  // いいね状態のチェック
  Future<void> _checkFavoriteStatus() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final userRef = FirebaseFirestore.instance.collection('users');
    final favoriteRef = userRef.doc(userId).collection('favorite');

    final favoriteDoc = await favoriteRef.doc(widget.id).get();

    if (favoriteDoc.exists) {
      setState(() {
        _isFavorite = true;
      });
    }
  }
}
