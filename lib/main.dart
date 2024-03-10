// Dart imports:
import 'package:firebase_core/firebase_core.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ous/analytics_service.dart';
import 'package:ous/screens/splash_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> initApp() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AnalyticsService().logBeginCheckout();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  }
}
