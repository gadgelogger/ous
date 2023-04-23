import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewLogin extends StatefulWidget {
  @override
  _WebViewLoginState createState() => _WebViewLoginState();
}

class _WebViewLoginState extends State<WebViewLogin> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  String url = "https://mylog.pub.ous.ac.jp/uprx/up/xu/xub001/Xub00101.xhtml";
  String userId = "";
  String password = "";

  bool showWebView = false;

  @override
  void initState() {
    super.initState();
    checkLoginCredentials();
  }

  Future<void> checkLoginCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    password = prefs.getString('password') ?? '';

    if (userId.isEmpty || password.isEmpty) {
      showLoginDialog();
    } else {
      setState(() {
        showWebView = true;
      });
    }
  }

  Future<void> saveLoginCredentials(String userId, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
    prefs.setString('password', password);
  }

  void showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ログイン情報"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: "User ID"),
                    onChanged: (value) {
                      userId = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                saveLoginCredentials(userId, password);
                setState(() {
                  showWebView = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //掲示板


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView Login"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showLoginDialog();
            },
          ),
        ],
      ),
      body: showWebView
          ? WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onPageFinished: (String url) {
          _controller.future.then((controller) {
            controller.evaluateJavascript('''
                    document.getElementById("loginForm:userId").value = "$userId";
                    document.getElementById("loginForm:password").value = "$password";
                    document.getElementById("loginForm:loginButton").click();
                  ''');

            if (url.contains(
                'https://mylog.pub.ous.ac.jp/uprx/up/pk/pky001/Pky00101.xhtml')) {
              controller.evaluateJavascript('''
                      document.getElementById("funcForm:j_idt361:j_idt368:j_idt369_content")
                        .getElementsByTagName("a")[0]
                        .click();
                    ''');
            }
          });
        },
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}