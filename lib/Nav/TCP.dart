import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin_ios_android/flutter_webview_plugin_ios_android.dart';
class TCP extends StatefulWidget {
  @override
  _TCPState createState() => _TCPState();
}

class _TCPState extends State<TCP> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (state.url.contains('https://app.tcpapp.net/tcpapp/index.html')) {
        setState(() {
          // Save login status to SharedPreferences here.
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) =>Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('TCP'),
      ),
    body: WebviewScaffold(
      url: 'https://app.tcpapp.net/tcpapp/login.html',
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: Text('Loading...'),
        ),
      )
    ));
  }

