import 'package:flutter/material.dart';
import 'package:ous/home.dart';
import 'package:webview_flutter/webview_flutter.dart';
class policy extends StatelessWidget {
  const policy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.home),
        onPressed: (){
          Navigator.popUntil(context, (route) => route.isFirst);

        },
      ),
      title: Text('利用規約'),
    ),
    body: WebView(
        initialUrl: 'https://tan-q-bot-unofficial.com/terms_of_service/',
        javascriptMode: JavascriptMode.unrestricted
    ),  );
}
