// Flutter imports:
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Project imports:
import 'package:ous/controller/firebase_provider.dart';
import 'package:ous/domain/bus_service_provider.dart';
import 'package:ous/domain/converters/date_time_timestamp_converter.dart';
import 'package:ous/domain/share_preferences_instance.dart';
import 'package:ous/domain/theme_mode_provider.dart';
import 'package:ous/infrastructure/admobHelper.dart';
import 'package:ous/presentation/pages/account/login_screen.dart';
import 'package:ous/presentation/pages/main_screen.dart';
import 'package:ous/presentation/widgets/home/mylog_status_button.dart';

import 'infrastructure/config/firebase_options.dart';

void main() async {
  // Flutterの初期化
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //Admobの初期化
  AdmobHelper.initialization();
  //トラッキングの初期化
  WidgetsBinding.instance.addPostFrameCallback((_) => initTracking());

  // SharedPreferencesの初期化
  await SharedPreferencesInstance.initialize();

  // Firebaseの初期化
  await initializeFirebase();

  // Firestoreの設定
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  // 画面の向きを縦固定に設定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ナビゲーションバーの背景色を透明に設定
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  // Providerの初期化
  final container = ProviderContainer();
  await container.read(busServiceProvider.notifier).fetchBusInfo();
  await container.read(myLogStatusProvider.notifier).fetchMyLogStatus();

  // スプラッシュスクリーンの削除
  FlutterNativeSplash.remove();

  // アプリの起動
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MainApp(),
    ),
  );
}

// Firebaseの初期化
Future<void> initializeFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

Future<void> initTracking() async {
  final status = await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status == TrackingStatus.notDetermined) {
    await Future.delayed(const Duration(milliseconds: 200));
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangeProvider);
    final theme = ref.watch(themeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) => MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ja'),
        ],
        theme: ThemeData(
          colorSchemeSeed: theme.primarySwatch,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: theme.primarySwatch,
          brightness: Brightness.dark,
        ),
        themeMode: theme.mode,
        home: authState.when(
          data: (user) {
            if (user == null) {
              return const Login();
            } else {
              return const MainScreen();
            }
          },
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stackTrace) => const Scaffold(
            body: Center(
              child: Text('Error'),
            ),
          ),
        ),
      ),
    );
  }
}
