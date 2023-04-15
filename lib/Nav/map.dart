import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                isScrollable: true,
                indicatorColor: Theme.of(context).colorScheme.primary,
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
              physics: NeverScrollableScrollPhysics(),

              children: [
                okayama(),
                imabari(),
              ],
            ),
          ),
        ));
  }
}

class okayama extends StatefulWidget {
  const okayama({Key? key}) : super(key: key);

  @override
  State<okayama> createState() => _okayamaState();
}

class _okayamaState extends State<okayama> {

  Future<void> _openMaps() async {
    final availableMaps = await MapLauncher.installedMaps;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('起動するマップアプリ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: availableMaps
                  .map(
                    (map) => ListTile(

                  title: Text(map.mapName),
                  onTap: () {
                    map.showMarker(
                      coords: Coords(34.696149, 133.927399),
                      title: '岡山理科大学正門',
                      description: '正門',
                    );
                    Navigator.of(context).pop();
                  },
                ),
              )
                  .toList(),
            ),
          ),
        );
      },
    );
  }


  Future<void> _openMaps1() async {
    final availableMaps = await MapLauncher.installedMaps;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('起動するマップアプリ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: availableMaps
                  .map(
                    (map) => ListTile(
                  title: Text(map.mapName),
                  onTap: () {
                    map.showMarker(
                      coords: Coords(34.697074, 133.930168),
                      title: '岡山理科大学東門',
                      description: '東門',
                    );
                    Navigator.of(context).pop();
                  },
                ),
              )
                  .toList(),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: SfPdfViewer.network(
                'https://www.ous.ac.jp/common/files//229/ridaimapA3_omote(1).pdf')),
        floatingActionButton: Column(
          verticalDirection: VerticalDirection.up,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    // Do something when FAB is pressed
                    showModalBottomSheet(
                      //モーダルの背景の色、透過
                        backgroundColor: Colors.transparent,
                        //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                              margin: EdgeInsets.only(top: 450),
                              decoration: BoxDecoration(
                                //モーダル自体の色
                                color: Theme.of(context).brightness ==
                                    Brightness.light
                                    ? Colors.white
                                    : Color(0xFF424242),
                                //角丸にする
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(15),
                                child: (Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'キャンパスへのアクセス',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    LimitedBox(
                                      maxHeight: 200,
                                      child: ListView(
                                        children: [
                                          Card(
                                            child: ListTile(
                                              leading:
                                              Icon(Icons.door_sliding_outlined),
                                              trailing:
                                              Icon(Icons.chevron_right),
                                              title: Text('正門'),
                                              onTap: () {
                                                _openMaps();
                                              },
                                            ),
                                          ),
                                          Card(
                                            child: ListTile(
                                              leading: Icon(Icons.door_back_door_outlined),
                                              trailing:
                                              Icon(Icons.chevron_right),
                                              title: Text('東門'),
                                              onTap: () {
                                                _openMaps1();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Text(
                                      '自家用車で来られる方は\n東門からお入りください\n正門からはアクセスできません。',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                )),
                              ));
                        });
                  },
                  child: Icon(Icons.navigation_outlined),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: FloatingActionButton(
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
                )
              ],
            ),
          ],
        ));
  }

}


class imabari extends StatefulWidget {
  const imabari({Key? key}) : super(key: key);

  @override
  State<imabari> createState() => _imabariState();
}

class _imabariState extends State<imabari> {

  Future<void> _openMaps() async {
    final availableMaps = await MapLauncher.installedMaps;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('起動するマップアプリ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: availableMaps
                  .map(
                    (map) => ListTile(
                  title: Text(map.mapName),
                  onTap: () {
                    map.showMarker(
                      coords: Coords(34.07121945750315, 132.97883199999697),
                      title: '今治キャンパス',
                      description: '今治キャンパス',
                    );
                    Navigator.of(context).pop();
                  },
                ),
              )
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: SfPdfViewer.network(
              'https://www.ous.ac.jp/common/files//230/0405_imabari_map_omote_OL_fuchinashi.pdf')),
      floatingActionButton:  Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: [
              FloatingActionButton(
                onPressed: () {
                  // Do something when FAB is pressed
                  showModalBottomSheet(
                    //モーダルの背景の色、透過
                      backgroundColor: Colors.transparent,
                      //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                            margin: EdgeInsets.only(top: 450),
                            decoration: BoxDecoration(
                              //モーダル自体の色
                              color: Theme.of(context).brightness ==
                                  Brightness.light
                                  ? Colors.white
                                  : Color(0xFF424242),
                              //角丸にする
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(15),
                              child: (Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'キャンパスへのアクセス',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Center(
                                    child:    Card(
                                      child: ListTile(
                                        leading:
                                        Icon(Icons.school_outlined),
                                        trailing:
                                        Icon(Icons.chevron_right),
                                        title: Text('今治キャンパスに行く'),
                                        onTap: () {
                                          _openMaps();
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              )),
                            ));
                      });
                },
                child: Icon(Icons.navigation_outlined),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                child: FloatingActionButton(
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
              )
            ],
          ),
        ],
      )
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
