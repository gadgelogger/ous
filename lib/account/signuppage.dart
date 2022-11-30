import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  String _newEmail = ""; // 入力されたメールアドレス
  String _newPassword = ""; // 入力されたパスワード
  String _infoText = ""; // 登録に関する情報を表示
  bool _pswd_OK = false; // パスワードが有効な文字数を満たしているかどうか

  // エラーメッセージを日本語化するためのクラス
  final auth_error = Authentication_error_to_ja();

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
                        color: Colors.green,
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
                              color: Colors.black,
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
