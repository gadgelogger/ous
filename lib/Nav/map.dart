import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class Map extends StatelessWidget {
  const Map({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return MyHomePage(title: 'home');
                  }),
                );
              },
            ),
            elevation: 0,
            title: Text('学内マップ'),
            bottom: TabBar(
                labelColor: Colors.lightGreen,
                unselectedLabelColor: Colors.grey,
                isScrollable: true,
                indicatorColor: Colors.lightGreen,
                labelPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                tabs: [
                  Text(
                    '岡山キャンパス',
                    style: TextStyle(
                      fontSize: 15.0.sp,
                    ),
                  ),
                  Text(
                    '今治キャンパス',
                    style: TextStyle(
                      fontSize: 15.0.sp,
                    ),
                  ),
                ]),
          ),
          body: WillPopScope(
            onWillPop: () async => false,
            child: TabBarView(
              children: [
                okayama(),
                imabari(),
              ],
            ),
          ),
        ));
  }
}

class okayama extends StatelessWidget {
  const okayama({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: SfPdfViewer.network(
              'http://www1.ous.ac.jp/gakusyu/2017rikadaimap2.pdf')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Do something when FAB is pressed
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return okayama_aed();
            }),
          );
        },
        child: Icon(Icons.autorenew_outlined),
      ),
    );
  }
}

class imabari extends StatelessWidget {
  const imabari({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: SfPdfViewer.network(
              'https://www.ous.ac.jp/common/files//230/0405_imabari_map_omote_OL_fuchinashi.pdf')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Do something when FAB is pressed
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return imabari_aed();
            }),
          );
        },
        child: Icon(Icons.autorenew_outlined),
      ),
    );
  }
}

class okayama_aed extends StatelessWidget {
  const okayama_aed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('AED設置場所'),
      ),
      body: Container(
          child:
              SfPdfViewer.network('https://www.ous.ac.jp/common/files//7.pdf')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Do something when FAB is pressed
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return Map();
            }),
          );
        },
        child: Icon(Icons.autorenew_outlined),
      ),
    );
  }
}

class imabari_aed extends StatelessWidget {
  const imabari_aed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('AED設置場所'),
      ),
      body: Container(
          child: SfPdfViewer.network(
              'https://www.ous.ac.jp/common/files//13.pdf')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Do something when FAB is pressed
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return Map();
            }),
          );
        },
        child: Icon(Icons.autorenew_outlined),
      ),
    );
  }
}
