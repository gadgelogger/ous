// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_analytics/firebase_analytics.dart';

enum AnalyticsServiceScreenName {
  home,
  info,
  review,
}

extension AnalyticsServiceScreenNameExtension on AnalyticsServiceScreenName {
  static final name2ja = {
    AnalyticsServiceScreenName.home: 'ホーム',
    AnalyticsServiceScreenName.info: 'お知らせ',
    AnalyticsServiceScreenName.review: 'レビュー',
  };

  String get ja => name2ja[this]!;
}

class AnalyticsService {
  final firebaseAnalyticsInstance = FirebaseAnalytics.instance;
  factory AnalyticsService() => _singleton;
  AnalyticsService._();
  static final _singleton = AnalyticsService._();

  Future<void> logBeginCheckout() async {
    firebaseAnalyticsInstance.logBeginCheckout();
  }

  Future<void> setCurrentScreen(AnalyticsServiceScreenName screenName) async {
    debugPrint('Analytics:setCurrentScreen:${screenName.ja}');
    await firebaseAnalyticsInstance.setCurrentScreen(screenName: screenName.ja);
  }
}
