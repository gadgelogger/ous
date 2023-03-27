import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ous/NavBar.dart';
import 'package:ous/review/gakubu/keieigakubu.dart';
import 'package:ous/review/gakubu/kibankamoku.dart';
import 'package:ous/review/gakubu/kougakubu.dart';
import 'package:ous/review/gakubu/kyouikugakubu.dart';
import 'package:ous/review/gakubu/kyousyokukamoku.dart';
import 'package:ous/review/gakubu/rigakubu.dart';
import 'package:ous/review/gakubu/seibututikyuugakubu.dart';
import 'package:ous/review/gakubu/seimeikagaku.dart';
import 'package:ous/review/gakubu/zyouhourikougakubu.dart';
import 'package:ous/review/gakubu/zyuuigakubu.dart';
import 'package:ous/review/post.dart';
import 'package:ous/review/postuser.dart';
import 'package:algolia/algolia.dart';

import 'package:path/path.dart';
import 'package:pie_chart/pie_chart.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;




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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:algolia/algolia.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:share_extend/share_extend.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';



class Review extends StatefulWidget {
  const Review({Key? key}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {

  Future<Map<String, dynamic>> _getDocumentCount() async {
    Map<String, dynamic> result = {};
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
    for (String collection in collections) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collection).get();
      result[collection] = querySnapshot.size;
    }
    return result;
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

    Widget build(BuildContext context) => Scaffold(

      drawer: NavBar(),
      appBar: AppBar(
        elevation: 0,
        title: Text('講義評価'),
      ),
      body: WillPopScope(
        onWillPop: ()async => false,
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [


                    GestureDetector(
                      child: Card(

                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            height: 176.h,
                            width: 180.w,
                            child: Column(
                              children: [
                                Container(

                                  decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                  child: Image.asset(
                                    'assets/images/理学部.jpg',
                                    height: 110.h,
                                    width: 200.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '理学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Rigakubu()),
                        );
                      },

                    ),
                    GestureDetector(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            height: 176.h,
                            width: 180.w,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                  child: Image.asset(
                                    'assets/images/工学部.jpg',
                                    height: 110.h,
                                    width: 180.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '工学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),                                    ),
                                ),
                              ],
                            )),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Kougakubu()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            height: 176.h,
                            width: 180.w,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                  child: Image.asset(
                                    'assets/images/情報理工学部.jpg',
                                    height: 110.h,
                                    width: 180.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '情報理工学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),                                    ),
                                ),
                              ],
                            )),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => zyouhourikougakubu()),
                        );
                      },
                    ),
                    GestureDetector(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            height: 176.h,
                            width: 180.w,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                  child: Image.asset(
                                    'assets/images/生物地球学部.jpg',
                                    height: 110.h,
                                    width: 180.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '生物地球学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),                                    ),
                                ),
                              ],
                            )),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => seibututikyuu()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            height: 176.h,
                            width: 180.w,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                  child: Image.asset(
                                    'assets/images/教育学部.jpg',
                                    height: 110.h,
                                    width: 180.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '教育学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),                                    ),
                                ),
                              ],
                            )),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => kyouikugakubu()),
                        );
                      },
                    ),
                    GestureDetector(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            height: 176.h,
                            width: 180.w,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                  child: Image.asset(
                                    'assets/images/経営学部.jpg',
                                    height: 110.h,
                                    width: 180.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '経営学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),                                    ),
                                ),
                              ],
                            )),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => keieigakubu()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            height: 176.h,
                            width: 180.w,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                  child: Image.asset(
                                    'assets/images/獣医学部.jpg',
                                    height: 110.h,
                                    width: 180.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '獣医学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),                                    ),
                                ),
                              ],
                            )),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => zyuuigakubu()),
                        );
                      },
                    ),
                    GestureDetector(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            height: 176.h,
                            width: 180.w,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.lightGreen[100]),
                                  child: Image.asset(
                                    'assets/images/生命科学部.jpg',
                                    height: 110.h,
                                    width: 180.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                ListTile(
                                  title:  Text(
                                    '生命科学部',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => seimei()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Divider(), //区切り線
              Text(
                '共通科目はこちら',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            height: 100.h,
                            width: 180.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListTile(
                                  title:  Text(
                                    '基盤教育科目',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => kibankamoku()),
                        );
                      },
                    ),
                    GestureDetector(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                            height: 100.h,
                            width: 180.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListTile(
                                  title:  Text(
                                    '教職関連科目',
                                    style: GoogleFonts.notoSans(
                                      // フォントをnotoSansに指定(
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => kyousyokukamoku()),
                        );
                      },
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    floatingActionButton: showFloatingActionButton
        ? Column(
      verticalDirection: VerticalDirection.up,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => debug()),
                  );
                },
                child: const Icon(Icons.favorite_border),
              ),
            ),
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MultipleCollectionsPage()),
                );
              },              child: Icon(Icons.person_2_outlined),
            ),
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
        : null,




    );

}



class debug extends StatefulWidget {
  @override
  _debugState createState() => _debugState();
}

class _debugState extends State<debug> {
  bool _isPressed = false;
  int _actionCounter = 0;
  final _queryController = TextEditingController();

  Algolia _algolia = Algolia.init(
    applicationId: '78CZVABC2W',
    apiKey: 'c2377e7faad9a408d5867b849f25fae4',
  );

  String _query = '';
  bool _isSearching = false;
  int _filterCount = 0;

