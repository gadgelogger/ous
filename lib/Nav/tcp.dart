import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Tcp extends StatefulWidget {
  const Tcp({Key? key}) : super(key: key);

  @override
  State<Tcp> createState() => _TcpState();
}

class _TcpState extends State<Tcp> {
  bool _isLoading = true;
  late CookieManager cookieManager; // CookieManagerを宣言

  @override
  void initState() {
    super.initState();
    cookieManager = CookieManager.instance(); // インスタンスを生成
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TCP')),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse('https://app.tcpapp.net/tcpapp/login.html')),
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false;
              });

              // クッキーを取得（オプション）
              var cookies = await cookieManager.getCookies(
                  url: Uri.parse("https://app.tcpapp.net"));
              print("Cookies: $cookies");
            },
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
