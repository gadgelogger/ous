
import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

class MultipleCollectionsPage extends StatefulWidget {
  @override
  _MultipleCollectionsPageState createState() =>
      _MultipleCollectionsPageState();
}

class _MultipleCollectionsPageState extends State<MultipleCollectionsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('投稿した評価'),
      ),
      body: FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<DocumentSnapshot> documents =
                snapshot.data as List<DocumentSnapshot>;
            List<Widget> cards = [];
            for (DocumentSnapshot document in documents) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              if (data['accountuid'] == _auth.currentUser!.uid) {
                cards.add(GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                          zyugyoumei: data['zyugyoumei'],
                          kousimei: data['kousimei'],
                          tannisuu: data['tannisuu'],
                          zyugyoukeisiki: data['zyugyoukeisiki'],
                          syusseki: data['syusseki'],
                          kyoukasyo: data['kyoukasyo'],
                          tesutokeisiki: data['tesutokeisiki'],
                          omosirosa: data['omosirosa'],
                          toriyasusa: data['toriyasusa'],
                          sougouhyouka: data['sougouhyouka'],
                          komento: data['komento'],
                          name: data['name'],
                          senden: data['senden'],
                          nenndo: data['nenndo'],
                          ID: data['ID'],
                        ),
                      ),
                    );
                  },
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
                                  data['zyugyoumei'],
                                  style: TextStyle(fontSize: 20.sp),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        Align(
                          alignment: const Alignment(-0.8, 0.4),
                          child: Text(
                            data['gakki'],
                            style: TextStyle(
                                color: Colors.lightGreen, fontSize: 15.sp),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(-0.8, 0.8),
                          child: Text(
                            data['kousimei'],
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
                                  color: data['bumon'] == 'エグ単'
                                      ? Colors.red
                                      : Colors.lightGreen[200],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ) // green shaped
                                  ),
                              child: Text(
                                data['bumon'],
                                style: TextStyle(fontSize: 15.sp),
                                // Your text
                              )),
                        ),
                      ],
                    ),
                  ),
                ));
              }
            }
            if (cards.isEmpty) {
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
                    '何も投稿していません',
                    style: TextStyle(fontSize: 18.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ));
            } else {
              return GridView.count(
                crossAxisCount: 2, // 2列に設定
                children: cards,
              );
            }
          }
        },
      ),
    );
  }

  Future<List<DocumentSnapshot>> _getData() async {
    List<String> collections = [
      'rigaku',
      'kougakubu',
      'zyouhou',
      'seibutu',
      'kyouiku',
      'keiei',
      'zyuui',
      'seimei',
      'kiban',
      'kyousyoku'
    ];
    List<DocumentSnapshot> documents = [];
    for (String collection in collections) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(collection).get();
      documents.addAll(querySnapshot.docs);
    }
    return documents;
  }
}

class DetailsScreen extends StatelessWidget {
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
  final ID;

  const DetailsScreen(
      {Key? key,
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
      required this.ID,
      required this.senden})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(zyugyoumei),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                child: Text(
                  kousimei ?? '不明',
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
                child: Text(
                  nenndo ?? '不明'.toString(),
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
                child: Text(
                  tannisuu.toString(),
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
                child: Text(
                  zyugyoukeisiki,
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
                child: Text(
                  syusseki,
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
                child: Text(
                  kyoukasyo,
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
                child: Text(
                  tesutokeisiki ?? '不明',
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
                                  value: omosirosa.toDouble(),
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
                                      omosirosa.toDouble().toStringAsFixed(0) +
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
                                value: toriyasusa.toDouble(),
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
                                    toriyasusa.toDouble().toStringAsFixed(0) +
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
                                value: sougouhyouka.toDouble(),
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
                                    sougouhyouka.toDouble().toStringAsFixed(0) +
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
                  Text(
                    komento ?? '不明',
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
                    child: Text(
                      name ?? '不明',
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
                    child: Text(
                      senden ?? '不明',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0.h),
                  /*  Container(
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
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("この投稿をブロックします。"),
                                content: Text("本当にいい？",textAlign: TextAlign.center,),
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: Text("ダメやで"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: Text("ええで"),
                                    onPressed: () async {
                                      //ブロック処理
                                      FirebaseFirestore.instance.collection(widget.gakubu).doc(widget.doc.id).delete();

                                      await Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) {
                                          return Review();
                                        }),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Center(
                          child: Text(
                            'この投稿をブロックする。',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),*/
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Do something when FAB is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return Edit(
                id: ID,
              );
            }),
          );
        },
        child: Icon(Icons.mode_edit_outlined),
      ),
    );
  }
}

class Edit extends StatefulWidget {
  final String id;

  const Edit({Key? key, required this.id}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {

  //投稿データ(現在
  String? iscategory = '';
  String? isbumon = 'ラク単';
  var _text = 'Hello'; //初期値はHello
  String? isnendo = '';
  String? isgakki = '';
  String? iszyugyoumei = '';
  String? iskousimei = '';
  String? istanni = '';
  String? iszyugyoukeisiki = '';
  String? issyusseki = '';
  String? iskyoukasyo = '';
  String? istesutokeisiki = '';
  String? istesutokeikou = '';
  String? isname = '';

  String? iskomento = '';
  String? issenden = '';
  //総合評価
  double _hyouka = 0;

  //面白さ
  double _omosirosa = 0;

  //単位の取りやすさ
  double _toriyasusa = 0;

  //投稿データ(現在

  Future<List<DocumentSnapshot>> _getData() async {
    List<String> collections = [
      'rigaku',
      'kougakubu',
      'zyouhou',
      'seibutu',
      'kyouiku',
      'keiei',
      'zyuui',
      'seimei',
      'kiban',
      'kyousyoku'
    ];
    List<DocumentSnapshot> documents = [];
    for (String collection in collections) {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(collection).get();
      documents.addAll(querySnapshot.docs);
    }

    return documents;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('編集画面'),
        ),
    body:FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<DocumentSnapshot> documents =
            snapshot.data as List<DocumentSnapshot>;
            List<Widget> cards = [];
            for (DocumentSnapshot document in documents) {
              Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;
              if (data['ID'] == widget.id) {
                return Container(
                  child: Scrollbar(
                    isAlwaysShown: true,
                    child: Padding(
                      padding: EdgeInsets.all(15.0), //全方向にパディング１００
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Center(
                              child:   Text(
                                '投稿する授業の部門を選んでください',
                                style: GoogleFonts.notoSans(
                                  // フォントをnotoSansに指定(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                            ),
                            Text(document['bumon'])
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          }
          return SizedBox.shrink(); // 条件に合致しない場合には空のSizedBoxを返す
        }
    )

  );
}
