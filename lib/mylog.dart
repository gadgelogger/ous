import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ous/setting/setting.dart';
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
  String userId = "i21i062yy";
  String password = "Tk5rduwn";

  bool showWebView = false;
  bool _isLoading = true;

  List<String> _titles = [];
  List<dynamic> _items = [];

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
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          title: Text("MyLogへログイン",textAlign: TextAlign.center,),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: "ID"),
                    onChanged: (value) {
                      userId = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "パスワード"),
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
              child: Text("back"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => Setting(),
                ));
              },
            ),
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

  void extractTitlesAndDates(WebViewController controller) {
    controller.evaluateJavascript('''
    (function() {
      var items = [];
      var titleElements = document.querySelectorAll("#funcForm\\\\:tabArea\\\\:1\\\\:allScr .alignRight a");
      var dateElements = document.querySelectorAll("#funcForm\\\\:tabArea\\\\:1\\\\:allScr .alignRight .keiji");

      for (var i = 0; i < titleElements.length; i++) {
        var title = titleElements[i].innerText;
        var dateText = dateElements[i].innerText.replace(title, '').trim();

        items.push({
          "title": title,
          "date": dateText
        });
      }

      return JSON.stringify(items);
    })()
  ''').then((String jsonString) {
      List<dynamic> items = jsonDecode(jsonString);
      setState(() {
        _items = items;
        print(_items);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyLog"),
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
          ? Column(
              children: [
                SizedBox(
                  height: 0,
                  width: 0,
                  child: WebView(
                    initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    onPageFinished: (String url) {
                      setState(() {
                        _isLoading = false;
                      });
                      _controller.future.then((controller) {
                        //ログイン処理
                        if (url.contains(
                            'https://mylog.pub.ous.ac.jp/uprx/up/xu/xub001/Xub00101.xhtml')) {
                          controller.evaluateJavascript('''
            document.getElementById("loginForm:userId").value = "$userId";
            document.getElementById("loginForm:password").value = "$password";
            document.getElementById("loginForm:loginButton").click();
          ''');
                        }
                        //掲示板のボタンを押す
                        if (url.contains(
                            'https://mylog.pub.ous.ac.jp/uprx/up/pk/pky001/Pky00101.xhtml')) {
                          controller.evaluateJavascript('''
            document.getElementById("funcForm:j_idt361:j_idt368:j_idt369_content")
              .getElementsByTagName("a")[0]
              .click();
          ''');

                          // 5秒待ってから、"全表示" タブをクリック
                          Future.delayed(Duration(seconds: 3), () {
                            controller.evaluateJavascript('''
              document.querySelector('a[href="#funcForm:tabArea:1:j_idt215"]')
                .click();
            ''');

                            // タイトルの抽出をさらに5秒後に実行
                            Future.delayed(Duration(seconds: 5), () {
                              extractTitlesAndDates(controller);
                            });
                          });
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: (_items == null || _items.length == 0)?
                    CircularProgressIndicator():
                    ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                        ListTile(
                        title: Text(_items[index]["title"],style: TextStyle(fontSize: 15.sp),),
                        subtitle: Text(_items[index]["date"],style: TextStyle(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold,fontSize: 15.sp),),
                       onTap: (){},
                        ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  )
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
