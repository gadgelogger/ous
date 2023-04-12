import 'dart:io';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ous/review/post.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:share_extend/share_extend.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {

    // 背景の明るさをチェック
    bool isBackgroundBright = Theme.of(context).primaryColor == Brightness.light;

    // 明るい背景の場合は黒、暗い背景の場合は白
    Color textColor = isBackgroundBright ? Colors.black : Colors.white;


    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('users');
    final favoriteRef = userRef.doc(userId).collection('favorite');

    return Scaffold(
      appBar: AppBar(
        title: Text('お気に入り'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: favoriteRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('エラーが発生しました'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final favoriteDocs = snapshot.data!.docs;
          final originalDocFutures = favoriteDocs.map((favoriteDoc) {
            final originalDocRef = favoriteDoc['originalDocRef'] as DocumentReference;
            return originalDocRef.get();
          }).toList();

          return FutureBuilder<List<DocumentSnapshot>>(
            future: Future.wait(originalDocFutures),
            builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> originalDocSnapshot) {
              if (originalDocSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (originalDocSnapshot.hasError) {
                return Center(
                  child: Text('エラーが発生しました'),
                );
              }

              final originalDocs = originalDocSnapshot.data!;

              if (originalDocs.isEmpty) {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 200,
                            height: 200,
                            child: Image(
                              image: AssetImage('assets/icon/found.gif'),
                              fit: BoxFit.cover,
                            )),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          '何もお気に入りに登録していません',
                          style: TextStyle(fontSize: 18.sp),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ));
              } else {
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: originalDocs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final originalDoc = originalDocs[index];
                      return Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                    zyugyoumei: originalDoc['zyugyoumei'],
                                    kousimei: originalDoc['kousimei'],
                                    tannisuu: originalDoc['tannisuu'],
                                    zyugyoukeisiki: originalDoc['zyugyoukeisiki'],
                                    syusseki: originalDoc['syusseki'],
                                    kyoukasyo: originalDoc['kyoukasyo'],
                                    tesutokeisiki: originalDoc['tesutokeisiki'],
                                    omosirosa: originalDoc['omosirosa'],
                                    toriyasusa: originalDoc['toriyasusa'],
                                    sougouhyouka: originalDoc['sougouhyouka'],
                                    komento: originalDoc['komento'],
                                    name: originalDoc['name'],
                                    senden: originalDoc['senden'],
                                    nenndo: originalDoc['nenndo'],
                                    date: originalDoc['date'].toDate(),

                                    tesutokeikou: originalDoc['tesutokeikou'],
                                    id:originalDoc['ID'],
                                  ),
                                ),
                              );
                            },
                            child: (SizedBox(
                              width: 200.w,
                              height: 30.h,
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Align(
                                            alignment: const Alignment(
                                              -0.8,
                                              -0.5,
                                            ),
                                            child: Text(
                                              originalDoc['zyugyoumei'],
                                              style: TextStyle(fontSize: 20.sp),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ))),
                                    Align(
                                      alignment: const Alignment(-0.8, 0.4),
                                      child: Text(
                                        originalDoc['gakki'],
                                        style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary, fontSize: 15.sp),
                                      ),
                                    ),
                                    Align(
                                      alignment: const Alignment(-0.8, 0.8),
                                      child: Text(
                                        originalDoc['kousimei'],
                                        overflow: TextOverflow.ellipsis, //ここ！！
                                        style: TextStyle(fontSize: 15.sp),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 6),
                                          decoration: BoxDecoration(
                                              color: originalDoc['bumon'] == 'エグ単'
                                                  ? Colors.red
                                                  : Theme.of(context).colorScheme.primary,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ) // green shaped
                                          ),
                                          child: Text(
                                            originalDoc['bumon'],
                                            style: TextStyle(
                                                fontSize: 15.sp,color: textColor),
                                            // Your text
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ));
                    });
              }
            },
          );
        },
      ),
    );
  }
}


class DetailsScreen extends StatefulWidget {
  final zyugyoumei;
  final kousimei;
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







  final GlobalKey shareKey = GlobalKey(); //追加






  Future<ByteData> exportToImage(GlobalKey globalKey) async {
    final boundary =
    globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(
      pixelRatio: 3,
    );
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData!;
  }

  Future<File> getApplicationDocumentsFile(
      String text, List<int> imageData) async {
    final directory = await getApplicationDocumentsDirectory();

    final exportFile = File('${directory.path}/$text.png');
    if (!await exportFile.exists()) {
      await exportFile.create(recursive: true);
    }
    final file = await exportFile.writeAsBytes(imageData);
    return file;
  }

