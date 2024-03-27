// Flutter imports:

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:ous/gen/assets.gen.dart';
// Project imports:
import 'package:ous/infrastructure/config/analytics_service.dart';
import 'package:ous/presentation/widgets/drawer/drawer.dart';
import 'package:ous/presentation/widgets/review/review_top_component.dart';

class Review extends StatefulWidget {
  const Review({Key? key}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();

  static fromJson(Map<String, dynamic> data) {}
}

class _ReviewState extends State<Review> {
  late FirebaseAuth auth;
  bool showFloatingActionButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        actions: const [],
        elevation: 0,
        title: const Text('講義評価'),
      ),
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomCard(
                    imagePath: Assets.images.facultyOfScience.path,
                    title: '理学部',
                    collection: 'rigaku',
                  ),
                  CustomCard(
                    imagePath: Assets.images.facultyOfEngineering.path,
                    title: '工学部',
                    collection: 'kougakubu',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomCard(
                    imagePath: Assets
                        .images.facultyOfInformationScienceAndTechnology.path,
                    title: '情報理工学部',
                    collection: 'zyouhou',
                  ),
                  CustomCard(
                    imagePath:
                        Assets.images.facultyOfBiologyAndEarthScience.path,
                    title: '生物地球学部',
                    collection: 'seibutu',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomCard(
                    imagePath: Assets
                        .images.facultyOfInformationScienceAndTechnology.path,
                    title: '教育学部',
                    collection: 'kyouiku',
                  ),
                  CustomCard(
                    imagePath:
                        Assets.images.schoolOfBusinessAdministration.path,
                    title: '経営学部',
                    collection: 'keiei',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomCard(
                    imagePath: Assets.images.facultyOfVeterinaryMedicine.path,
                    title: '獣医学部',
                    collection: 'zyuui',
                  ),
                  CustomCard(
                    imagePath: Assets.images.schoolOfLifeSciences.path,
                    title: '生命科学部',
                    collection: 'seimei',
                  ),
                ],
              ),
              const Divider(), //区切り線
              const Text(
                '共通科目はこちら',
                style: TextStyle(
                  fontSize: 30,
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
      floatingActionButton:
          showFloatingActionButton ? const FloatingButton() : null,
    );
  }

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null && user.email != null && user.email!.endsWith('ous.jp')) {
      showFloatingActionButton = true;
    }
    // Analytics
    AnalyticsService().setCurrentScreen(AnalyticsServiceScreenName.review);
  }
}
