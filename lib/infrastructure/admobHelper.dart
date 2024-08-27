import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//プラットホームごとのテスト広告IDを取得するメソッド
String getTestAdBannerUnitId() {
  String testBannerUnitId = "";
  if (Platform.isAndroid) {
    // Android のとき
    testBannerUnitId = "ca-app-pub-3940256099942544/6300978111";
  } else if (Platform.isIOS) {
    // iOSのとき
    testBannerUnitId = "ca-app-pub-3940256099942544/2934735716";
  }
  return testBannerUnitId;
}

//プラットホームごとの広告IDを取得するメソッド
String getAdBannerUnitId() {
  String bannerUnitId = "";
  if (Platform.isAndroid) {
    // Android のとき
    bannerUnitId = "ca-app-pub-1882636743563952/1997920139";
  } else if (Platform.isIOS) {
    // iOSのとき
    bannerUnitId = "ca-app-pub-1882636743563952/9876410154";
  }
  return bannerUnitId;
}

class AdmobHelper {
  static int _navigationCount = 0;
  static InterstitialAd? _interstitialAd;
  static bool _isAdLoaded = false;

  static void initialization() {
    MobileAds.instance.initialize();
    createInterstitialAd();
  }

  static void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-1882636743563952/5831285568' // Androidの広告ID
          : 'ca-app-pub-1882636743563952/4895847539', // iOSの広告ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          debugPrint('Interstitial ad loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Interstitial ad failed to load: $error');
          _interstitialAd = null;
          _isAdLoaded = false;
        },
      ),
    );
  }

  static void showInterstitialAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      _isAdLoaded = false;
    } else {
      debugPrint('Interstitial ad is not yet loaded.');
    }
  }

  static void handleNavigation() {
    _navigationCount++;
    debugPrint('Navigation count: $_navigationCount'); // デバッグ用のログ
    if (_navigationCount >= Random().nextInt(20) + 1) {
      // 1-20回の間でランダムに広告を表示
      showInterstitialAd();
      _navigationCount = 0;
    }
  }

  // バナー広告を初期化する処理
  static BannerAd getBannerAd() {
    BannerAd bAd = BannerAd(
      adUnitId: getTestAdBannerUnitId(),
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => debugPrint('Ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('Ad failed to load: $error');
        },
        onAdClosed: (Ad ad) {
          debugPrint('ad dispose.');
          ad.dispose();
        },
      ),
    );
    return bAd;
  }

  // ラージサイズのバナー広告を初期化する処理
  static BannerAd getLargeBannerAd() {
    BannerAd bAd = BannerAd(
      adUnitId: getAdBannerUnitId(),
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => debugPrint('Ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('Ad failed to load: $error');
        },
        onAdClosed: (Ad ad) {
          debugPrint('ad dispose.');
          ad.dispose();
        },
      ),
    );
    return bAd;
  }
}
