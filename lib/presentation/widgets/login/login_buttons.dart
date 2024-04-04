// Flutter imports:
// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Project imports:
import 'package:ous/infrastructure/login_auth_service.dart';
import 'package:ous/presentation/pages/main_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppleSignInButton extends LoginButton {
  const AppleSignInButton({
    Key? key,
    required AuthService authService,
  }) : super(key: key, authService: authService);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: getButtonStyle(context),
      onPressed: () async {
        await showConfirmationDialog(context);
      },
      child: getButtonChild(context),
    );
  }

  @override
  Widget getButtonChild(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.apple,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        Text(
          'Appleでサインイン',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  ButtonStyle getButtonStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      side: BorderSide(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      ),
    );
  }

  @override
  String getFailureMessage(Exception e) {
    if (e is FirebaseAuthException) {
      return "Appleでのログインに失敗しました: ${e.message}";
    } else {
      return "Appleでのログインに失敗しました: $e";
    }
  }

  @override
  String getSuccessMessage() => "Appleでログインしました";

  @override
  Future<UserCredential?> signIn() => _authService.signInWithApple();
}

class ColorConstants {
  static const Color universityButtonTextColor =
      Color.fromARGB(255, 46, 96, 47);
}

class GoogleSignInButton extends LoginButton {
  const GoogleSignInButton({
    Key? key,
    required AuthService authService,
  }) : super(key: key, authService: authService);

  @override
  Widget getButtonChild(BuildContext context) {
    return const Text(
      '大学のアカウントでサインイン',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: ColorConstants.universityButtonTextColor,
      ),
    );
  }

  @override
  ButtonStyle getButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.lightGreen[300],
      fixedSize: const Size.fromWidth(double.maxFinite),
      shape: const StadiumBorder(),
    );
  }

  @override
  String getFailureMessage(Exception e) {
    if (e is FirebaseAuthException) {
      return "大学のアカウントでのログインに失敗しました: ${e.message}";
    } else {
      return "大学のアカウントでのログインに失敗しました: $e";
    }
  }

  @override
  String getSuccessMessage() => "大学のアカウントでログインしました";

  @override
  Future<UserCredential?> signIn() => _authService.signInWithGoogle();
}

class GuestSignInButton extends LoginButton {
  const GuestSignInButton({
    Key? key,
    required AuthService authService,
  }) : super(key: key, authService: authService);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: getButtonStyle(context),
      onPressed: () async {
        await showConfirmationDialog(context);
      },
      child: getButtonChild(context),
    );
  }

  @override
  Widget getButtonChild(BuildContext context) {
    return const Text(
      '会員登録せずに使う（ゲストモード）',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
    );
  }

  @override
  ButtonStyle getButtonStyle(BuildContext context) => const ButtonStyle();

  @override
  String getFailureMessage(Exception e) {
    if (e is FirebaseAuthException) {
      return "ゲストモードでのログインに失敗しました: ${e.message}";
    } else {
      return "ゲストモードでのログインに失敗しました: $e";
    }
  }

  @override
  String getSuccessMessage() => "ゲストモードでログインしました";

  @override
  Future<UserCredential?> signIn() => _authService.signInAnonymously();
}

abstract class LoginButton extends StatelessWidget {
  final AuthService _authService;

  const LoginButton({Key? key, required AuthService authService})
      : _authService = authService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: getButtonStyle(context),
      onPressed: () async {
        try {
          final userCredential = await signIn();
          if (userCredential != null && context.mounted) {
            onSignInSuccess(context);
          }
        } on Exception catch (e) {
          onSignInFailure(context, e);
        }
      },
      child: getButtonChild(context),
    );
  }

  Widget getButtonChild(BuildContext context);

  ButtonStyle getButtonStyle(BuildContext context);

  String getFailureMessage(Exception e);

  String getSuccessMessage();

  void onSignInFailure(BuildContext context, Exception e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(getFailureMessage(e))),
    );
  }

  void onSignInSuccess(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return MainScreen();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(getSuccessMessage())),
    );
  }

  Future<void> showConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '注意',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            '大学のアカウント以外でログインしようとしています。一部機能が使えなかったりするけど大丈夫そ？\n\n※ゲストモードだと30日後にアカウントが消えます。',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('やっぱやめる'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('はい大丈夫そ'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        final userCredential = await signIn();
        if (userCredential != null && context.mounted) {
          onSignInSuccess(context);
        }
      } on Exception catch (e) {
        onSignInFailure(context, e);
      }
    }
  }

  Future<UserCredential?> signIn();
}

class PrivacyPolicyButton extends StatelessWidget {
  const PrivacyPolicyButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchUrlString(
          'https://tan-q-bot-unofficial.com/terms_of_service/',
        );
      },
      child: const Text(
        '利用規約はこちら',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
