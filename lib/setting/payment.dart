import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      Purchases.configure(
        PurchasesConfiguration("AndroidのAPIキー"),
      );
    } else if (Platform.isIOS) {
      Purchases.configure(
        PurchasesConfiguration("appl_tZiDnHFeVbFEFIKsERwLmhkLqQS"),
      );
    }
  }

  // 製品IDを引数に渡すことなく、定数を使用する
  Future<void> purchaseProduct(String productId) async {
    setState(() {
      _isLoading = true;
    });
    print('アプリストアから通信中');

    try {
      await Purchases.purchaseProduct(productId);
      // 購入が完了した場合の処理
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // エラー処理
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('このアプリを支援する'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 課金アイテムの表示
                    // ...
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
                    ElevatedButton(
                      onPressed: () {
                        purchaseProduct('com.ous.unoffical.app.payment.160');
                      },
                      child: Text(
                        '160円支援する',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Divider(),
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
                    ElevatedButton(
                      onPressed: () {
                        purchaseProduct('com.ous.unoffical.app.payment.260.2');
                      },
                      child: Text(
                        '260円支援する',
                        style: TextStyle(fontSize: 20),
                      ),),
                    Divider(),
                    Text(
                      'ランチを奢る\n美味しいヤミー❗️✨ ✨⚡️\n感謝❗️ ✨ ✨ 感謝❗️ ',
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
                    ElevatedButton(
                      onPressed: () {
                        purchaseProduct('com.ous.unoffical.app.payment.560');
                      },
                      child: Text(
                        '560円支援する',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(height: 20.h,),
                    Text('購入処理中',style: TextStyle(fontSize: 20.sp),)
                  ],
                )
            ),
        ],
      ),
    );
  }
}





