import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ous/info/info.dart';
import 'package:ous/setting/setting.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);
  return parse(document.body!.text).documentElement!.text;
}

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
  bool _isLoading = true;
  bool _isLoadingContent = false;

  List<String> _titles = [];
  List<dynamic> _items = [];

  @override
  void initState() {
    super.initState();
    checkLoginCredentials();
  }
//ログイン処理
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
  //ログイン処理ここまで

  //本文取得
  Future<String> tapListViewItem(WebViewController controller, int index) async {
    setState(() {
      _isLoadingContent = true;
    });

    String tabArea = _items[index]["tabArea"];
    int tabIndex = int.parse(tabArea.split(':')[2]);
    int itemId = index - (tabIndex - 1) * 20;

    String selector = "#funcForm\\\\:tabArea\\\\:${tabIndex}\\\\:j_idt366\\\\:${itemId}\\\\:j_idt372";
    print("Selected selector: " + selector);
    await controller.evaluateJavascript('''
    (function() {
      var element = document.querySelector('${selector}');
      if (element) {
        element.click();
      } else {
        console.log('Element not found');
      }
    })()
  ''');

    await Future.delayed(Duration(seconds: 3));

    String contentHtml = await controller.evaluateJavascript('''
    (function() {
      var element = document.querySelector(".fr-box.fr-view");
      return element.innerHTML;
    })()
  ''');

    await Future.delayed(Duration(seconds: 3), () async {
      await controller.evaluateJavascript('''
      (function() {
        document.querySelector("a.ui-dialog-titlebar-close").click();
      })()
    ''');
      setState(() {
        _isLoadingContent = false;
      });
    });

    return contentHtml;
  }


  //本文取得ここまで


  void showLoginDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ログイン変更", textAlign: TextAlign.center),
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
              child: Text("戻る"),
              onPressed: () {
               Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text("おけ"),
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
          var tabArea = "funcForm:tabArea:" + (1 + Math.floor(i / 20)).toString();

          items.push({
            "title": title,
            "date": dateText,
            "tabArea": tabArea
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



  void showContentDialog(String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("本文"),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: [
            ElevatedButton(
              child: Text("閉じる"),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showWebView
          ? Stack(
        children: [
          Column(
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

                        // 5秒待ってから、掲示板のボタンをクリック
                        Future.delayed(Duration(seconds: 5), () {
                          controller.evaluateJavascript('''
          document.getElementById("funcForm:j_idt361:j_idt368:j_idt369_content")
            .getElementsByTagName("a")[0]
            .click();
        ''');

                          // さらに5秒待ってから、"全表示" タブをクリック
                          Future.delayed(Duration(seconds: 5), () {
                            controller.evaluateJavascript('''
            document.querySelector('a[href="#funcForm:tabArea:1:j_idt215"]')
              .click();
          ''');

                            // さらに5秒待ってから、タイトルと日付を抽出
                            Future.delayed(Duration(seconds: 5), () {
                              extractTitlesAndDates(controller);
                            });

                          });
                        });
                      }
                    });
                  },

                ),
              ),
              Expanded(
                child: Center(
                  child: (_items == null || _items.length == 0)
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20), // 任意の間隔を追加
                      Text('読み込んでるで\nMylogの仕様上10秒くらいかかるわ\n寛大な気持ちで待っとき〜...',textAlign: TextAlign.center,),
                    ],
                  )
                      : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              _items[index]["title"],
                              style: TextStyle(fontSize: 15.sp),
                            ),
                            subtitle: Text(
                              _items[index]["date"],
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp),
                            ),
                            onTap: () async {
                              String content = await tapListViewItem(await _controller.future, index);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContentScreen(content: content, title: _items[index]["title"]),
                                ),
                              );
                            },


                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          if (_isLoadingContent) ...[
            Container(
              color: Colors.black.withOpacity(0.5),
              width: double.infinity,
              height: double.infinity,
            ),
            Center(child: CircularProgressIndicator())
          ],
        ],
      )
          : Center(child: CircularProgressIndicator()),


      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.settings_outlined),
        onPressed: () {
          showLoginDialog();
        },
      ),
    );
  }
}


//本文表示用のwidget
// 新しいウィジェットを作成
class ContentScreen extends StatelessWidget {
  final String content;
  final String title;

  ContentScreen({required this.content, required this.title});

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Html(
            data: content,
            onLinkTap: (String? url, _, Map<String, String> attributes, element) {
              if (url != null) {
                _launchURL(url);
              }
            },
          ),
        ),
      ),
    );
  }
}



