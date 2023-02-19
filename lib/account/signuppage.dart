import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ous/main.dart';
import 'authentication_error.dart';
import 'email_check.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  // Firebase Authenticationを利用するためのインスタンス
  final _auth = FirebaseAuth.instance;

  //ユーザー情報保存
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> Register() {
    // 上で定義したメンバ変数を格納すると、usersコレクションに、
    // メールアドレスとパスワードも保存できる。
    return users
        .add({
      'email': _newEmail,
      'username': _username,
    })
        .then((value) => print("新規登録に成功"))
        .catchError((error) => print("新規登録に失敗しました!: $error"));
  }


  String _username = "";
  String _newEmail = ""; // 入力されたメールアドレス
  String _newPassword = ""; // 入力されたパスワード
  String _infoText = ""; // 登録に関する情報を表示
  bool _pswd_OK = false; // パスワードが有効な文字数を満たしているかどうか

  // エラーメッセージを日本語化するためのクラス
  final auth_error = Authentication_error_to_ja();



  //Appleサインイン

  // 公式のを参考に作ったユーザー登録の関数
  Future<UserCredential> signInWithApple() async {
    print('AppSignInを実行');

    final rawNonce = generateNonce();

    // 現在サインインしているAppleアカウントのクレデンシャルを要求する。
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(appleCredential);
    // Apple から返されたクレデンシャルから `OAuthCredential` を作成します。
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    print(appleCredential);
    // Firebaseでユーザーにサインインします。もし、先ほど生成したnonceが
    // が `appleCredential.identityToken` の nonce と一致しない場合、サインインに失敗します。
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  // 上のとほぼ一緒。登録とログインができる。
  Future<UserCredential> AppleSignIn() async {
    print('AppSignInを実行');
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(appleCredential);
    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    // ここに画面遷移をするコードを書く!
    Navigator.push(
        context,MaterialPageRoute(builder: (context) {
      return MyHomePage(title: 'home');
    }));
    print(appleCredential);
    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  //Appleサインイン



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Text(
                    'Signup',
                    style:
                        TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(260.0, 125.0, 0.0, 0.0),
                  child: Text(
                    '.',
                    style: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                )
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'ユーザー名（他ユーザーに表示されます）',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        // hintText: 'EMAIL',
                        // hintStyle: ,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    onChanged: (String value) {
                      setState(() {
                        _username = value;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'メールアドレス',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        // hintText: 'EMAIL',
                        // hintStyle: ,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    onChanged: (String value) {
                      setState(() {
                        _newEmail = value;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                      decoration: InputDecoration(
                          labelText: 'パスワード（8～20文字）',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      maxLength: 20, // 入力可能な文字数

                      obscureText: true,
                      onChanged: (String value) {
                        if (value.length >= 8) {
                          _newPassword = value;
                          _pswd_OK = true;
                        } else {
                          _pswd_OK = false;
                        }
                      }),
                  SizedBox(height: 50.0),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
                      child: Text(
                        _infoText,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.lightGreen,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () async {
                            if (_pswd_OK) {
                              try {
                                // メール/パスワードでユーザー登録
                                UserCredential _result =
                                    await _auth.createUserWithEmailAndPassword(
                                  email: _newEmail,
                                  password: _newPassword,
                                );

                                // 登録成功
                                User _user = _result.user!; // 登録したユーザー情報
                                _user.sendEmailVerification(); // Email確認のメールを送信
                                Register();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Emailcheck(
                                          email: _newEmail,
                                          pswd: _newPassword,
                                          from: 1),
                                    ));
                              } catch (e) {
                                // 登録に失敗した場合
                                setState(() {
                                  _infoText = auth_error.register_error_msg(
                                      e.hashCode, e.toString());
                                });
                              }
                            } else {
                              setState(() {
                                _infoText = 'パスワードは8文字以上です。';
                              });
                            }
                          },
                          child: Center(
                            child: Text(
                              'サインアップ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 20.0),

                  Container(
                    height: 40.0,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.lightGreen,
                              style: BorderStyle.solid,
                              width: 1.0),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Center(
                          child: Text('戻る',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat')),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ]));
  }
}



// Firebase Authentication利用時の日本語エラーメッセージ
class Authentication_error_to_ja {
  // ログイン時の日本語エラーメッセージ
  login_error_msg(int error_code, String org_error_msg) {
    String error_msg;

    if (error_code == 360587416) {
      error_msg = '有効なメールアドレスを入力してください。';
    } else if (error_code == 505284406) {
      // 入力されたメールアドレスが登録されていない場合
      error_msg = 'メールアドレスかパスワードが間違っています。';
    } else if (error_code == 185768934) {
      // 入力されたパスワードが間違っている場合
      error_msg = 'メールアドレスかパスワードが間違っています。';
    } else if (error_code == 447031946) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      error_msg = 'メールアドレスとパスワードを入力してください。';
    } else {
      error_msg = org_error_msg + '[' + error_code.toString() + ']';
    }

    return error_msg;
  }

  // アカウント登録時の日本語エラーメッセージ
  register_error_msg(int error_code, String org_error_msg) {
    String error_msg;

    if (error_code == 360587416) {
      error_msg = '有効なメールアドレスを入力してください。';
    } else if (error_code == 34618382) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      error_msg = '既に登録済みのメールアドレスです。';
    } else if (error_code == 447031946) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      error_msg = 'メールアドレスとパスワードを入力してください。';
    } else {
      error_msg = org_error_msg + '[' + error_code.toString() + ']';
    }

    return error_msg;
  }
}