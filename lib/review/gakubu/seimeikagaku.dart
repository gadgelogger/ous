import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ous/review/view.dart';
import 'package:ous/test/rigaku.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:algolia/algolia.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../review.dart';

final algolia = Algolia.init(
  applicationId: '78CZVABC2W',
  apiKey: 'c2377e7faad9a408d5867b849f25fae4',
);

final index = algolia.instance.index('seimei');

class seimei extends StatefulWidget {
  const seimei({Key? key}) : super(key: key);

  @override
  State<seimei> createState() => _seimeiState();
}

class _seimeiState extends State<seimei> {
  final _queryController = TextEditingController();
  String gakubu = 'rigaku';
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: !_searchBoolean ? Text('生命科学部') : _searchTextField(),
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
                                  name: hit.data['name']



                              ),
                            ),
                          );
                        },
                        child: (SizedBox(
                          width: 200,
                          height: 30,
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
                                        hit.data['bumon'],
                                        style: TextStyle(fontSize: 15.sp),
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
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              heroTag: "btn1",

              onPressed: _onButtonPressed,

              child:  Icon(Icons.filter_alt_outlined)  ,
            ),
          ),

        ],
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
class DetailsScreen extends StatelessWidget {

  final   zyugyoumei;
  final  kousimei;
  final  tannisuu;
  final  zyugyoukeisiki;
  final  syusseki;
  final  kyoukasyo;
  final  tesutokeisiki;
  final  omosirosa;
  final  toriyasusa;
  final  sougouhyouka;
  final  komento;
  final name;

  const DetailsScreen({Key? key, required this.zyugyoumei, required this.kousimei, required this.tannisuu,required this.zyugyoukeisiki,required this.syusseki,required this.kyoukasyo,required this.tesutokeisiki,required this.omosirosa,required this.toriyasusa,required this.sougouhyouka,required this.komento,required this.name}) : super(key: key);

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
                  kousimei??'不明',
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
                child: Text(zyugyoukeisiki,  style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15.sp,
                ),),
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
                child: Text(syusseki,  style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15.sp,
                ),),
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
                child: Text(kyoukasyo,  style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15.sp,
                ),),
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
                child: Text(tesutokeisiki??'不明',  style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15.sp,
                ),),
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
                                  value: omosirosa

                                      .toDouble(),
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
                                      omosirosa
                                          .toDouble()
                                          .toStringAsFixed(0) +
                                          ' / 5',
                                      style: TextStyle(
                                          fontSize: 50.sp,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ])
                        ])
                    ),
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
                                value: toriyasusa
                                    .toDouble(),
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
                                    toriyasusa
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
                                value: sougouhyouka
                                    .toDouble(),
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
                                    sougouhyouka
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
                  Text(komento??'不明',style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16.sp,
                  ),),
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
                    child: Text(name??'不明',  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15.sp,
                    ),),
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
                          launch('https://docs.google.com/forms/d/e/1FAIpQLSepC82BWAoARJVh4WeGCFOuIpWLyaPfqqXn524SqxyBSA9LwQ/viewform');
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
    );
  }
}