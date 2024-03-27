// ... import statements ...

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ous/domain/review_provider.dart';
import 'package:ous/gen/assets.gen.dart';
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => _showFilterModal(context),
            heroTag: 'filter',
            child: const Icon(Icons.filter_list),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PostPage()),
              );
            },
            heroTag: 'add',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '絞り込み条件',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedBumon,
                    items: const [
                      DropdownMenuItem(value: '', child: Text('カテゴリー')),
                      DropdownMenuItem(value: 'ラク単', child: Text('ラク単')),
                      DropdownMenuItem(value: 'エグ単', child: Text('エグ単')),
                      DropdownMenuItem(value: '普通', child: Text('普通')),
                    ],
                    onChanged: (value) {
                      setModalState(() {
                        _selectedBumon = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedGakki,
                    items: const [
                      DropdownMenuItem(value: '', child: Text('開講学期')),
                      DropdownMenuItem(value: '春１', child: Text('春１')),
                      DropdownMenuItem(value: '春２', child: Text('春２')),
                      DropdownMenuItem(value: '秋１', child: Text('秋１')),
                      DropdownMenuItem(value: '秋２', child: Text('秋２')),
                      DropdownMenuItem(value: '春１と２', child: Text('春１と２')),
                      DropdownMenuItem(value: '秋１と２', child: Text('秋１と２')),
                    ],
                    onChanged: (value) {
                      setModalState(() {
                        _selectedGakki = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedTanni,
                    items: const [
                      DropdownMenuItem(value: '', child: Text('単位数')),
                      DropdownMenuItem(value: '1', child: Text('1')),
                      DropdownMenuItem(value: '2', child: Text('2')),
                    ],
                    onChanged: (value) {
                      setModalState(() {
                        _selectedTanni = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedZyugyoukeisiki,
                    items: const [
                      DropdownMenuItem(value: '', child: Text('授業形式')),
                      DropdownMenuItem(
                        value: 'オンライン(VOD)',
                        child: Text('オンライン(VOD)'),
                      ),
                      DropdownMenuItem(
                        value: 'オンライン(リアルタイム）',
                        child: Text('オンライン(リアルタイム）'),
                      ),
                      DropdownMenuItem(value: '対面', child: Text('対面')),
                      DropdownMenuItem(
                        value: '対面とオンライン',
                        child: Text('対面とオンライン'),
                      ),
                    ],
                    onChanged: (value) {
                      setModalState(() {
                        _selectedZyugyoukeisiki = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedSyusseki,
                    items: const [
                      DropdownMenuItem(value: '', child: Text('出席確認の有無')),
                      DropdownMenuItem(
                        value: '毎日出席を取る',
                        child: Text('毎日出席を取る'),
                      ),
                      DropdownMenuItem(
                        value: 'ほぼ出席を取る',
                        child: Text('ほぼ出席を取る'),
                      ),
                      DropdownMenuItem(
                        value: 'たまに出席を取る',
                        child: Text('たまに出席を取る'),
                      ),
                      DropdownMenuItem(
                        value: '出席確認はなし',
                        child: Text('出席確認はなし'),
                      ),
                    ],
                    onChanged: (value) {
                      setModalState(() {
                        _selectedSyusseki = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: const Text('適用'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
