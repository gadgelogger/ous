import 'dart:async';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ous/review/post.dart';
import 'package:ous/review/view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:algolia/algolia.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../review.dart';

final algolia = Algolia.init(
  applicationId: '78CZVABC2W',
  apiKey: 'c2377e7faad9a408d5867b849f25fae4',
);

final index = algolia.instance.index('zyuui');

class zyuuigakubu extends StatefulWidget {
  const zyuuigakubu({Key? key}) : super(key: key);

  @override
  State<zyuuigakubu> createState() => _zyuuigakubuState();
}

class _zyuuigakubuState extends State<zyuuigakubu> {
  final _queryController = TextEditingController();
  String gakubu = 'zyuui';
  final _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> documentList = [];
  String test = 'FB219000 学びの基礎論';
  bool _searchBoolean = false; //追加
  bool _isPressed = false;
  int _actionCounter = 0;

  StreamController searchController = StreamController();

  Future<List<AlgoliaObjectSnapshot>> _searchAlgolia(String query) async {
    final result = await index.search(query).getObjects();
    return result.hits;
  }

  Widget _searchTextField() {
    return TextField(
      controller: _queryController,
      decoration: InputDecoration(
        hintText: '講義名or講師名',
        border: InputBorder.none,
      ),
      onChanged: (query) {
        setState(() {});
      },
      onSubmitted: (query) {
        setState(() {});
      },
    );
  }

  void _onButtonPressed() {
    setState(() {
      _isPressed = true;
    });

    switch (_actionCounter) {
      case 0:
        _doFirstAction();
        _actionCounter++;
        break;
      case 1:
        _doSecondAction();
        _actionCounter++;
        break;
      case 2:
        _doThirdAction();
        _actionCounter = 0;
        break;
    }
  }

  void _doFirstAction() {
    setState(() {
      _isPressed = true;
      _queryController.text = 'ラク単';
      Fluttertoast.showToast(
          msg: "ラク単のみ表示");
    });  }

  void _doSecondAction() {
    // 二つ目の処理
    setState(() {
      _isPressed = false;
      _queryController.text = 'エグ単';
      Fluttertoast.showToast(
          msg: "エグ単のみ表示");
    });
  }

  void _doThirdAction() {
    // 三つ目の処理
    setState(() {
      _isPressed = true;
      _queryController.clear();
      Fluttertoast.showToast(
          msg: "全て表示");
    });
  }


  //大学のアカウント以外は非表示にする
  late FirebaseAuth auth;
  bool showFloatingActionButton = false;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null && user.email != null && user.email!.endsWith('ous.jp')) {
      showFloatingActionButton = true;
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: !_searchBoolean ? Text('獣医学部') : _searchTextField(),
          actions: !_searchBoolean
              ? [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _searchBoolean = true;
                  });
                })
          ]
              : [
            IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchBoolean = false;
                    _queryController.clear();
                  });
                })
          ]),
      body: FutureBuilder<List<AlgoliaObjectSnapshot>>(
        future: _searchAlgolia(_queryController.text),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 200,
                        height: 200,
                        child: Image(
                          image: AssetImage('assets/icon/error.gif'),
                          fit: BoxFit.cover,
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      '校外のメールアドレスでログインしているため\nこの機能は利用できません。',
                      style: TextStyle(fontSize: 18.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ));
          }
          if (snapshot.hasData) {
            final hits = snapshot.data!;
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final hit = hits[index];

                  return Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                zyugyoumei: hit.data['zyugyoumei'],
                                kousimei: hit.data['kousimei'],
                                tannisuu: hit.data['tannisuu'],
                                zyugyoukeisiki: hit.data['zyugyoukeisiki'],
                                syusseki: hit.data['syusseki'],
                                kyoukasyo: hit.data['kyoukasyo'],
                                tesutokeisiki: hit.data['tesutokeisiki'],
                                omosirosa: hit.data['omosirosa'],
                                toriyasusa: hit.data['toriyasusa'],
                                sougouhyouka: hit.data['sougouhyouka'],
                                komento: hit.data['komento'],
                                name: hit.data['name'],
                                senden: hit.data['senden'],
                                nenndo: hit.data['nenndo'],

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
                                          hit.data['zyugyoumei'],
                                          style: TextStyle(fontSize: 20.sp),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ))),
                                Align(
                                  alignment: const Alignment(-0.8, 0.4),
                                  child: Text(
                                    hit.data['gakki'],
                                    style: TextStyle(color: Colors.lightGreen,fontSize: 15.sp),
                                  ),
                                ),
                                Align(
                                  alignment: const Alignment(-0.8, 0.8),
                                  child: Text(
                                    hit.data['kousimei'],
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
                                          color: hit.data['bumon'] == 'エグ単'
                                              ? Colors.red
                                              : Colors.lightGreen[200],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ) // green shaped
                                      ),
                                      child: Text(
                                        hit.data['bumon'],style: TextStyle(fontSize: 15.sp,color: Colors.black),
                                        // Your text
                                      )),
                                ),

                              ],
                            ),
                          ),
                        )),
                      ));
                }
            );
          }
          else  {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: showFloatingActionButton
          ? Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: [

              Container(
                margin: EdgeInsets.only(top: 16),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => post()),
                    );
                  },
                  child: const Icon(Icons.upload_outlined),
                ),
              )
            ],
          ),
        ],
      )
          :   FloatingActionButton(
        heroTag: "btn1",
        onPressed: _onButtonPressed,
        child: Icon(Icons.filter_alt_outlined),
      ),
    );
  }
}

/*お気に入りボタン
 Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              heroTag: "btn2",

              onPressed: () {

              },
              child: const Icon(Icons.favorite_outline),
            ),
          ),
 */
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
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final GlobalKey shareKey = GlobalKey();//追加


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

  Future<File> getApplicationDocumentsFile(String text, List<int> imageData) async {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.zyugyoumei),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
            child: RepaintBoundary(
                key: shareKey,
                child:Container(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Color(0xFFFDFDF5)
                      : Color(0xFF1A1C17),
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
                                        color: Color.fromARGB(139, 134, 134, 134),
                                        thicknessUnit: GaugeSizeUnit.factor,
                                      ),
                                      pointers: <GaugePointer>[
                                        RangePointer(
                                          value: widget.omosirosa.toDouble(),
                                          cornerStyle: CornerStyle.bothCurve,
                                          color: Colors.lightGreen,
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
                                        color: Colors.lightGreen,
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
                                        color: Colors.lightGreen,
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
                            'ニックネーム',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 50,
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
                            '宣伝',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 50,
                            ),
                            child: SelectableText(
                              widget.senden ?? '不明',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0.h),
                          Container(
                            height: 40.0.h,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.lightGreen,
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
                )
            )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => shareImageAndText(
          'sample_widget',
          shareKey,
        ),
        child: const Icon(Icons.ios_share),
      ),
    );
  }
}