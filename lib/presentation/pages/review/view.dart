// ... import statements ...

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ous/domain/review_provider.dart';
import 'package:ous/gen/review_data.dart';
import 'package:ous/presentation/pages/review/detail_view.dart';
import 'package:ous/presentation/pages/review/post.dart';

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

class ReviewView extends ConsumerWidget {
  final String gakubu;
  final String title;

  const ReviewView({Key? key, required this.gakubu, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(reviewsProvider(gakubu));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: reviewsAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
          data: (reviews) {
            return Scrollbar(
              child: AnimationLimiter(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              //Detail画面に遷移
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    review: review,
                                  ),
                                ),
                              );
                            },
                            child: ReviewCard(review: review),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
