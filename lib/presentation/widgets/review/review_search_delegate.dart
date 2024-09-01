import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ous/env.dart';
import 'package:ous/gen/assets.gen.dart';
import 'package:ous/gen/review_data.dart';
import 'package:ous/presentation/pages/review/detail_view.dart';

class ReviewSearchDelegate extends SearchDelegate<String> {
  final String gakubu;
  final String bumon;
  final String gakki;
  final String tanni;
  final String zyugyoukeisiki;
  final String syusseki;
  final String selectedDateOrder;

  final Algolia _algolia = Algolia.init(
    applicationId: Env.algoliaAppId, // AlgoliaのアプリケーションID
    apiKey: Env.algoliaApyKey, // Algoliaの検索専用APIキー
  );

  List<AlgoliaObjectSnapshot>? _cachedResults;

  ReviewSearchDelegate({
    required this.gakubu,
    required this.bumon,
    required this.gakki,
    required this.tanni,
    required this.zyugyoukeisiki,
    required this.syusseki,
    required this.selectedDateOrder,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _cachedResults = null; // クエリがクリアされた場合にキャッシュをリセット
          showSuggestions(context);
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
    if (_cachedResults != null && query.isNotEmpty) {
      return _buildResultList(context, _cachedResults!);
    }

    return FutureBuilder<AlgoliaQuerySnapshot>(
      future: _algolia.instance
          .index(gakubu) // gakubuの値をインデックス名として使用
          .query(query)
          .getObjects(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.hits.isEmpty) {
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
        } else {
          _cachedResults = snapshot.data!.hits;
          return _buildResultList(context, _cachedResults!);
        }
      },
    );
  }

  Widget _buildResultList(
    BuildContext context,
    List<AlgoliaObjectSnapshot> hits,
  ) {
    return ListView.builder(
      itemCount: hits.length,
      itemBuilder: (context, index) {
        final hit = hits[index];
        final zyugyoumei = hit.data['zyugyoumei'];
        final kousimei = hit.data['kousimei'];

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection(gakubu)
              .where('zyugyoumei', isEqualTo: zyugyoumei)
              .where('kousimei', isEqualTo: kousimei)
              .get()
              .then((snapshot) => snapshot.docs.first),
          builder: (context, detailSnapshot) {
            if (detailSnapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            } else if (detailSnapshot.hasError) {
              return ListTile(
                title: Text('Error: ${detailSnapshot.error}'),
              );
            } else if (!detailSnapshot.hasData) {
              return const ListTile(
                title: Text('No data found'),
              );
            } else {
              final review = Review.fromJson(
                detailSnapshot.data!.data() as Map<String, dynamic>,
              );
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
            }
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _cachedResults = null; // クエリが変更された場合にキャッシュをリセット
    return Container();
  }
}
