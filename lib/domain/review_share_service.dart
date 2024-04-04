import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ous/gen/review_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class ShareService {
  static Future<void> shareReview(Review review, GlobalKey globalKey) async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 10.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/lecture_review.png').create();
    await file.writeAsBytes(pngBytes);

    final String shareText = '''
【講義評価を共有しました！】

カテゴリ: ${review.bumon}
講義名: ${review.zyugyoumei}
授業形式: ${review.zyugyoukeisiki}
単位数: ${review.tannisuu}

【アプリのインストールはこちら】
https://ous-unoffical-app.studio.site/

#岡理アプリ
  ''';

    await Share.shareFiles(
      [file.path],
      subject: '講義評価をシェアします',
      text: shareText,
    );
  }
}
