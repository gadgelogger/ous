import 'package:flutter/material.dart';
import 'package:ous/gen/review_data.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 背景の明るさをチェック
    final isBackgroundBright = Theme.of(context).brightness == Brightness.light;

    // 明るい背景の場合は黒、暗い背景の場合は白
    final textColor = isBackgroundBright ? Colors.white : Colors.black;

    return SizedBox(
      width: 200,
      height: 30,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Align(
                alignment: const Alignment(-0.8, -0.5),
                child: Text(
                  review.zyugyoumei ?? '不明',
                  style: const TextStyle(fontSize: 20),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.8, 0.4),
              child: Text(
                review.gakki ?? '不明',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15,
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.8, 0.8),
              child: Text(
                review.kousimei ?? '不明',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 6,
                ),
                decoration: BoxDecoration(
                  color: review.bumon == 'エグ単'
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  review.bumon ?? '不明',
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
