import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'email_check.dart';
import 'package:showcaseview/showcaseview.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  // Firebase Authenticationを利用するためのインスタンス
  final _auth = FirebaseAuth.instance;

  final String _username = "";
  String _newEmail = ""; // 入力されたメールアドレス
  String _newPassword = ""; // 入力されたパスワード
  String _infoText = ""; // 登録に関する情報を表示
  bool _pswd_OK = false; // パスワードが有効な文字数を満たしているかどうか
  bool _isChecked = false;

  // エラーメッセージを日本語化するためのクラス
  final auth_error = Authentication_error_to_ja();
  //スポット
  final GlobalKey spot = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
          builder: (context) => Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.fromLTRB(
                                15.0, 110.0, 0.0, 0.0),
                            child: const Text(
                              'Signup',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(
                                260.0, 125.0, 0.0, 0.0),
                            child: const Text(
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
                        padding: const EdgeInsets.only(
                            top: 35.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10.0),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'メールアドレス',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  // hintText: 'EMAIL',
                                  // hintStyle: ,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green))),
                              onChanged: (String value) {
                                setState(() {
                                  _newEmail = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10.0),
                            TextField(
                                decoration: const InputDecoration(
                                    labelText: 'パスワード（8～20文字）',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green))),
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
                            Showcase(
                              // このkeyは重複してはいけません
                              key: spot,
                              title: '利用規約に同意してね！',
                              description: '利用規約に同意してチェックマークを入れてください',
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0, color: Colors.transparent),
                                    ),
                                    child: Checkbox(
                                      value: _isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isChecked = value ?? false;
                                        });
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        launch(
                                            'https://tan-q-bot-unofficial.com/terms_of_service/');
                                      },
                                      child: const Text(
                                        '利用規約に同意した？',
                                        style: TextStyle(
                                            color: Colors.lightGreen,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline),
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(height: 50.0),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 0, 20.0, 5.0),
                                child: Text(
                                  _infoText,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _isChecked
                                  ? () async {
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text(
                                              "注意",
                                              textAlign: TextAlign.center,
                                            ),
                                            content: const Text(
                                              "大学のアカウント以外でログインしようとしています。\n講義評価など一部の機能が使えないですがよろしいですか？\n※新入生の人は大学のアカウントが発行されるまで待ってね。",
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: <Widget>[
                                              // ボタン領域
                                              TextButton(
                                                child: const Text("やっぱやめる"),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                              TextButton(
                                                  child: const Text("ええで"),
                                                  onPressed: () async {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "ログイン中です\nちょっと待ってね。");
                                                    if (_pswd_OK) {
                                                      try {
                                                        // メール/パスワードでユーザー登録
                                                        UserCredential result =
                                                            await _auth
                                                                .createUserWithEmailAndPassword(
                                                          email: _newEmail,
                                                          password:
                                                              _newPassword,
                                                        );

                                                        // 登録成功
                                                        User user = result
                                                            .user!; // 登録したユーザー情報
                                                        user.sendEmailVerification(); // Email確認のメールを送信
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Emailcheck(
                                                                      email:
                                                                          _newEmail,
                                                                      pswd:
                                                                          _newPassword,
                                                                      from: 1),
                                                            ));
                                                      } catch (e) {
                                                        // 登録に失敗した場合
                                                        setState(() {
                                                          _infoText = auth_error
                                                              .register_error_msg(
                                                                  e.hashCode,
                                                                  e.toString());
                                                        });
                                                      }
                                                    } else {
                                                      setState(() {
                                                        _infoText =
                                                            'パスワードは8文字以上です。';
                                                      });
                                                    }
                                                  }),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  : () {
                                      ShowCaseWidget.of(context)
                                          .startShowCase([spot]);
                                    },
                              child: SizedBox(
                                height: 40.0.h,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.lightGreen[200],
                                  child: Container(
                                      child: const Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Center(
                                        child: Text(
                                          'サインアップ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                      )
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                              },
                              child: SizedBox(
                                height: 40.0.h,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.lightGreen,
                                          style: BorderStyle.solid,
                                          width: 1.0.w),
                                      color: Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: const Center(
                                    child: Text(
                                      '戻る',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ]))),
    );
  }
}

// Firebase Authentication利用時の日本語エラーメッセージ
class Authentication_error_to_ja {
  // ログイン時の日本語エラーメッセージ
  login_error_msg(int errorCode, String orgErrorMsg) {
    String errorMsg;

    if (errorCode == 360587416) {
      errorMsg = '有効なメールアドレスを入力してください。';
    } else if (errorCode == 505284406) {
      // 入力されたメールアドレスが登録されていない場合
      errorMsg = 'メールアドレスかパスワードが間違っています。';
    } else if (errorCode == 185768934) {
      // 入力されたパスワードが間違っている場合
      errorMsg = 'メールアドレスかパスワードが間違っています。';
    } else if (errorCode == 447031946) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      errorMsg = 'メールアドレスとパスワードを入力してください。';
    } else {
      errorMsg = '$orgErrorMsg[$errorCode]';
    }

    return errorMsg;
  }

  // アカウント登録時の日本語エラーメッセージ
  register_error_msg(int errorCode, String orgErrorMsg) {
    String errorMsg;

    if (errorCode == 360587416) {
      errorMsg = '有効なメールアドレスを入力してください。';
    } else if (errorCode == 34618382) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      errorMsg = '既に登録済みのメールアドレスです。';
    } else if (errorCode == 447031946) {
      // メールアドレスかパスワードがEmpty or Nullの場合
      errorMsg = 'メールアドレスとパスワードを入力してください。';
    } else {
      errorMsg = '$orgErrorMsg[$errorCode]';
    }

    return errorMsg;
  }
}
