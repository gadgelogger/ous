import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ous/review/view.dart';
import 'package:ous/test/rigaku.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class seimeikagakubu extends StatefulWidget {
  const seimeikagakubu({Key? key}) : super(key: key);

  @override
  State<seimeikagakubu> createState() => _seimeikagakubuState();
}

class _seimeikagakubuState extends State<seimeikagakubu> {
  String  gakubu = 'seimei';

  final _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> documentList = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,title: Text('生命科学部'),),
      body: SafeArea(
          child: StreamBuilder(
            stream: _firestore.collection('seimei').snapshots(),
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
                            child:
                            Image(
                              image: AssetImage('assets/icon/error.gif'),
                              fit: BoxFit.cover,
                            )),
                        SizedBox(height: 50,),                        Text(
                          '校外のメールアドレスでログインしているため\nこの機能は利用できません。',
                          style: TextStyle(fontSize: 18.sp),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )

                );
              }
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator()
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Container(

                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => View(snapshot.data!.docs[index],gakubu)),
                          );
                        },
                        child: (
                            Card(
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                  height: 180.h,
                                  width: 180.w,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 4 //下４
                                          ),
                                          child: Container(
                                            color: Colors.lightGreen,
                                            child:
                                            Text(snapshot.data!.docs[index].get('bumon'),style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),
                                            ),
                                          )
                                      ),
                                      Container(
                                        child: Center(

                                          child:Padding(padding: EdgeInsets.only(
                                            top: 19,
                                          ),
                                              child: Text(snapshot.data!.docs[index].get('zyugyoumei'),style: TextStyle(fontSize: 20.sp
                                              ),
                                              )
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 8, //左８
                                          right: 8, //右８
                                        ),
                                        child: Text(''),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 8, //左８
                                          right: 8, //右８
                                        ),
                                        child: Text(snapshot.data!.docs[index].get('gakki'),style: TextStyle(color: Colors.lightGreen,fontWeight: FontWeight.bold),),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 8, //左８
                                          right: 8, //右８
                                        ),
                                        child: Text(snapshot.data!.docs[index].get('kousimei')),
                                      ),
                                    ],
                                  )
                              ),
                            )
                        ),
                      ),
                    );
                  }

              );
            },
          )
      ),
    );
  }
}
