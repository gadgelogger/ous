import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/streams.dart';
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
        body: StreamBuilder<List<QuerySnapshot<Map<String, dynamic>>>>(
          stream: _getStream(),
          builder: (BuildContext context,
              AsyncSnapshot<List<QuerySnapshot<Map<String, dynamic>>>>
                  snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<DocumentSnapshot<Map<String, dynamic>>> documents = [];

            if (snapshot.hasData) {
              for (QuerySnapshot<Map<String, dynamic>> querySnapshot
                  in snapshot.data!) {
                documents.addAll(querySnapshot.docs);
              }
            }

            if (documents.isEmpty) {
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
            }

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot<Map<String, dynamic>> document =
                    documents[index];
                return                       Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(

                              ID: document['ID'],
                              userid: _auth.currentUser!.uid,
                            ),
                          ),
                        );
                      },
                      child: (SizedBox(

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
                                        document['zyugyoumei'],
                                        style: TextStyle(fontSize: 20.sp),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                              Align(
                                alignment: const Alignment(-0.8, 0.4),
                                child: Text(
                                  document['gakki'],
                                  style: TextStyle(
                                      color: Colors.lightGreen,
                                      fontSize: 15.sp),
                                ),
                              ),
                              Align(
                                alignment: const Alignment(-0.8, 0.8),
                                child: Text(
                                  document['kousimei'],
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
                                        color: document['bumon'] == 'エグ単'
                                            ? Colors.red
                                            : Colors.lightGreen[200],
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        ) // green shaped
                                    ),
                                    child: Text(
                                      document['bumon'],
                                      style: TextStyle(
                                          fontSize: 15.sp, color: Colors.black),
                                      // Your text
                                    )),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ));

              },
            );
          },
        ));
  }

  Stream<List<QuerySnapshot<Map<String, dynamic>>>> _getStream() async* {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String? uid = user?.uid;

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

    List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = collections
        .map((collection) => FirebaseFirestore.instance
            .collection(collection)
            .where('accountuid', isEqualTo: uid)
            .snapshots())
        .toList();

    yield* CombineLatestStream.list(streams);
  }
}

class DetailsScreen extends StatefulWidget {
  //現在の講義データ
  final ID;
  final userid;

  //新しい講義データ
  String? zyugyoumei = '';

