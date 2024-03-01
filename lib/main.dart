// Dart imports:
import 'dart:io';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Project imports:
import 'package:ous/NavBar.dart';
import 'package:ous/analytics_service.dart';
import 'package:ous/home.dart';
import 'package:ous/info/info.dart';
import 'package:ous/review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'account/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ここに追加

  // Firebaseの初期化
  await Firebase.initializeApp();
  // Analytics
  await AnalyticsService().logBeginCheckout(); // 追加

  // 画面回転無効化
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
  );

  //Setting SysemUIOverlay（ナビゲーションバー透過）
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

//Setting SystmeUIMode（ナビゲーションバー透過
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
  WidgetsFlutterBinding.ensureInitialized();

//ジェスチャーナビゲーションを透明にしていい感じにする。
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
  runApp(
    const MyApp(),
  );
}

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 200,
              height: 200,
              child: Image(
                image: AssetImage('assets/icon/maintenance.gif'),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Text(
              'メンテナンス中です！\nメンテナンス終了までお待ち下さい。',
              style: TextStyle(fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 50.h,
            ),
            ElevatedButton(
              onPressed: () {
                final url = Uri.parse('https://twitter.com/TAN_Q_BOT_LOCAL');
                launchUrl(url);
              },
              child: const Text('詳しくは開発者のTwitterをご確認ください。'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 759),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ja'),
          ],
          locale: const Locale('ja'),
          debugShowCheckedModeBanner: false,
          title: 'ホーム',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.lightGreen,
            fontFamily: 'NotoSansCJKJp',
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorSchemeSeed: Colors.lightGreen,
            fontFamily: 'NotoSansCJKJp',
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
//アップデート通知
  late String _currentVersion;
  late String _latestVersion;
//ボトムナビゲーションバー

  int _currentindex = 0;

  List<Widget> pages = [
    const Home(),
    const Info(),
    const Review(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: pages[_currentindex]),
      drawer: const NavBar(),
      backgroundColor: const Color.fromARGB(0, 253, 253, 246),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentindex,
        onDestinationSelected: (index) {
          setState(() {
            _currentindex = index;
          });
          HapticFeedback.heavyImpact(); // ライトインパクトの振動フィードバック
        },
        destinations: const [
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
        ],
      ),
    );
  }
  //クイックショートカット

  @override
  void initState() {
    super.initState();
    _checkVersion();
    //ショートカット関連
  }

  //バージョンチェック
  void _checkVersion() async {
    WidgetsFlutterBinding.ensureInitialized();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    setState(() {
      _currentVersion = version;
    });

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('config')
        .doc('3wmNMFXQArQHWpJA20je')
        .get();
    Map<String, dynamic>? data =
        documentSnapshot.data() as Map<String, dynamic>?;
    if (data != null) {
      setState(() {
        _latestVersion = data['version'];
      });
      if (_currentVersion != _latestVersion) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('アプリのアップデートがあるぞ！'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: '見てくれ',
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "アップデートのお知らせ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Image(
                              image: AssetImage('assets/icon/rocket.gif'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            'アプリのアップデートがあります！\n新機能などが追加されたので\nアップデートをよろしくお願いします。',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        // ボタン領域
                        ElevatedButton(
                          child: const Text("後で"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        if (Platform.isIOS)
                          ElevatedButton(
                            child: const Text("おっけー"),
                            onPressed: () {
                              launch(
                                'https://apps.apple.com/jp/app/%E5%B2%A1%E7%90%86%E3%82%A2%E3%83%97%E3%83%AA/id1671546931',
                              );
                            },
                          ),
                        if (Platform.isAndroid)
                          ElevatedButton(
                            child: const Text("おっけー"),
                            onPressed: () {
                              launch(
                                'https://play.google.com/store/apps/details?id=com.ous.unoffical.app',
                              );
                            },
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      }
    }
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // スプラッシュ画面などに書き換えても良い
        }
        if (snapshot.hasData) {
          // User が null でなない、つまりサインイン済みのホーム画面へ
          return const MyHomePage(title: 'home');
        }
        // User が null である、つまり未サインインのサインイン画面へ
        return const Login();
      },
    );
  }

  Future<bool> checkMaintenance() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 5),
      ),
    );

    await remoteConfig.setDefaults(<String, dynamic>{
      "isUnderMaintenance": false,
    });

    await remoteConfig.fetchAndActivate();
    bool isUnderMaintenance = remoteConfig.getBool('isUnderMaintenance');

    return isUnderMaintenance;
  }

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen(context);
  }

  _navigateToNextScreen(BuildContext context) async {
    bool isUnderMaintenance = await checkMaintenance();
    if (isUnderMaintenance) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MaintenanceScreen()),
      );
    } else {}
  }
}