  Future<List<AlgoliaObjectSnapshot>> _search(String query) async {
    final result = await _algolia.instance
        .index('rigaku')
        .search(query)
        .getObjects();

    return result.hits;
  }

  List<DocumentSnapshot> _filterData(List<DocumentSnapshot> data) {
    if (_filterCount == 1) {
      // Filter Rakutan only
      return data.where((document) => document['bumon'] == 'ラク単').toList();
    } else if (_filterCount == 2) {
      // Filter Egutan only
      return data.where((document) => document['bumon'] == 'エグ単').toList();
    } else {
      // Return all data
      return data;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _queryController,
          autofocus: true,
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
          decoration: InputDecoration(
            hintText: '講義名or講師名',
          ),
        )
            : Text('理学部'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: _isSearching && _query.isNotEmpty
            ? FutureBuilder(
          future: _search(_query),
          builder: (context,
              AsyncSnapshot<List<AlgoliaObjectSnapshot>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final data = snapshot.data!;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final hit = data[index].data;
                  return Container(
                      child: GestureDetector(
                        onTap: () {
//algolia
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                zyugyoumei: hit['zyugyoumei'],
                                kousimei: hit['kousimei'],
                                tannisuu: hit['tannisuu'],
                                zyugyoukeisiki: hit['zyugyoukeisiki'],
                                syusseki: hit['syusseki'],
                                kyoukasyo: hit['kyoukasyo'],
                                tesutokeisiki: hit['tesutokeisiki'],
                                omosirosa: hit['omosirosa'],
                                toriyasusa: hit['toriyasusa'],
                                sougouhyouka: hit['sougouhyouka'],
                                komento: hit['komento'],
                                name: hit['name'],
                                senden: hit['senden'],
                                nenndo: hit['nenndo'],
                                date: Timestamp.fromMillisecondsSinceEpoch(
                                    hit['date']).toDate(),
                                tesutokeikou: hit['tesutokeikou'],
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
                                          hit['zyugyoumei'],
                                          style: TextStyle(fontSize: 20.sp),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ))),
                                Align(
                                  alignment: const Alignment(-0.8, 0.4),
                                  child: Text(
                                    hit['gakki'],
                                    style: TextStyle(
                                        color: Colors.lightGreen,
                                        fontSize: 15.sp),
                                  ),
                                ),
                                Align(
                                  alignment: const Alignment(-0.8, 0.8),
                                  child: Text(
                                    hit['kousimei'],
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
                                          color: hit['bumon'] == 'エグ単'
                                              ? Colors.red
                                              : Colors.lightGreen[200],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ) // green shaped
                                      ),
                                      child: Text(
                                        hit['bumon'],
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
            } else {
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
                        '何も見つかりませんでした。\n別のキーワードで検索をしてみてね。',
                        style: TextStyle(fontSize: 18.sp),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ));
            }
          },
        )
            : StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('rigaku')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error'),
              );
            } else if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final data = snapshot.data!.docs.where((document) {
                if (_filterCount == 1) {
                  // Filter Rakutan only
                  Fluttertoast.showToast(msg: "ラク単のみ表示");

                  return document['bumon'] == 'ラク単';
                } else if (_filterCount == 2) {
                  // Filter Egutan only
                  Fluttertoast.showToast(msg: "エグ単のみ表示");

                  return document['bumon'] == 'エグ単';

                } else {
                  Fluttertoast.showToast(msg: "全て表示");

                  // Return all data
                  return true;
                }
              }).toList();
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Container(
                      child: GestureDetector(
                        onTap: () {
                          //firebase

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                zyugyoumei: data[index]['zyugyoumei'],
                                kousimei: data[index]['kousimei'],
                                tannisuu: data[index]['tannisuu'],
                                zyugyoukeisiki: data[index]['zyugyoukeisiki'],
                                syusseki: data[index]['syusseki'],
                                kyoukasyo: data[index]['kyoukasyo'],
                                tesutokeisiki: data[index]['tesutokeisiki'],
                                omosirosa: data[index]['omosirosa'],
                                toriyasusa: data[index]['toriyasusa'],
                                sougouhyouka: data[index]['sougouhyouka'],
                                komento: data[index]['komento'],
                                name: data[index]['name'],
                                senden: data[index]['senden'],
                                nenndo: data[index]['nenndo'],
                                date: data[index]['date'].toDate(),
                                tesutokeikou: data[index]['tesutokeikou'],
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
                                          data[index]['zyugyoumei'],
                                          style: TextStyle(fontSize: 20.sp),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ))),
                                Align(
                                  alignment: const Alignment(-0.8, 0.4),
                                  child: Text(
                                    data[index]['gakki'],
                                    style: TextStyle(
                                        color: Colors.lightGreen,
                                        fontSize: 15.sp),
                                  ),
                                ),
                                Align(
                                  alignment: const Alignment(-0.8, 0.8),
                                  child: Text(
                                    data[index]['kousimei'],
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
                                          color: data[index]['bumon'] == 'エグ単'
                                              ? Colors.red
                                              : Colors.lightGreen[200],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ) // green shaped
                                      ),
                                      child: Text(
                                        data[index]['bumon'],
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
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _filterCount = (_filterCount + 1) % 3;
          },
          );
        },
        child: Icon(Icons.filter_list),
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
                child: Container(
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
                                        color:
                                        Color.fromARGB(139, 134, 134, 134),
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
                ))),
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