  DetailsScreen({
    Key? key,

    required this.ID,
    required this.userid,

  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {


  //取得
  Stream<List<QuerySnapshot<Map<String, dynamic>>>> _getStream() async* {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String? uid = user?.uid;

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

    List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = collections
        .map((collection) => FirebaseFirestore.instance
        .collection(collection)
        .where('accountuid', isEqualTo: uid)
        .where('ID', isEqualTo: widget.ID)

        .snapshots())
        .toList();

    yield* CombineLatestStream.list(streams);
  }

//更新
  Future<void> updateAllDocuments() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String? uid = user?.uid;

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

    final WriteBatch batch = FirebaseFirestore.instance.batch();

    for (String collection in collections) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance
          .collection(collection)
          .where('accountuid', isEqualTo: uid)
          .where('ID', isEqualTo: widget.ID)

          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      for (QueryDocumentSnapshot<Map<String, dynamic>> document in documents) {
        batch.update(document.reference, {
          'date': DateTime.now(),
          'zyugyoumei':widget.zyugyoumei
        });
      }
    }

    await batch.commit();
  }


  //テキストフォーム関連

  TextEditingController _controller = TextEditingController();


  // テキストの編集が完了したときに呼び出されるコールバック
  void _onTextEditingComplete() {
    String text = _controller.text;
    _controller.clear();
  }

  void textview() {
    String text = _controller.text;
    setState(() {
      widget.zyugyoumei = text;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('aaaa'),
        actions: [
          IconButton(
              icon: Icon(Icons.mode_edit_outlined),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text("編集モード"),
                      content: Text(
                        "編集モードです\n各項目上で長押しをすると\n編集できます",
                        textAlign: TextAlign.center,
                      ),
                      actions: <Widget>[
                        // ボタン領域
                        TextButton(
                          child: Text("おけ"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  },
                );
                updateAllDocuments();
              }),
        ],
      ),
        body:StreamBuilder<List<QuerySnapshot<Map<String, dynamic>>>>(
          stream: _getStream(),
          builder: (BuildContext context,
              AsyncSnapshot<List<QuerySnapshot<Map<String, dynamic>>>>
              snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<DocumentSnapshot<Map<String, dynamic>>> documents = [];

            if (snapshot.hasData) {
              for (QuerySnapshot<Map<String, dynamic>> querySnapshot
              in snapshot.data!) {
                documents.addAll(querySnapshot.docs);
              }
            }

            if (documents.isEmpty) {
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
            }

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot<Map<String, dynamic>> document =
                documents[index];
                return  Container(
                  margin: EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text("授業名"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      TextFormField(
                                        controller: _controller,
                                        decoration: InputDecoration(
                                            labelStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.lightGreen))),

                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    // ボタン領域
                                    TextButton(
                                      child: Text("やっぱやめる"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                        child: Text("おけ"),
                                        onPressed: () async {
                                          textview();
                                          _onTextEditingComplete();

                                          updateAllDocuments();
                                          Navigator.pop(context);
                                        }),
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '授業名',
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
                                  document['zyugyoumei'] ?? '不明',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text(""),
                                  content: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    // ボタン領域
                                    TextButton(
                                      child: Text("やっぱやめる"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(child: Text("おけ"), onPressed: () {}),
                                  ],
                                );
                              },
                            );
                          },
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
                                 document['kousimei'] ?? '不明',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text("年度"),
                                  content: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    // ボタン領域
                                    TextButton(
                                      child: Text("やっぱやめる"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(child: Text("おけ"), onPressed: () {}),
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  document['nenndo'] ?? '不明'.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text(""),
                                  content: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    // ボタン領域
                                    TextButton(
                                      child: Text("やっぱやめる"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(child: Text("おけ"), onPressed: () {}),
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  document['tannisuu'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text(""),
                                  content: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    // ボタン領域
                                    TextButton(
                                      child: Text("やっぱやめる"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(child: Text("おけ"), onPressed: () {}),
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  document['zyugyoukeisiki'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text(""),
                                  content: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    // ボタン領域
                                    TextButton(
                                      child: Text("やっぱやめる"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(child: Text("おけ"), onPressed: () {}),
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  document['syusseki'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text(""),
                                  content: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    // ボタン領域
                                    TextButton(
                                      child: Text("やっぱやめる"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(child: Text("おけ"), onPressed: () {}),
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  document['kyoukasyo'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text(""),
                                  content: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    // ボタン領域
                                    TextButton(
                                      child: Text("やっぱやめる"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(child: Text("おけ"), onPressed: () {}),
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  document['tesutokeisiki'] ?? '不明',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Column(
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: Text(""),
                                        content: Text(
                                          "",
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: <Widget>[
                                          // ボタン領域
                                          TextButton(
                                            child: Text("やっぱやめる"),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          TextButton(child: Text("おけ"), onPressed: () {}),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                                  value: document['omosirosa'].toDouble(),
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
                                                      document['omosirosa']
                                                          .toDouble()
                                                          .toStringAsFixed(0) +
                                                          ' / 5',
                                                      style: TextStyle(
                                                          fontSize: 50.sp,
                                                          fontWeight: FontWeight.bold),
                                                    ))
                                              ])
                                        ])),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: Text(""),
                                        content: Text(
                                          "",
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: <Widget>[
                                          // ボタン領域
                                          TextButton(
                                            child: Text("やっぱやめる"),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          TextButton(child: Text("おけ"), onPressed: () {}),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                                value: document['toriyasusa'].toDouble(),
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
                                                    document['toriyasusa']
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
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: Text(""),
                                        content: Text(
                                          "",
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: <Widget>[
                                          // ボタン領域
                                          TextButton(
                                            child: Text("やっぱやめる"),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          TextButton(child: Text("おけ"), onPressed: () {}),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                                value: document['sougouhyouka'].toDouble(),
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
                                                    document['sougouhyouka']
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
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text(""),
                                      content: Text(
                                        "",
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        // ボタン領域
                                        TextButton(
                                          child: Text("やっぱやめる"),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                        TextButton(child: Text("おけ"), onPressed: () {}),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Column(
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
                                    document['komento'] ?? '不明',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text(""),
                                      content: Text(
                                        "",
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        // ボタン領域
                                        TextButton(
                                          child: Text("やっぱやめる"),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                        TextButton(child: Text("おけ"), onPressed: () {}),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                      document['name'] ?? '不明',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text(""),
                                      content: Text(
                                        "",
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        // ボタン領域
                                        TextButton(
                                          child: Text("やっぱやめる"),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                        TextButton(child: Text("おけ"), onPressed: () {}),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                      document['senden'] ?? '不明',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ),
                                ],
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
                );
              },
            );
          },
        ));
  }
}
