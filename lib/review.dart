import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ous/NavBar.dart';
import 'package:ous/component/review_top_component.dart';

class Review extends StatefulWidget {
  const Review({Key? key}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        actions: const [
          //ここにアイコン設置
        ],
        elevation: 0,
        title: const Text('講義評価'),
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomCard(
                    imagePath: 'assets/images/理学部.jpg',
                    title: '理学部',
                    collection: 'rigaku',
                  ),
                  CustomCard(
                    imagePath: 'assets/images/工学部.jpg',
                    title: '工学部',
                    collection: 'kougakubu',
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomCard(
                    imagePath: 'assets/images/情報理工学部.jpg',
                    title: '情報理工学部',
                    collection: 'zyouhou',
                  ),
                  CustomCard(
                    imagePath: 'assets/images/生物地球学部.jpg',
                    title: '生物地球学部',
                    collection: 'seibutu',
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomCard(
                    imagePath: 'assets/images/教育学部.jpg',
                    title: '教育学部',
                    collection: 'kyouiku',
                  ),
                  CustomCard(
                    imagePath: 'assets/images/経営学部.jpg',
                    title: '経営学部',
                    collection: 'keiei',
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomCard(
                    imagePath: 'assets/images/獣医学部.jpg',
                    title: '獣医学部',
                    collection: 'zyuui',
                  ),
                  CustomCard(
                    imagePath: 'assets/images/生命科学部.jpg',
                    title: '生命科学部',
                    collection: 'seimei',
                  ),
                ],
              ),
              const Divider(), //区切り線
              Text(
                '共通科目はこちら',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomCard(
                    imagePath: '',
                    title: '基盤教育科目',
                    collection: 'kiban',
                  ),
                  CustomCard(
                    imagePath: '',
                    title: '教職関連科目',
                    collection: 'kyousyoku',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: showFloatingActionButton ? FloatingButton() : null,
    );
  }
}
