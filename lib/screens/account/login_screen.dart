// Dart imports:
import 'dart:io';

import 'package:flutter/foundation.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ous/api/service/login_auth_service.dart';
import 'package:ous/api/service/tutorial_service.dart';
import 'package:ous/widgets/login/login_background.dart';
import 'package:ous/widgets/login/login_buttons.dart';
import 'package:ous/widgets/login/login_logo.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            const LoginBackground(),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const HelloOus(),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 200,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        GoogleSignInButton(authService: _authService),
                        SizedBox(height: 20.h),
                        if (!kIsWeb && Platform.isIOS)
                          AppleSignInButton(authService: _authService),
                        SizedBox(height: 20.h),
                        GuestSignInButton(authService: _authService),
                        SizedBox(height: 20.h),
                        const PrivacyPolicyButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    TutorialService.showTutorialIfNeeded(context);
  }
}
