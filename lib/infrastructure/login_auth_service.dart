// Flutter imports:
// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 匿名ログイン
  Future<UserCredential?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      _updateUserProfile(userCredential.user);
      return userCredential;
    } catch (e) {
      return null;
    }
  }

// Appleログイン
  Future<UserCredential?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      if (appleCredential.identityToken == null) {
        throw Exception('Apple SignIn Aborted');
      }
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      final authResult = await _auth.signInWithCredential(oauthCredential);
      _updateUserProfile(authResult.user);
      return authResult;
    } catch (e) {
      return null;
    }
  }

  // Googleログイン
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(hostedDomain: 'ous.jp');
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google SignIn Aborted');
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final authResult = await _auth.signInWithCredential(credential);
      _updateUserProfile(authResult.user);
      return authResult;
    } catch (e) {
      return null;
    }
  }

  // ユーザープロファイルをFireStoreに保存
  void _updateUserProfile(User? user) {
    if (user != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      userRef.set(
        {
          'uid': user.uid,
          'email': user.email ?? '未設定',
          'displayName': user.displayName ?? '名前未設定',
          'photoURL': user.photoURL ?? '',
          'createdAt': DateTime.now(),
        },
        SetOptions(merge: true),
      );
    }
  }
}
