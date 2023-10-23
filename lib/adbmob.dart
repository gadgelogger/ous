import 'dart:io';

import 'package:flutter/foundation.dart';

String getAdBannerUnitId() {
  String bannerUnitId = "";
  if (Platform.isAndroid) {
    // Android のとき
    bannerUnitId = kDebugMode
        ? "ca-app-pub-3940256099942544/6300978111" // Androidのデモ用バナー広告ID
        : "ca-app-pub-1882636743563952/3746871029";
  } else if (Platform.isIOS) {
    // iOSのとき
    bannerUnitId = kDebugMode
        ? "ca-app-pub-3940256099942544/2934735716" // iOSのデモ用バナー広告ID
        : "ca-app-pub-1882636743563952/8999197701";
  }
  return bannerUnitId;
}