  void shareImageAndText(String text, GlobalKey globalKey) async {
    //shareする際のテキスト
    try {
      final bytes = await exportToImage(globalKey);
      //byte data→Uint8List
      final widgetImageBytes =
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      //App directoryファイルに保存
      final applicationDocumentsFile =
      await getApplicationDocumentsFile(text, widgetImageBytes);

      final path = applicationDocumentsFile.path;
      await ShareExtend.share(path, "image");
      applicationDocumentsFile.delete();
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.zyugyoumei),
        ),
        body: Container(
          margin: EdgeInsets.all(15),
          child: SingleChildScrollView(
              child: RepaintBoundary(
                  key: shareKey,
                  child: Container(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).backgroundColor.withOpacity(0.6)
                        : Theme.of(context).backgroundColor.withOpacity(0.6),


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
                          padding: EdgeInsets.only(
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
                          padding: EdgeInsets.only(
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
                          padding: EdgeInsets.only(top: 10, bottom: 10),
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
                          padding: EdgeInsets.only(top: 10, bottom: 10),
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
                          padding: EdgeInsets.only(
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
                          padding: EdgeInsets.only(
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
                          padding: EdgeInsets.only(
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
                          padding: EdgeInsets.only(
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
                        Divider(),
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
                              Container(
                                  height: 200.h,
                                  child: SfRadialGauge(axes: <RadialAxis>[
                                    RadialAxis(
                                        minimum: 0,
                                        maximum: 5,
                                        showLabels: false,
                                        showTicks: false,
                                        axisLineStyle: AxisLineStyle(
                                          thickness: 0.2,
                                          cornerStyle: CornerStyle.bothCurve,
                                          color:
                                          Color.fromARGB(139, 134, 134, 134),
                                          thicknessUnit: GaugeSizeUnit.factor,
                                        ),
                                        pointers: <GaugePointer>[
                                          RangePointer(
                                            value: widget.omosirosa.toDouble(),
                                            cornerStyle: CornerStyle.bothCurve,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 0.2,
                                            sizeUnit: GaugeSizeUnit.factor,
                                          )
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
                                                    fontWeight: FontWeight.bold),
                                              ))
                                        ])
                                  ])),
                              Text(
                                '単位の取りやすさ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                ),
                              ),
                              Container(
                                height: 200.h,
                                child: SfRadialGauge(axes: <RadialAxis>[
                                  RadialAxis(
                                      minimum: 0,
                                      maximum: 5,
                                      showLabels: false,
                                      showTicks: false,
                                      axisLineStyle: AxisLineStyle(
                                        thickness: 0.2,
                                        cornerStyle: CornerStyle.bothCurve,
                                        color: Color.fromARGB(139, 134, 134, 134),
                                        thicknessUnit: GaugeSizeUnit.factor,
                                      ),
                                      pointers: <GaugePointer>[
                                        RangePointer(
                                          value: widget.toriyasusa.toDouble(),
                                          cornerStyle: CornerStyle.bothCurve,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 0.2,
                                          sizeUnit: GaugeSizeUnit.factor,
                                        )
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
                                                  fontWeight: FontWeight.bold),
                                            ))
                                      ])
                                ]),
                              ),
                              Text(
                                '総合評価',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                ),
                              ),
                              Container(
                                height: 200.h,
                                child: SfRadialGauge(axes: <RadialAxis>[
                                  RadialAxis(
                                      minimum: 0,
                                      maximum: 5,
                                      showLabels: false,
                                      showTicks: false,
                                      axisLineStyle: AxisLineStyle(
                                        thickness: 0.2,
                                        cornerStyle: CornerStyle.bothCurve,
                                        color: Color.fromARGB(139, 134, 134, 134),
                                        thicknessUnit: GaugeSizeUnit.factor,
                                      ),
                                      pointers: <GaugePointer>[
                                        RangePointer(
                                          value: widget.sougouhyouka.toDouble(),
                                          cornerStyle: CornerStyle.bothCurve,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 0.2,
                                          sizeUnit: GaugeSizeUnit.factor,
                                        )
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
                                                  fontWeight: FontWeight.bold),
                                            ))
                                      ])
                                ]),
                              ),
                              Divider(),
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
                                padding: EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Text(widget.tesutokeikou)),
                            Text(
                              'ニックネーム',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
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
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                DateFormat('yyyy年MM月dd日 HH:mm')
                                    .format(widget.date),
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
                              padding: EdgeInsets.only(
                                bottom: 10,
                                top: 10,
                              ),
                              child: SelectableText(
                                widget.senden?.toString() ?? '不明',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                            SizedBox(height: 20.0.h),
                            Container(
                              height: 40.0.h,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                        Theme.of(context).colorScheme.primary,
                                        style: BorderStyle.solid,
                                        width: 1.0.w),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: GestureDetector(
                                  onTap: () async {
                                    //ここにブロック関数
                                    launch(
                                        'https://docs.google.com/forms/d/e/1FAIpQLSepC82BWAoARJVh4WeGCFOuIpWLyaPfqqXn524SqxyBSA9LwQ/viewform');
                                  },
                                  child: Center(
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
                        )
                      ],
                    ),
                  ))),
        ),
 );
  }
}
