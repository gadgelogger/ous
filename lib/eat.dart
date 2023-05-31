import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Eat extends StatelessWidget {
  const Eat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('食堂'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //学内食堂
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '学内食堂一覧',
                textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.sp),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                Column(
                  children: [
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        width: 150,
                        height: 150,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/食堂/たんぽぽ.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text('たんぽぽ'),
                  ],
                ),


                Column(
                  children: [
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        width: 150,
                        height: 150,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/食堂/ハラール.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text('レストランハラール'),
                  ],
                ),
                Column(
                  children: [
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        width: 150,
                        height: 150,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/食堂/うどん.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text('うどん専門店　Udonや'),
                  ],
                ),
                Column(
                  children: [
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        width: 150,
                        height: 150,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/食堂/るるぱ.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text('るるぱ'),
                  ],
                ),
                Column(
                  children: [
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        width: 150,
                        height: 150,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/食堂/ゼロイチ.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text('ゼロイチ食堂'),
                  ],
                ),
              ],
                shrinkWrap: true,
              ),
            ),
            Divider(),
            //キッチンかー

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'キッチンカー',
                textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.sp),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                Column(
                  children: [
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        width: 150,
                        height: 150,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/食堂/697kitchen.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text('697kitchen'),
                  ],
                ),
              ],
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.map_outlined),
        onPressed: (){},
      ),
  );
}
