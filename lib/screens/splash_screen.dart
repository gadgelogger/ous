import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ous/account/login.dart';
import 'package:ous/api/service/remote_config_service.dart';
import 'package:ous/screens/main_screen.dart';
import 'package:ous/screens/maintenance_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final RemoteConfigService _remoteConfigService = RemoteConfigService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _remoteConfigService.checkMaintenance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == true) {
          return const MaintenanceScreen();
        } else {
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (authSnapshot.hasData) {
                return MainScreen();
              } else {
                return const Login();
              }
            },
          );
        }
      },
    );
  }
}
