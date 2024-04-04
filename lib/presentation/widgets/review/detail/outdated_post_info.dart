import 'package:flutter/material.dart';
import 'package:ous/gen/review_data.dart';

class OutdatedPostInfo extends StatelessWidget {
  final Review review;

  const OutdatedPostInfo({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final postDate = review.date;
    final currentDate = DateTime.now();
    final difference = currentDate.difference(postDate!);
    final years = difference.inDays ~/ 365;

    if (years >= 1) {
      return Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.info_outline),
              Text(
                'この投稿は投稿日から$years年以上経過しています。\n情報が古い可能性があります。',
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
