// Dart imports:
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
// Project imports:
import 'package:ous/setting/setting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailsScreen extends StatefulWidget {
  final dynamic zyugyoumei;
  final dynamic kousimei;
  final dynamic tannisuu;
  final dynamic zyugyoukeisiki;
  final dynamic syusseki;
  final dynamic kyoukasyo;
  final dynamic tesutokeisiki;
  final dynamic omosirosa;
  final dynamic toriyasusa;
  final dynamic sougouhyouka;
  final dynamic komento;
  final dynamic name;
  final dynamic senden;
  final dynamic nenndo;
  final dynamic date;
  final dynamic tesutokeikou;
  final dynamic id;

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
  DetailsScreenState createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {
  final GlobalKey shareKey = GlobalKey(); //追加

  @override
  Widget build(BuildContext context) {
    Future<void> removeFavoriteDocument(String documentId) async {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final userRef = FirebaseFirestore.instance.collection('users');
      final favoriteRef = userRef.doc(userId).collection('favorite');

      await favoriteRef.doc(documentId).delete();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.zyugyoumei),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: RepaintBoundary(
            key: shareKey,
            child: Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).colorScheme.background.withOpacity(0.6)
                  : Theme.of(context).colorScheme.background.withOpacity(0.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '講義名',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: SelectableText(
                      widget.zyugyoumei ?? '不明',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Text(
                    '講師名',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: SelectableText(
                      widget.kousimei ?? '不明',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Text(
                    '年度',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: SelectableText(
                      widget.nenndo ?? '不明'.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Text(
                    '単位数',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: SelectableText(
                      widget.tannisuu.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Text(
                    '授業形式',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: SelectableText(
                      widget.zyugyoukeisiki,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Text(
                    '出席確認の有無',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: SelectableText(
                      widget.syusseki,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Text(
                    '教科書の有無',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: SelectableText(
                      widget.kyoukasyo,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Text(
                    'テスト形式',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: SelectableText(
                      widget.tesutokeisiki ?? '不明',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Divider(),
                  Column(
                    children: [
                      const Text(
                        '講義の面白さ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 200,
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
                                    '${widget.omosirosa.toDouble().toStringAsFixed(0)} / 5',
                                    style: const TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        '単位の取りやすさ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 200,
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
                                    '${widget.toriyasusa.toDouble().toStringAsFixed(0)} / 5',
                                    style: const TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        '総合評価',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 200,
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
                                    '${widget.sougouhyouka.toDouble().toStringAsFixed(0)} / 5',
                                    style: const TextStyle(
                                      fontSize: 50,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '講義に関するコメント',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SelectableText(
                        widget.komento ?? '不明',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        'テスト傾向',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        child: Text(widget.tesutokeikou),
                      ),
                      const Text(
                        'ニックネーム',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          top: 10,
                        ),
                        child: SelectableText(
                          widget.name ?? '不明',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const Text(
                        '投稿日・更新日',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        child: Text(
                          DateFormat('yyyy年MM月dd日 HH:mm').format(widget.date),
                          style: const TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Text(
                        '宣伝',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          top: 10,
                        ),
                        child: SelectableText(
                          widget.senden.toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 40.0,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              //ここにブロック関数
                              launchUrlString(
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
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          removeFavoriteDocument(widget.id); // documentId は削除したいドキュメントの ID
          Fluttertoast.showToast(msg: "削除しました。");
          Navigator.pop(
            context,
            MaterialPageRoute(
              builder: (context) => const Setting(),
            ),
          );
        },
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
    );
  }

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
    String text,
    List<int> imageData,
  ) async {
    final directory = await getApplicationDocumentsDirectory();

    final exportFile = File('${directory.path}/$text.png');
    if (!await exportFile.exists()) {
      await exportFile.create(recursive: true);
    }
    final file = await exportFile.writeAsBytes(imageData);
    return file;
  }

  @override
  void initState() {
    super.initState();
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
    } catch (er) {
      debugPrint(er.toString());
    }
  }
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    // 背景の明るさをチェック
    bool isBackgroundBright =
        Theme.of(context).primaryColor == Brightness.light;

    // 明るい背景の場合は黒、暗い背景の場合は白
    Color textColor = isBackgroundBright ? Colors.black : Colors.white;

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('users');
    final favoriteRef = userRef.doc(userId).collection('favorite');

    return Scaffold(
      appBar: AppBar(
        title: const Text('お気に入り'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: favoriteRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('エラーが発生しました'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final favoriteDocs = snapshot.data!.docs;
          final originalDocFutures = favoriteDocs.map((favoriteDoc) {
            final originalDocRef =
                favoriteDoc['originalDocRef'] as DocumentReference;
            return originalDocRef.get();
          }).toList();

          return FutureBuilder<List<DocumentSnapshot>>(
            future: Future.wait(originalDocFutures),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot>> originalDocSnapshot,
            ) {
              if (originalDocSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (originalDocSnapshot.hasError) {
                return const Center(
                  child: Text('エラーが発生しました'),
                );
              }

              final originalDocs = originalDocSnapshot.data!;

              if (originalDocs.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image(
                          image: AssetImage('assets/icon/found.gif'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        '何もお気に入りに登録していません',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: originalDocs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final originalDoc = originalDocs[index];
                    final documentId = originalDoc.id;

                    return GestureDetector(
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
                              id: documentId,
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Align(
                                  alignment: const Alignment(
                                    -0.8,
                                    -0.5,
                                  ),
                                  child: Text(
                                    originalDoc['zyugyoumei'],
                                    style: const TextStyle(fontSize: 20),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: const Alignment(-0.8, 0.4),
                                child: Text(
                                  originalDoc['gakki'],
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: const Alignment(-0.8, 0.8),
                                child: Text(
                                  originalDoc['kousimei'],
                                  overflow: TextOverflow.ellipsis, //ここ！！
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: originalDoc['bumon'] == 'エグ単'
                                        ? Colors.red
                                        : Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ), // green shaped
                                  ),
                                  child: Text(
                                    originalDoc['bumon'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: textColor,
                                    ),
                                    // Your text
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
