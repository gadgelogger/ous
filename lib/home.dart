import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ous/test/debug.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx/webviewx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'NavBar.dart';


class home extends StatelessWidget {
  const home({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) =>
      Scaffold(
          drawer: NavBar(),
          appBar: AppBar(
            elevation: 0,
            title: Text('ホーム'),
          ),
          body: WillPopScope(
            onWillPop: () async => false,
            child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    width: 500.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:  Radius.circular(20)),
                      child: Image.asset(
                        Theme
                            .of(context)
                            .brightness == Brightness.dark
                            ? 'assets/images/homedark.jpeg'
                            : 'assets/images/home.jpg',
                      ),
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'バス運行情報',
                          style: TextStyle(
                            fontSize: 30.sp,
                          ),
                        )
                      ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonBar(
                            children: [
                              SizedBox(
                                width: 180.w, //横幅
                                height: 50.h, //高さ
                                child: ElevatedButton(
                                  child: const Text('岡山駅西口発',style: TextStyle(fontWeight: FontWeight.bold),),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    primary: Colors.lightGreen[200],
                                    onPrimary: Colors.green[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () =>
                                      launch(
                                          'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=224&stopCdTo=763&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0'),

                                ),
                              ),
                              SizedBox(
                                width: 180.w, //横幅
                                height: 50.h, //高さ
                                child: ElevatedButton(
                                  child: const Text('岡山理科大学\正門発',style: TextStyle(fontWeight: FontWeight.bold),),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    primary: Colors.lightGreen[200],
                                    onPrimary: Colors.green[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () =>
                                      launch(
                                          'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=763&stopCdTo=224&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0'),

                                ),
                              ),
                             ]
                        ),
                      ]),

                  GestureDetector(
                    onTap: () {

                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [


                          Text(
                            'マイログ稼働情報',
                            style: TextStyle(
                              fontSize: 30.sp,
                            ),
                          ),

                          ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:  Radius.circular(20)),
                              child:
                              WebViewAware(child:
                              GestureDetector(
                                onTap: (){
                                  launch(
                                      'https://loc.bus-vision.jp/ryobi/view/approach.html?stopCdFrom=763&stopCdTo=224&addSearchDetail=false&addSearchDetail=false&searchHour=null&searchMinute=null&searchAD=-1&searchVehicleTypeCd=null&searchCorpCd=null&lang=0');

                                },
                                child: WebViewX(width: 400.w, height: 400.h,
                                  initialContent: 'https://stats.uptimerobot.com/4KzW2hJvY6',
                                  initialSourceType: SourceType.url,
                                ),

                              ),
                              )
                          )
                        ]
                    ),
                  )
                ])
            ),
          ),
      );

}




