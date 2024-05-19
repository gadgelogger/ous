// Flutter imports:
// Package imports:
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
import 'package:ous/domain/share_preferences_instance.dart';
import 'package:ous/domain/theme_mode_provider.dart';
import 'package:ous/presentation/pages/account/login_screen.dart';
import 'package:ous/presentation/pages/main_screen.dart';
import 'package:ous/presentation/widgets/home/mylog_status_button.dart';

import 'infrastructure/config/firebase_options.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesInstance.initialize();

  await initializeFirebase();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //ナビゲーションバーの背景色を透明にしてイケてるようにする
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  ).then((_) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  });

  final container = ProviderContainer();
  await container.read(busServiceProvider.notifier).fetchBusInfo();
  await container.read(myLogStatusProvider.notifier).fetchMyLogStatus();
  FlutterNativeSplash.remove();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MainApp(),
    ),
  );
}

Future<void> initializeFirebase() async {
  try {
    // Firebaseが初期化されているかどうかを確認
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    print('Error initializing Firebase: $e');
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
              return MainScreen();
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
