import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('このアプリを支援する'),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  'コーヒ一杯分\n開発のモチベが上がります。',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.sp),
                ),
                Container(
                    width: 200.w,
                    height: 200.h,
                    child: Image(
                      image: AssetImage('assets/icon/cofee.gif'),
                      fit: BoxFit.cover,
                    )),
                ElevatedButton(onPressed: () {}, child: Text('160円')),
                Text(
                  'ビール一杯分\n酔ってキマります',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.sp),
                ),
                Container(
                    width: 200.w,
                    height: 200.h,
                    child: Image(
                      image: AssetImage('assets/icon/drink.gif'),
                      fit: BoxFit.cover,
                    )),
                ElevatedButton(onPressed: () {}, child: Text('260円')),
                Text(
                  'ランチを奢る\nおいしい',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.sp),
                ),
                Container(
                    width: 200.w,
                    height: 200.h,
                    child: Image(
                      image: AssetImage('assets/icon/lunch.gif'),
                      fit: BoxFit.cover,
                    )),
                ElevatedButton(onPressed: () {}, child: Text('560円')),
              ],
            ),
          ),
        ));
  }
}
