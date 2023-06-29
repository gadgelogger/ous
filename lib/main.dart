import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apikey.dart';
import 'eat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ous/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:ous/home.dart';
import 'package:ous/review.dart';
import 'package:ous/info/info.dart';
import 'account/login.dart';
import 'package:flutter/services.dart';
import 'package:algolia/algolia.dart';
import 'dart:core';
import 'package:url_launcher/url_launcher.dart';
import 'package:ous/setting/globals.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

//algolia
class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: '${algoiaid}',
    apiKey: '${algoliakey}',
  );
}
//algolia

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ここに追加

  // Firebaseの初期化
  await Firebase.initializeApp();

  // 画面回転無効化
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  //Setting SysemUIOverlay（ナビゲーションバー透過）
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));

//Setting SystmeUIMode（ナビゲーションバー透過
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);
  WidgetsFlutterBinding.ensureInitialized();

//ジェスチャーナビゲーションを透明にしていい感じにする。
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);

  await ScreenUtil.ensureScreenSize();
  var httpOverrides = new MyHttpOverrides();
  HttpOverrides.global = httpOverrides;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AppTheme()),
      ],
      child: MyApp(),
    ),
  );
//ダークモード
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  //onesignal
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {




  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
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
              supportedLocales: [
                const Locale('ja'),
              ],
              locale: const Locale('ja'),
              debugShowCheckedModeBanner: false,
              title: 'ホーム',
              theme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: appTheme.currentColor,
                fontFamily: 'NotoSansCJKJp',
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                useMaterial3: true,
                colorSchemeSeed: appTheme.currentColor,
                fontFamily: 'NotoSansCJKJp',
              ),
              themeMode: themeProvider.themeMode,
              home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // スプラッシュ画面などに書き換えても良い
                  }
                  if (snapshot.hasData) {
                    // User が null でなない、つまりサインイン済みのホーム画面へ
                    return MyHomePage(title: 'home');
                  }
                  // User が null である、つまり未サインインのサインイン画面へ
                  return Login();
                },
              ));
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//アップデート通知
  late String _currentVersion;
  late String _latestVersion;
  late bool _updateRequired;
  late String _updateUrl;

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

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
            content: Text('アプリのアップデートがあるぞ！'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: '見てくれ',
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "アップデートのお知らせ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                width: 100,
                                height: 100,
                                child: Image(
                                  image: AssetImage('assets/icon/rocket.gif'),
                                  fit: BoxFit.cover,
                                )),
                            Text(
                              'アプリのアップデートがあります！\n新機能などが追加されたので\nアップデートをよろしくお願いします。',
                              textAlign: TextAlign.center,
                            ),
                          ]),
                      actions: <Widget>[
                        // ボタン領域
                        ElevatedButton(
                            child: Text("後で"),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        if (Platform.isIOS)
                          ElevatedButton(
                              child: Text("おっけー"),
                              onPressed: () {
                                launch(
                                    'https://apps.apple.com/jp/app/%E5%B2%A1%E7%90%86%E3%82%A2%E3%83%97%E3%83%AA/id1671546931');
                              }),
                        if (Platform.isAndroid)
                          ElevatedButton(
                              child: Text("おっけー"),
                              onPressed: () {
                                launch(
                                    'https://play.google.com/store/apps/details?id=com.ous.unoffical.app');
                              }),
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

//アップデート通知

  int _currentindex = 0;
  List<Widget> pages = [
    home(),
    Info(),
    Review(),
    Eat(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(child: pages[_currentindex]),
        drawer: NavBar(),
        backgroundColor: Color.fromARGB(0, 253, 253, 246),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentindex,
          onDestinationSelected: (index) {
            setState(() {
              _currentindex = index;
            });
            HapticFeedback.heavyImpact(); // ライトインパクトの振動フィードバック
          },
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
            NavigationDestination(
              icon: Icon(Icons.restaurant_outlined),
              label: '食堂',
            ),
          ],
        ));
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _initThemeMode();
  }

  void _initThemeMode() {
    _loadThemeMode().then((mode) {
      _themeMode = mode;
      notifyListeners();
    });
  }

  Future<ThemeMode> _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedThemeMode = prefs.getInt('themeMode') ?? 0;
    return ThemeMode.values[storedThemeMode];
  }

  Future<void> _saveThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', _themeMode.index);
  }

  void light() {
    _themeMode = ThemeMode.light;
    _saveThemeMode();
    notifyListeners();
  }

  void dark() {
    _themeMode = ThemeMode.dark;
    _saveThemeMode();
    notifyListeners();
  }

  void useSystemThemeMode() {
    _themeMode = ThemeMode.system;
    _saveThemeMode();
    notifyListeners();
  }
}

void backgroundCheck(SendPort message) {}
