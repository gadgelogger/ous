import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ous/domain/review_provider.dart';
import 'package:ous/gen/assets.gen.dart';
import 'package:ous/presentation/pages/review/detail_view.dart';

class ReviewSearchDelegate extends SearchDelegate<String> {
  final String gakubu;
  final String bumon;
  final String gakki;
  final String tanni;
  final String zyugyoukeisiki;
  final String syusseki;

  ReviewSearchDelegate({
    required this.gakubu,
    required this.bumon,
    required this.gakki,
    required this.tanni,
    required this.zyugyoukeisiki,
    required this.syusseki,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final reviewsAsync = ref.watch(
          reviewsProvider(
            (
              gakubu,
              bumon,
              gakki,
              tanni,
              zyugyoukeisiki,
              syusseki,
              query,
            ),
          ),
        );

        return reviewsAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
          data: (reviews) {
            if (reviews.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Image(
                        image: AssetImage(Assets.icon.found.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      '結果が見つかりませんでした\n別の条件で再度検索をしてみてください。',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ListTile(
                  title: Text(review.zyugyoumei ?? ''),
                  subtitle: Text(review.kousimei ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          review: review,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
