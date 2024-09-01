import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ous/env.dart';
import 'package:ous/gen/assets.gen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final inAppPurchaseManager =
    ChangeNotifierProvider((ref) => InAppPurchaseManager());

class IAPScreen extends ConsumerWidget {
  const IAPScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inAppPurchase = ref.watch(inAppPurchaseManager);

    return Scaffold(
      appBar: AppBar(
        title: const Text('開発者に飯を奢る'),
      ),
      body: inAppPurchase.offerings == null
          ? const Center(child: CircularProgressIndicator())
          : UpsellScreen(offerings: inAppPurchase.offerings!),
    );
  }
}

class UpsellScreen extends StatelessWidget {
  const UpsellScreen({Key? key, required this.offerings}) : super(key: key);

  final Offerings offerings;

  @override
  Widget build(BuildContext context) {
    final offering = offerings.current;
    if (offering != null) {
      final noAdsPackage = offering.getPackage('NoAds');
      if (noAdsPackage != null) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Consumer(
                  builder: (context, ref, _) {
                    final isAdFree = ref.watch(inAppPurchaseManager).isAdFree;
                    return Text(
                      isAdFree ? '飯あざっす！' : '広告は表示されています',
                      style: TextStyle(
                        color: isAdFree ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.sp,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image(
                    image: AssetImage(Assets.icon.lunch.path),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text('クッソウザいアプリ内の広告を抹消するで'),
                const SizedBox(height: 10),
                PurchaseButton(package: noAdsPackage, label: '広告を抹消!!!!'),
                const SizedBox(height: 30),
                const Text(
                  'すでに購入している人は下記のボタンをタップすると復元するで',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const RestoreButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }
    }
    return const Center(child: Text('Loading...'));
  }
}

class PurchaseButton extends ConsumerWidget {
  const PurchaseButton({Key? key, required this.package, required this.label})
      : super(key: key);

  final Package package;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inAppPurchase = ref.read(inAppPurchaseManager);

    return ElevatedButton(
      onPressed: () async {
        try {
          await inAppPurchase.makePurchase(package);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('さよなら！広告(一旦アプリを再起動してね）)')),
          );
        } on PlatformException catch (e) {
          final errorCode = PurchasesErrorHelper.getErrorCode(e);
          if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('やっぱやめるんやね')), // 修正
            );
          } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('購入が許可されていないっぽいで')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('購入に失敗したわ...残念')),
            );
          }
        }
      },
      child: SizedBox(
        width: 200,
        child:
            Center(child: Text('$label (${package.storeProduct.priceString})')),
      ),
    );
  }
}

class RestoreButton extends ConsumerStatefulWidget {
  const RestoreButton({Key? key}) : super(key: key);

  @override
  _RestoreButtonState createState() => _RestoreButtonState();
}

class _RestoreButtonState extends ConsumerState<RestoreButton> {
  bool _restoring = false;

  @override
  Widget build(BuildContext context) {
    final inAppPurchase = ref.read(inAppPurchaseManager);

    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _restoring = true;
        });

        try {
          await inAppPurchase.restorePurchase('NoAds');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('広告の非表示を復元したで。サヨナラ！広告')),
          );
        } on PlatformException catch (e) {
          final errorCode = PurchasesErrorHelper.getErrorCode(e);
          if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('やっぱやめるん？')),
            );
          } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('購入が許可されていないっぽいで')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('あれ？俺に飯奢ってないっぽい？')),
            );
          }
        } finally {
          setState(() {
            _restoring = false;
          });
        }
      },
      child: SizedBox(
        width: 200,
        child: Center(
          child: Text(_restoring ? '復元中' : '復元'),
        ),
      ),
    );
  }
}

class InAppPurchaseManager with ChangeNotifier {
  bool isSubscribed = false;
  bool _isAdFree = false; // 追加
  Offerings? offerings;
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool get isAdFree => _isAdFree; // 追加

  InAppPurchaseManager() {
    initInAppPurchase();
  }

  Future<void> initInAppPurchase() async {
    try {
      await Purchases.setDebugLogsEnabled(true);
      late PurchasesConfiguration configuration;

      if (Platform.isAndroid) {
        configuration = PurchasesConfiguration(Env.revenuecatAndroid);
      } else if (Platform.isIOS) {
        configuration = PurchasesConfiguration(Env.revenuecatIos);
      }
      await Purchases.configure(configuration);
      offerings = await Purchases.getOfferings();
      final result = await Purchases.logIn(auth.currentUser!.uid);

      await getPurchaserInfo(result.customerInfo);

      print("アクティブなアイテム ${result.customerInfo.entitlements.active.keys}");
      notifyListeners();
    } catch (e) {
      print("initInAppPurchase error caught! ${e.toString()}");
    }
  }

  Future<void> getPurchaserInfo(CustomerInfo customerInfo) async {
    try {
      isSubscribed = await updatePurchases(customerInfo, 'NoAds');
      _isAdFree = isSubscribed; // 追加
      notifyListeners();
    } on PlatformException catch (e) {
      print(
        "getPurchaserInfo error ${PurchasesErrorHelper.getErrorCode(e).toString()}",
      );
    }
  }

  Future<bool> updatePurchases(
    CustomerInfo purchaserInfo,
    String entitlement,
  ) async {
    var isPurchased = false;
    final entitlements = purchaserInfo.entitlements.all;
    if (entitlements.isEmpty) {
      isPurchased = false;
    }
    if (!entitlements.containsKey(entitlement)) {
      isPurchased = false;
    } else if (entitlements[entitlement]!.isActive) {
      isPurchased = true;
    } else {
      isPurchased = false;
    }
    return isPurchased;
  }

  Future<void> makePurchase(Package package) async {
    try {
      await Purchases.logIn(auth.currentUser!.uid);
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      await getPurchaserInfo(customerInfo);
    } on PlatformException catch (e) {
      print("purchase repo makePurchase error ${e.toString()}");
      rethrow; // 例外を再スローする
    }
  }

  Future<void> restorePurchase(String entitlement) async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      final isActive = await updatePurchases(customerInfo, entitlement);
      if (!isActive) {
        print("購入情報なし");
      } else {
        await getPurchaserInfo(customerInfo);
        print("$entitlement 購入情報あり　復元する");
      }
    } on PlatformException catch (e) {
      print("purchase repo restorePurchase error ${e.toString()}");
      rethrow; // 例外を再スローする
    }
  }
}
