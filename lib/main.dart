// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
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
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
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
      },
    );
  }
}
