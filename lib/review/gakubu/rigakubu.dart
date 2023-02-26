import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ous/review/view.dart';
import 'package:ous/test/rigaku.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:algolia/algolia.dart';

import '../../main.dart';

class Rigakubu extends StatefulWidget {
  const Rigakubu({Key? key}) : super(key: key);

  @override
  State<Rigakubu> createState() => _RigakubuState();
}

class _RigakubuState extends State<Rigakubu> {
  String gakubu = 'rigaku';
  final _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> documentList = [];
  String test = 'FB219000 学びの基礎論';
  bool _searchBoolean = false; //追加
  StreamController searchController = StreamController();


  Future searchFireStore(word) async {
    Algolia algolia = Application.algolia;
    AlgoliaQuery query = algolia.instance.index("rigaku_index").query(word);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    List<AlgoliaObjectSnapshot> hits = snap.hits;
    searchController.add(hits);
  }

  Widget _searchTextField() {
    return TextField(
      autofocus: true, //TextFieldが表示されるときにフォーカスする（キーボードを表示する）
      style: TextStyle( //テキストのスタイル
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search, //キーボードのアクションボタンを指定
      decoration: InputDecoration( //TextFiledのスタイル
        enabledBorder: UnderlineInputBorder( //デフォルトのTextFieldの枠線
        ),
        focusedBorder: UnderlineInputBorder( //TextFieldにフォーカス時の枠線
        ),
        hintText: '講義名or講師名', //何も入力してないときに表示されるテキスト
        hintStyle: TextStyle( //hintTextのスタイル
          fontSize: 20,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: !_searchBoolean ? Text('理学部') : _searchTextField(),
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
                        });
                      })
                ]),
      body: SafeArea(
        child: StreamBuilder(
          stream: _firestore.collection('rigaku').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            if (!snapshot.hasData) {
              return Column(
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Container(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                View(snapshot.data!.docs[index], gakubu)),
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
                                      snapshot.data!.docs[index]
                                          .get('zyugyoumei'),
                                      style: TextStyle(fontSize: 20),
                                    ))),
                            Align(
                              alignment: const Alignment(-0.8, 0.4),
                              child: Text(
                                snapshot.data!.docs[index].get('gakki'),
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(-0.8, 0.8),
                              child: Text(
                                snapshot.data!.docs[index].get('kousimei'),
                                overflow: TextOverflow.ellipsis, //ここ！！
                              ),
                            ),
                            Positioned(
                              top: 0,
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 6),
                                  decoration: BoxDecoration(
                                      color: snapshot.data!.docs[index]
                                                  .get('bumon') ==
                                              'エグ単'
                                          ? Colors.red
                                          : Colors.lightGreen[200],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ) // green shaped
                                      ),
                                  child: Text(
                                    snapshot.data!.docs[index]
                                        .get('bumon'), // Your text
                                  )),
                            )
                          ],
                        ),
                      ),
                    )),
                  ));
                });
          },
        ),
      ),
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.filter_alt_outlined),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.favorite_outline),
            ),
          ),
        ],
      ),
    );
  }
}
