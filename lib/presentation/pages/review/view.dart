// ... import statements ...

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// Project imports:
import 'package:ous/domain/review_provider.dart';
import 'package:ous/gen/assets.gen.dart';
import 'package:ous/presentation/pages/review/detail_view.dart';
import 'package:ous/presentation/widgets/review/filter_modal.dart';
import 'package:ous/presentation/widgets/review/review_card.dart';
import 'package:ous/presentation/widgets/review/review_search_delegate.dart';

class ReviewView extends ConsumerStatefulWidget {
  final String gakubu;
  final String title;

  const ReviewView({Key? key, required this.gakubu, required this.title})
      : super(key: key);

  @override
  ConsumerState<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends ConsumerState<ReviewView> {
  String _selectedBumon = '';
  String _selectedGakki = '';
  String _selectedTanni = '';
  String _selectedZyugyoukeisiki = '';
  String _selectedSyusseki = '';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(
      reviewsProvider(
        (
          widget.gakubu,
          _selectedBumon,
          _selectedGakki,
          _selectedTanni,
          _selectedZyugyoukeisiki,
          _selectedSyusseki,
          _searchQuery,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: ReviewSearchDelegate(
                  gakubu: widget.gakubu,
                  bumon: _selectedBumon,
                  gakki: _selectedGakki,
                  tanni: _selectedTanni,
                  zyugyoukeisiki: _selectedZyugyoukeisiki,
                  syusseki: _selectedSyusseki,
                ),
              );
              if (result != null) {
                setState(() {
                  _searchQuery = result;
                });
              }
            },
          ),
        ],
      ),
      body: Center(
        child: reviewsAsync.when(
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
        onPressed: () => showFilterModal(
          context,
          _selectedBumon,
          _selectedGakki,
          _selectedTanni,
          _selectedZyugyoukeisiki,
          _selectedSyusseki,
          (value) => setState(() => _selectedBumon = value),
          (value) => setState(() => _selectedGakki = value),
          (value) => setState(() => _selectedTanni = value),
          (value) => setState(() => _selectedZyugyoukeisiki = value),
          (value) => setState(() => _selectedSyusseki = value),
        ),
        heroTag: 'filter',
        child: const Icon(Icons.filter_list),
      ),
    );
  }
}
