import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultipleCollectionsPage extends StatefulWidget {
  @override
  _MultipleCollectionsPageState createState() => _MultipleCollectionsPageState();
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
            List<DocumentSnapshot> documents = snapshot.data as List<DocumentSnapshot>;
            List<Widget> cards = [];
            for (DocumentSnapshot document in documents) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              if (data['accountuid'] == _auth.currentUser!.uid) {
                cards.add(
                  Card(
                    child: ListTile(
                      title: Text(data['zyugyoumei']),
                      subtitle: Text(data['kousimei']),
                    ),
                  ),
                );
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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collection).get();
      documents.addAll(querySnapshot.docs);
    }
    return documents;
  }
}
