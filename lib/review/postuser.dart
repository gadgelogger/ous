// Flutter imports:
// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/streams.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  //現在の講義データ
  final ID;
  final userid;

  const DetailsScreen({
    Key? key,
    required this.ID,
    required this.userid,
  }) : super(key: key);

  @override
  DetailsScreenState createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {
  //新しい講義データ
  String? zyugyoumei = '';
  String? kousimei = '';
  String? nenndo = '';
  final ValueNotifier<String> tanni = ValueNotifier<String>('1');
  final ValueNotifier<String> zyugyoukeisiki = ValueNotifier<String>('対面');
  final ValueNotifier<String> syusseki = ValueNotifier<String>('毎日出席を取る');
  final ValueNotifier<String> kyoukasyo = ValueNotifier<String>('あり');
  String? tesutokeisiki = '';
  final ValueNotifier<double> hyouka = ValueNotifier<double>(0.0);
  final ValueNotifier<double> omosirosa = ValueNotifier<double>(0.0);
  final ValueNotifier<double> toriyasusa = ValueNotifier<double>(0.0);
  String? komento = '';
  String? name = '';
  String? senden = '';
  final ValueNotifier<String> gakki = ValueNotifier<String>('春１');
  final ValueNotifier<String> bumon = ValueNotifier<String>('ラク単');

  //テキストフォーム関連
  final TextEditingController _controller = TextEditingController();

  final TextEditingController _controller1 = TextEditingController();

  final TextEditingController _controller2 = TextEditingController();

  final TextEditingController _controller3 = TextEditingController();

  final TextEditingController _controller4 = TextEditingController();

  final TextEditingController _controller5 = TextEditingController();

  final TextEditingController _controller6 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: _getStream(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<QuerySnapshot<Map<String, dynamic>>>> snapshot,
          ) {
            if (snapshot.hasData && snapshot.data != null) {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
                  snapshot.data!
                      .expand((querySnapshot) => querySnapshot.docs)
                      .toList();

              if (documents.isNotEmpty) {
                String zyugyoumei = documents[0]['zyugyoumei'];
                return Text(zyugyoumei);
              }
            }

            // Placeholder title until data is loaded
            return const Text('Loading...');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mode_edit_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text("編集モード"),
                    content: const Text(
                      "編集モードです\n各項目上で長押しをすると\n編集できます\nまた各項目でダブルタップをするとクリップボードにコピーできます。",
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      // ボタン領域
                      TextButton(
                        child: const Text("おけ"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
                },
              );
              updateAllDocuments();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<QuerySnapshot<Map<String, dynamic>>>>(
        stream: _getStream(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<QuerySnapshot<Map<String, dynamic>>>> snapshot,
        ) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
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
                    '何も投稿していません',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot<Map<String, dynamic>> document =
                  documents[index];
              return Container(
                margin: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onDoubleTap: () {
                          Clipboard.setData(
                            ClipboardData(text: document['zyugyoumei']),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('クリップボードにコピーしました')),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("授業名"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        hintText: 'ここに入力してね',
                                        labelStyle: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: const Text("やっぱやめる"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text("おけ"),
                                    onPressed: () async {
                                      textview();
                                      _onTextEditingComplete();

                                      updateAllDocuments();
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(msg: "完了しました");
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '授業名',
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
                                document['zyugyoumei'] ?? '不明',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //授業名
                      GestureDetector(
                        onDoubleTap: () {
                          Clipboard.setData(
                            ClipboardData(text: document['gakki']),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('クリップボードにコピーしました')),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("開講学期"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ValueListenableBuilder<String>(
                                      valueListenable: gakki,
                                      builder: (
                                        BuildContext context,
                                        String value,
                                        Widget? child,
                                      ) {
                                        return DropdownButton<String>(
                                          value: value,
                                          onChanged: (String? newValue) {
                                            gakki.value = newValue!;
                                          },
                                          items: const [
                                            //5
                                            DropdownMenuItem(
                                              value: '春１',
                                              child: Text('春１'),
                                            ),
                                            DropdownMenuItem(
                                              value: '春２',
                                              child: Text('春２'),
                                            ),
                                            DropdownMenuItem(
                                              value: '秋１',
                                              child: Text('秋１'),
                                            ),
                                            DropdownMenuItem(
                                              value: '秋２',
                                              child: Text('秋２'),
                                            ),
                                            DropdownMenuItem(
                                              value: '春１と２',
                                              child: Text('春１と２'),
                                            ),
                                            DropdownMenuItem(
                                              value: '秋１と２',
                                              child: Text('秋１と２'),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: const Text("やっぱやめる"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text("おけ"),
                                    onPressed: () {
                                      updateAllDocuments14();
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(msg: "完了しました");
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '開講学期',
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
                                document['gakki'] ?? '不明',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //開講学期
                      GestureDetector(
                        onDoubleTap: () {
                          Clipboard.setData(
                            ClipboardData(text: document['bumon']),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('クリップボードにコピーしました')),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("部門"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ValueListenableBuilder<String>(
                                      valueListenable: bumon,
                                      builder: (
                                        BuildContext context,
                                        String value,
                                        Widget? child,
                                      ) {
                                        return DropdownButton<String>(
                                          value: value,
                                          onChanged: (String? newValue) {
                                            bumon.value = newValue!;
                                          },
                                          items: const [
                                            //5
                                            DropdownMenuItem(
                                              value: 'ラク単',
                                              child: Text('ラク単'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'エグ単',
                                              child: Text('エグ単'),
                                            ),
                                            DropdownMenuItem(
                                              value: '普通',
                                              child: Text('普通'),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: const Text("やっぱやめる"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text("おけ"),
                                    onPressed: () {
                                      updateAllDocuments15();
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(msg: "完了しました");
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '部門',
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
                                document['bumon'] ?? '不明',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //部門
                      GestureDetector(
                        onDoubleTap: () {
                          Clipboard.setData(
                            ClipboardData(text: document['kousimei']),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('クリップボードにコピーしました')),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("講師名"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _controller1,
                                      decoration: InputDecoration(
                                        hintText: 'ここに入力してね',
                                        labelStyle: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: const Text("やっぱやめる"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text("おけ"),
                                    onPressed: () async {
                                      textview1();
                                      _onTextEditingComplete();

                                      updateAllDocuments1();
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(msg: "完了しました");
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              child: Text(
                                document['kousimei'] ?? '不明',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //講師名
                      GestureDetector(
                        onDoubleTap: () {
                          Clipboard.setData(
                            ClipboardData(text: document['nenndo']),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('クリップボードにコピーしました')),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("年度"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _controller2,
                                      decoration: InputDecoration(
                                        hintText: '例：2023',
                                        labelStyle: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: const Text("やっぱやめる"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text("おけ"),
                                    onPressed: () async {
                                      textview2();
                                      _onTextEditingComplete();

                                      updateAllDocuments2();
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(msg: "完了しました");
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '年度',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                document['nenndo'] ?? '不明'.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //年度
                      GestureDetector(
                        onDoubleTap: () {
                          Clipboard.setData(
                            ClipboardData(text: document['tannisuu']),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('クリップボードにコピーしました')),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("単位数"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ValueListenableBuilder<String>(
                                      valueListenable: tanni,
                                      builder: (
                                        BuildContext context,
                                        String value,
                                        Widget? child,
                                      ) {
                                        return DropdownButton<String>(
                                          value: value,
                                          onChanged: (String? newValue) {
                                            tanni.value = newValue!;
                                          },
                                          items: const [
                                            DropdownMenuItem<String>(
                                              value: '1',
                                              child: Text('1'),
                                            ),
                                            DropdownMenuItem<String>(
                                              value: '2',
                                              child: Text('2'),
                                            ),
                                            DropdownMenuItem<String>(
                                              value: '3',
                                              child: Text('3'),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: const Text("やっぱやめる"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text("おけ"),
                                    onPressed: () {
                                      updateAllDocuments3();
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(msg: "完了しました");
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '単位数',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                document['tannisuu'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //単位数
                      GestureDetector(
                        onDoubleTap: () {
                          Clipboard.setData(
                            ClipboardData(text: document['zyugyoukeisiki']),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('クリップボードにコピーしました')),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("授業形式"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ValueListenableBuilder<String>(
                                      valueListenable: zyugyoukeisiki,
                                      builder: (
                                        BuildContext context,
                                        String value,
                                        Widget? child,
                                      ) {
                                        return DropdownButton<String>(
                                          value: value,
                                          onChanged: (String? newValue) {
                                            zyugyoukeisiki.value = newValue!;
                                          },
                                          items: const [
                                            //5
                                            DropdownMenuItem(
                                              value: 'オンライン(VOD)',
                                              child: Text('オンライン(VOD)'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'オンライン(リアルタイム）',
                                              child: Text('オンライン(リアルタイム）'),
                                            ),
                                            DropdownMenuItem(
                                              value: '対面',
                                              child: Text('対面'),
                                            ),
                                            DropdownMenuItem(
                                              value: '対面とオンライン',
                                              child: Text('対面とオンライン'),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: const Text("やっぱやめる"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text("おけ"),
                                    onPressed: () {
                                      updateAllDocuments4();
                                      Navigator.pop(context);

                                      Fluttertoast.showToast(msg: "完了しました");
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              child: Text(
                                document['zyugyoukeisiki'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //形式
                      GestureDetector(
                        onDoubleTap: () {
                          Clipboard.setData(
                            ClipboardData(text: document['syusseki']),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('クリップボードにコピーしました')),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("出席確認の有無"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ValueListenableBuilder<String>(
                                      valueListenable: syusseki,
                                      builder: (
                                        BuildContext context,
                                        String value,
                                        Widget? child,
                                      ) {
                                        return DropdownButton<String>(
                                          value: value,
                                          onChanged: (String? newValue) {
                                            syusseki.value = newValue!;
                                          },
                                          items: const [
                                            //5
                                            DropdownMenuItem(
                                              value: '毎日出席を取る',
                                              child: Text('毎日出席を取る'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'ほぼ出席を取る',
                                              child: Text('ほぼ出席を取る'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'たまに出席を取る',
                                              child: Text('たまに出席を取る'),
                                            ),
                                            DropdownMenuItem(
                                              value: '出席確認はなし',
                                              child: Text('出席確認はなし'),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: const Text("やっぱやめる"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text("おけ"),
                                    onPressed: () {
                                      updateAllDocuments5();
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(msg: "完了しました");
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              child: Text(
                                document['syusseki'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //出席
                      GestureDetector(
                        onDoubleTap: () {
                          Clipboard.setData(
                            ClipboardData(text: document['kyoukasyo']),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('クリップボードにコピーしました')),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("単位数"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ValueListenableBuilder<String>(
                                      valueListenable: kyoukasyo,
                                      builder: (
                                        BuildContext context,
                                        String value,
                                        Widget? child,
                                      ) {
                                        return DropdownButton<String>(
                                          value: value,
                                          onChanged: (String? newValue) {
                                            kyoukasyo.value = newValue!;
                                          },
                                          items: const [
                                            //5
                                            DropdownMenuItem(
                                              value: 'あり',
                                              child: Text('あり'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'なし',
                                              child: Text('なし'),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: const Text("やっぱやめる"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text("おけ"),
                                    onPressed: () {
                                      updateAllDocuments6();
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(msg: "完了しました");
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              child: Text(
                                document['kyoukasyo'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //教科書
                      GestureDetector(
                        onDoubleTap: () {
                          Clipboard.setData(
                            ClipboardData(text: document['tesutokeisiki']),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('クリップボードにコピーしました')),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("テスト形式"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _controller3,
                                      decoration: InputDecoration(
                                        labelText: 'ありorなしorレポートorその他...',
                                        labelStyle: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  // ボタン領域
                                  TextButton(
                                    child: const Text("やっぱやめる"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text("おけ"),
                                    onPressed: () async {
                                      textview3();
                                      _onTextEditingComplete();

                                      updateAllDocuments7();
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(msg: "完了しました");
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              child: Text(
                                document['tesutokeisiki'] ?? '不明',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //テスト形式
                      const Divider(),
                      Column(
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text("講義の面白さ"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ValueListenableBuilder<double>(
                                          valueListenable: omosirosa,
                                          builder: (
                                            BuildContext context,
                                            double value,
                                            Widget? child,
                                          ) {
                                            return Column(
                                              children: <Widget>[
                                                Text(
                                                  omosirosa.value
                                                      .toStringAsFixed(0),
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                  ),
                                                ),
                                                Slider(
                                                  value: omosirosa.value,
                                                  min: 0,
                                                  max: 5,
                                                  onChanged: (double value) {
                                                    omosirosa.value = value;
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      // ボタン領域
                                      TextButton(
                                        child: const Text("やっぱやめる"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: const Text("おけ"),
                                        onPressed: () {
                                          updateAllDocuments8();
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                            msg: "完了しました",
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                            value: document['omosirosa']
                                                .toDouble(),
                                            cornerStyle: CornerStyle.bothCurve,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 0.2,
                                            sizeUnit: GaugeSizeUnit.factor,
                                          ),
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
                              ],
                            ),
                          ), //おもしろさ
                          GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text("単位の取りやすさ"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ValueListenableBuilder<double>(
                                          valueListenable: toriyasusa,
                                          builder: (
                                            BuildContext context,
                                            double value,
                                            Widget? child,
                                          ) {
                                            return Column(
                                              children: <Widget>[
                                                Text(
                                                  toriyasusa.value
                                                      .toStringAsFixed(0),
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                  ),
                                                ),
                                                Slider(
                                                  value: toriyasusa.value,
                                                  min: 0,
                                                  max: 5,
                                                  onChanged: (double value) {
                                                    toriyasusa.value = value;
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      // ボタン領域
                                      TextButton(
                                        child: const Text("やっぱやめる"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: const Text("おけ"),
                                        onPressed: () {
                                          updateAllDocuments9();
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                            msg: "完了しました",
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                                            value: document['toriyasusa']
                                                .toDouble(),
                                            cornerStyle: CornerStyle.bothCurve,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 0.2,
                                            sizeUnit: GaugeSizeUnit.factor,
                                          ),
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
                              ],
                            ),
                          ), //取りやすさ
                          GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text("総合評価"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ValueListenableBuilder<double>(
                                          valueListenable: hyouka,
                                          builder: (
                                            BuildContext context,
                                            double value,
                                            Widget? child,
                                          ) {
                                            return Column(
                                              children: <Widget>[
                                                Text(
                                                  hyouka.value
                                                      .toStringAsFixed(0),
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                  ),
                                                ),
                                                Slider(
                                                  value: hyouka.value,
                                                  min: 0,
                                                  max: 5,
                                                  onChanged: (double value) {
                                                    hyouka.value = value;
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      // ボタン領域
                                      TextButton(
                                        child: const Text("やっぱやめる"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: const Text("おけ"),
                                        onPressed: () {
                                          updateAllDocuments10();
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                            msg: "完了しました",
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                                            value: document['sougouhyouka']
                                                .toDouble(),
                                            cornerStyle: CornerStyle.bothCurve,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 0.2,
                                            sizeUnit: GaugeSizeUnit.factor,
                                          ),
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
                              ],
                            ),
                          ), //総合評価
                          const Divider(),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onDoubleTap: () {
                              Clipboard.setData(
                                ClipboardData(text: document['komento']),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('クリップボードにコピーしました'),
                                ),
                              );
                            },
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text("コメント"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _controller4,
                                          // この一文を追加
                                          enabled: true,
                                          maxLength: null,
                                          // 入力数
                                          obscureText: false,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.rate_review_outlined,
                                            ),
                                            labelText: 'この講義は楽で〜...',
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      // ボタン領域
                                      TextButton(
                                        child: const Text("やっぱやめる"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: const Text("おけ"),
                                        onPressed: () async {
                                          textview4();
                                          _onTextEditingComplete();

                                          updateAllDocuments11();
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                            msg: "完了しました",
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '講義に関するコメント',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  document['komento'] ?? '不明',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ), //コメント
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onDoubleTap: () {
                              Clipboard.setData(
                                ClipboardData(text: document['name']),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('クリップボードにコピーしました'),
                                ),
                              );
                            },
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text("ニックネーム"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _controller5,
                                          // この一文を追加
                                          enabled: true,
                                          maxLength: null,
                                          // 入力数
                                          obscureText: false,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.rate_review_outlined,
                                            ),
                                            labelText: 'この講義は楽で〜...',
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      // ボタン領域
                                      TextButton(
                                        child: const Text("やっぱやめる"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: const Text("おけ"),
                                        onPressed: () async {
                                          textview5();
                                          _onTextEditingComplete();

                                          updateAllDocuments12();
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                            msg: "完了しました",
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ニックネーム',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 50,
                                  ),
                                  child: Text(
                                    document['name'] ?? '不明',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ), //ニックネーム
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '投稿日・更新日',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 50,
                                ),
                                child: Text(
                                  DateFormat('yyyy年M月d日 H:mm')
                                      .format(document['date'].toDate()),
                                  style: const TextStyle(fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ), //日付
                          GestureDetector(
                            onDoubleTap: () {
                              Clipboard.setData(
                                ClipboardData(text: document['senden']),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('クリップボードにコピーしました'),
                                ),
                              );
                            },
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text("宣伝"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _controller6,
                                          // この一文を追加
                                          enabled: true,
                                          maxLength: null,
                                          // 入力数
                                          obscureText: false,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                              Icons.rate_review_outlined,
                                            ),
                                            labelText: 'ここに入力してね',
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      // ボタン領域
                                      TextButton(
                                        child: const Text("やっぱやめる"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: const Text("おけ"),
                                        onPressed: () async {
                                          textview6();
                                          _onTextEditingComplete();

                                          updateAllDocuments13();
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                            msg: "完了しました",
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '宣伝',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 50,
                                  ),
                                  child: Text(
                                    document['senden'] ?? '不明',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ), //宣伝
                          const SizedBox(height: 20.0),
                          /*  Container(
                    height: 40.0,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.lightGreen,
                              style: BorderStyle.solid,
                              width: 1.0),
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
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text("投稿の削除"),
                content: const Text(
                  "この投稿を削除します\n大丈夫か？\n\n※削除した投稿は復元できないぞ",
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[
                  // ボタン領域
                  TextButton(
                    child: const Text("やっぱやめる"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text("ええで"),
                    onPressed: () {
                      deleteAllDocuments();
                      Fluttertoast.showToast(msg: "削除しました");
                      int count = 0;
                      Navigator.popUntil(context, (_) => count++ >= 2);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  //削除
  Future<void> deleteAllDocuments() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.delete(document.reference);
      }
    }

    await batch.commit();
  }

  @override
  void dispose() {
    tanni.dispose();
    zyugyoukeisiki.dispose();
    syusseki.dispose();
    kyoukasyo.dispose();
    omosirosa.dispose();
    hyouka.dispose();
    toriyasusa.dispose();
    gakki.dispose();
    bumon.dispose();
    super.dispose();
  }

  void textview() {
    String text = _controller.text;
    setState(() {
      zyugyoumei = text;
    });
  }

  void textview1() {
    String text = _controller1.text;
    setState(() {
      kousimei = text;
    });
  }

  void textview2() {
    String text = _controller2.text;
    setState(() {
      nenndo = text;
    });
  }

  void textview3() {
    String text = _controller3.text;
    setState(() {
      tesutokeisiki = text;
    });
  }

  void textview4() {
    String text = _controller4.text;
    setState(() {
      komento = text;
    });
  }

  void textview5() {
    String text = _controller5.text;
    setState(() {
      name = text;
    });
  }

  void textview6() {
    String text = _controller6.text;
    setState(() {
      senden = text;
    });
  }

//更新-授業名
  Future<void> updateAllDocuments() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'zyugyoumei': zyugyoumei},
        );
      }
    }

    await batch.commit();
  }

  //更新-講師名
  Future<void> updateAllDocuments1() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'kousimei': kousimei},
        );
      }
    }

    await batch.commit();
  }

  //総合評価
  Future<void> updateAllDocuments10() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'sougouhyouka': hyouka.value},
        );
      }
    }

    await batch.commit();
  }

  //コメント
  Future<void> updateAllDocuments11() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'komento': komento},
        );
      }
    }

    await batch.commit();
  }

  //ニックネーム
  Future<void> updateAllDocuments12() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch
            .update(document.reference, {'date': DateTime.now(), 'name': name});
      }
    }

    await batch.commit();
  }

  //宣伝
  Future<void> updateAllDocuments13() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'senden': senden},
        );
      }
    }

    await batch.commit();
  }

  //学期
  Future<void> updateAllDocuments14() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'gakki': gakki.value},
        );
      }
    }

    await batch.commit();
  }

  //部門
  Future<void> updateAllDocuments15() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'bumon': bumon.value},
        );
      }
    }

    await batch.commit();
  }

  //更新-年度
  Future<void> updateAllDocuments2() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'nenndo': nenndo},
        );
      }
    }

    await batch.commit();
  }

  //単位数
  Future<void> updateAllDocuments3() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'tannisuu': tanni.value},
        );
      }
    }

    await batch.commit();
  }

  //授業形式
  Future<void> updateAllDocuments4() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'zyugyoukeisiki': zyugyoukeisiki.value},
        );
      }
    }

    await batch.commit();
  }

  //出席確認の有無
  Future<void> updateAllDocuments5() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'syusseki': syusseki.value},
        );
      }
    }

    await batch.commit();
  }

  //教科書の有無
  Future<void> updateAllDocuments6() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'kyoukasyo': kyoukasyo.value},
        );
      }
    }

    await batch.commit();
  }

  //テスト形式
  Future<void> updateAllDocuments7() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'tesutokeisiki': tesutokeisiki},
        );
      }
    }

    await batch.commit();
  }

  //講義の面白さ
  Future<void> updateAllDocuments8() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'omosirosa': omosirosa.value},
        );
      }
    }

    await batch.commit();
  }

  //単位の取りやすさ
  Future<void> updateAllDocuments9() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
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
        batch.update(
          document.reference,
          {'date': DateTime.now(), 'toriyasusa': toriyasusa.value},
        );
      }
    }

    await batch.commit();
  }

  //取得
  Stream<List<QuerySnapshot<Map<String, dynamic>>>> _getStream() async* {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
    ];

    List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = collections
        .map(
          (collection) => FirebaseFirestore.instance
              .collection(collection)
              .where('accountuid', isEqualTo: uid)
              .where('ID', isEqualTo: widget.ID)
              .snapshots(),
        )
        .toList();

    yield* CombineLatestStream.list(streams);
  }

  // テキストの編集が完了したときに呼び出されるコールバック
  void _onTextEditingComplete() {
    _controller.clear();
    _controller1.clear();
    _controller2.clear();
    _controller3.clear();
    _controller4.clear();
    _controller5.clear();
    _controller6.clear();
  }
}

class MultipleCollectionsPage extends StatefulWidget {
  const MultipleCollectionsPage({Key? key}) : super(key: key);

  @override
  MultipleCollectionsPageState createState() => MultipleCollectionsPageState();
}

class MultipleCollectionsPageState extends State<MultipleCollectionsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // 背景の明るさをチェック
    bool isBackgroundBright =
        Theme.of(context).primaryColor == Brightness.light;

    // 明るい背景の場合は黒、暗い背景の場合は白
    Color textColor = isBackgroundBright ? Colors.black : Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿した評価'),
      ),
      body: StreamBuilder<List<QuerySnapshot<Map<String, dynamic>>>>(
        stream: _getStream(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<QuerySnapshot<Map<String, dynamic>>>> snapshot,
        ) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
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
                    '何も投稿していません',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot<Map<String, dynamic>> document =
                  documents[index];
              return GestureDetector(
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
                              document['zyugyoumei'],
                              style: const TextStyle(fontSize: 20),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(-0.8, 0.4),
                          child: Text(
                            document['gakki'],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(-0.8, 0.8),
                          child: Text(
                            document['kousimei'],
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
                              color: document['bumon'] == 'エグ単'
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ), // green shaped
                            ),
                            child: Text(
                              document['bumon'],
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
        },
      ),
    );
  }

  Stream<List<QuerySnapshot<Map<String, dynamic>>>> _getStream() async* {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
      'kyousyoku',
    ];

    List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = collections
        .map(
          (collection) => FirebaseFirestore.instance
              .collection(collection)
              .where('accountuid', isEqualTo: uid)
              .snapshots(),
        )
        .toList();

    yield* CombineLatestStream.list(streams);
  }
}
