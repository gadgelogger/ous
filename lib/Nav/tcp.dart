import 'package:flutter/material.dart';
import 'package:ous/home.dart';
import 'package:ous/main.dart';
import 'package:webview_flutter/webview_flutter.dart';

class tcp extends StatelessWidget {
  const tcp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('TCP'),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return MyHomePage(title: 'home');
            }),          );
        },
      ),
    ),
    body: WebView(
      initialUrl: 'https://app.tcpapp.net/tcpapp/login.html',
        javascriptMode: JavascriptMode.unrestricted


    ),
  );
  }