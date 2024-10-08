import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ous/env.dart';
import 'package:ous/presentation/pages/setting/iap_screen.dart';

//プラットホームごとのテスト広告IDを取得するメソッド
String getTestAdBannerUnitId() {
  String testBannerUnitId = "";
  if (Platform.isAndroid) {
    // Android のとき
    testBannerUnitId = Env.testAdBannerIdAndroid;
  } else if (Platform.isIOS) {
    // iOSのとき
    testBannerUnitId = Env.testAdBannerIdIos;
  }
  return testBannerUnitId;
}

//プラットホームごとの広告IDを取得するメソッド
String getAdBannerUnitId() {
  String bannerUnitId = "";
  if (Platform.isAndroid) {
    // Android のとき
    bannerUnitId = Env.adBannerIdAndroid;
  } else if (Platform.isIOS) {
    // iOSのとき
    bannerUnitId = Env.adBannerIdIos;
  }
  return bannerUnitId;
}

String getReviewBottomBannerAdUnitId() {
  if (Platform.isAndroid) {
    return Env.adBannerReviewBottomIdAndroid; // Androidの広告ID
  } else if (Platform.isIOS) {
    return Env.adBannerReviewBottomIdIos; // iOSの広告ID
  }
  return "";
}

class AdmobHelper {
  static int _navigationCount = 0;
  static int _rewardNavigationCount = 0; // 追加
  static InterstitialAd? _interstitialAd;
  static RewardedInterstitialAd? _rewardedInterstitialAd; // 追加
  static bool _isAdLoaded = false;
  static bool _isRewardedAdLoaded = false; // 追加

  static void initialization() {
    MobileAds.instance.initialize();
    createInterstitialAd();
    createRewardedInterstitialAd(); // 追加
  }

  static void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? Env.adInterReviewIdAndroid // Androidの広告ID
          : Env.adInterReviewIdIos, // iOSの広告ID
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

  static void createRewardedInterstitialAd() {
    // 追加
    RewardedInterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? Env.adRewardInterReviewIdAndroid // Androidの広告ID
          : Env.adRewardInterReviewIdIos, // iOSの広告ID
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          _rewardedInterstitialAd = ad;
          _isRewardedAdLoaded = true;
          debugPrint('Rewarded interstitial ad loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Rewarded interstitial ad failed to load: $error');
          _rewardedInterstitialAd = null;
          _isRewardedAdLoaded = false;
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

  static BannerAd getReviewBottomBannerAd() {
    BannerAd bAd = BannerAd(
      adUnitId: getReviewBottomBannerAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => debugPrint('Bottom banner ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('Bottom banner ad failed to load: $error');
        },
        onAdClosed: (Ad ad) {
          debugPrint('Bottom banner ad disposed.');
          ad.dispose();
        },
      ),
    );
    return bAd;
  }

  static void showRewardedInterstitialAd() {
    // 追加
    if (_isRewardedAdLoaded && _rewardedInterstitialAd != null) {
      _rewardedInterstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
          ad.dispose();
          createRewardedInterstitialAd();
        },
        onAdFailedToShowFullScreenContent:
            (RewardedInterstitialAd ad, AdError error) {
          ad.dispose();
          createRewardedInterstitialAd();
        },
      );
      _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          debugPrint('User earned reward: ${reward.amount} ${reward.type}');
        },
      );
      _rewardedInterstitialAd = null;
      _isRewardedAdLoaded = false;
    } else {
      debugPrint('Rewarded interstitial ad is not yet loaded.');
    }
  }

  static void handleNavigation(WidgetRef ref) {
    // 修正: WidgetRefを引数に追加
    final isAdFree = ref.read(inAppPurchaseManager).isAdFree; // 追加
    if (isAdFree) return; // 追加: 広告が非表示の場合はカウントしない

    _navigationCount++;
    _rewardNavigationCount++; // 追加
    debugPrint('Navigation count: $_navigationCount'); // デバッグ用のログ
    debugPrint('Reward navigation count: $_rewardNavigationCount'); // デバッグ用のログ
    if (_navigationCount >= Random().nextInt(20) + 1) {
      // 1-20回の間でランダムに広告を表示
      showInterstitialAd();
      _navigationCount = 0;
    }
    if (_rewardNavigationCount >= Random().nextInt(30) + 1) {
      // 1-30回の間でランダムにリワード広告を表示
      showRewardedInterstitialAd();
      _rewardNavigationCount = 0;
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
