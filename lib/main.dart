// Flutter imports:
// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ous/controller/firebase_provider.dart';
import 'package:ous/domain/share_preferences_instance.dart';
import 'package:ous/domain/theme_mode_provider.dart';
import 'package:ous/presentation/pages/account/login_screen.dart';
import 'package:ous/presentation/pages/main_screen.dart';

import 'infrastructure/config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesInstance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

ThemeData _buildTheme(Brightness brightness) {
  return ThemeData(
    colorSchemeSeed: Colors.lightGreen,
    useMaterial3: true,
    brightness: brightness,
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) => MaterialApp(
        theme: _buildTheme(Brightness.light),
        darkTheme: _buildTheme(Brightness.dark),
        themeMode: ref.watch(themeModeProvider),
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
