// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  RegistrationState createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {
  // Firebase Authenticationを利用するためのインスタンス
  final _auth = FirebaseAuth.instance;

  String _newEmail = ""; // 入力されたメールアドレス
  String _newPassword = ""; // 入力されたパスワード
  String _infoText = ""; // 登録に関する情報を表示
  bool _pswdOK = false; // パスワードが有効な文字数を満たしているかどうか
  bool _isChecked = false;

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
                    Stack(
                      children: <Widget>[
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                          child: const Text(
                            'Signup',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(260.0, 125.0, 0.0, 0.0),
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
                                    _pswdOK = true;
                                  } else {
                                    _pswdOK = false;
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
                                        final url = Uri.parse(
                                            'https://tan-q-bot-unofficial.com/terms_of_service/');
                                        launchUrl(url);
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
                                                    if (_pswdOK) {
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
                                                      } catch (e) {
                                                        // 登録に失敗した場合
                                                        setState(() {
                                                          _infoText =
                                                              '登録に失敗しました。';
                                                        });
                                                      }
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
                                  ),
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
