import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
import 'package:algolia/algolia.dart';
import 'dart:core';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';




//algolia
class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: '78CZVABC2W',
    apiKey: 'c2377e7faad9a408d5867b849f25fae4',
  );
}
//algolia

void main() async {

  // 画面回転無効化
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);

  //Setting SysemUIOverlay（ナビゲーションバー透過）
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark)
  );

//Setting SystmeUIMode（ナビゲーションバー透過
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();
  var httpOverrides = new MyHttpOverrides();
  HttpOverrides.global = httpOverrides;

  runApp(
      const MyApp()
  );


  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
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

    // ここでBuildContextを定義する

    return

      ScreenUtilInit(
        designSize: const Size(392, 759),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context , child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false, // これを追加するだけ

              title: 'ホーム',
              theme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: Color.fromARGB(0, 253, 253, 246),
                fontFamily: 'NotoSansCJKJp',
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                useMaterial3: true,
                colorSchemeSeed: Color.fromARGB(0, 253, 253, 246),
                fontFamily: 'NotoSansCJKJp',
              ),
              home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                  {
                    // スプラッシュ画面などに書き換えても良い
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
  int _currentindex = 0;
  List<Widget> pages = [
    home(),
    Info(),
    Review(),
    Business(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: pages[_currentindex]),
      drawer: NavBar(),
      backgroundColor: Color.fromARGB(0, 253, 253, 246),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentindex,
        onDestinationSelected: (index) => setState(() {
          _currentindex = index;
        }),

        destinations: [

          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'ホーム',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            label: 'お知らせ',
          ),

          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            label: '講義評価',
          ),
    //      NavigationDestination(
      //      icon: Icon(Icons.business_center_outlined),
        //    label: '就活関連',
       //   ),
        ],

          ),


    );
  }
}



