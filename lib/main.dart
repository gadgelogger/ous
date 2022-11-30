import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ous/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:ous/business.dart';
import 'package:ous/test.dart';
import 'package:ous/home.dart';
import 'package:ous/review.dart';
import 'package:ous/info/info.dart';
import 'account/login.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();
  var httpOverrides = new MyHttpOverrides();
  HttpOverrides.global = httpOverrides;

  runApp(
      const MyApp()
  );

}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(392, 759),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context , child) {
          return MaterialApp(
              title: 'ホーム',
              theme: ThemeData(
                primarySwatch: Colors.lightGreen,
                fontFamily: 'NotoSansCJKJp',
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.lightGreen,
                fontFamily: 'NotoSansCJKJp',
              ),
              home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // スプラッシュ画面などに書き換えても良い
                    return const SizedBox();
                  }
                  if (snapshot.hasData) {
                    // User が null でなない、つまりサインイン済みのホーム画面へ
                    return MyHomePage(title: 'home');
                  }
                  // User が null である、つまり未サインインのサインイン画面へ
                  return Login();
                },
              )
          );
        }
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override

  State<MyHomePage> createState() => _MyHomePageState();

}


class _MyHomePageState extends State<MyHomePage> {
  int currentindex = 0;
  final screens = [
    home(),
    Info(),
    Review(),
    Business(),
  ];

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      backgroundColor: Colors.white,
      body: screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentindex,
        onTap: (index) => setState(() => currentindex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
            backgroundColor: Colors.lightGreen,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'お知らせ',
            backgroundColor: Colors.lightGreen,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '講義評価',
            backgroundColor: Colors.lightGreen,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            label: '就活関連',
            backgroundColor: Colors.lightGreen,
          ),
        ],
      ),

    );



  }
}