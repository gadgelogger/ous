import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ous/Nav/call.dart';
import 'package:ous/NavBar.dart';
import 'package:ous/info/2.dart';
import 'package:ous/info/3.dart';
import 'package:ous/info/4.dart';
import 'package:ous/info/5.dart';
import 'package:ous/info/6.dart';
import 'package:ous/info/7.dart';
import 'package:ous/info/all.dart';
class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          elevation: 0,
          title: Text('News'),
          bottom: TabBar(
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelPadding: EdgeInsets.symmetric(horizontal:15,vertical: 12),

              tabs: [
            Text('全て',
              style: TextStyle(
                fontSize: 15.0.sp,
              ),
            ),

                Text('重要',
                  style: TextStyle(
                    fontSize: 15.0.sp,
                  ),
                ),
                Text('お知らせ',
                  style: TextStyle(
                    fontSize: 15.0.sp,
                  ),
                ),
                Text('学科レポート',
                  style: TextStyle(
                    fontSize: 15.0.sp,
                  ),
                ),
                Text('理大レポート',
                  style: TextStyle(
                    fontSize: 15.0.sp,
                  ),
                ),
                Text('キャリア支援センター',
                  style: TextStyle(
                    fontSize: 15.0.sp,
                  ),
                ),
                Text('おかりかチャンネル',
                  style: TextStyle(
                    fontSize: 15.0.sp,
                  ),
                ),




              ]),
        ),
        body: WillPopScope(
          onWillPop: ()async => false,
          child: TabBarView(
            children: [
              all(),
              important(),
              news(),
              Departmentreport(),
              report(),
              business(),
              movie(),
            ],
          ),
        ),
      ),
    );
  }
}