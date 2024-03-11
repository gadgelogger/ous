// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Tcp extends StatefulWidget {
  const Tcp({Key? key}) : super(key: key);

  @override
  State<Tcp> createState() => _TcpState();
}

class _TcpState extends State<Tcp> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TCP')),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri('https://app.tcpapp.net/tcpapp/login.html'),
            ),
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false;
              });
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

  @override
  void initState() {
    super.initState();
  }
}
