import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ous/domain/review_user_posts_provider.dart';
import 'package:ous/presentation/pages/review/edit_view.dart';

class UserPostsScreen extends ConsumerWidget {
  const UserPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewAsyncValue = ref.watch(fetchUserReviews);

    return Scaffold(
      appBar: AppBar(
        title: const Text('自分の投稿'),
      ),
      body: reviewAsyncValue.when(
        data: (userPosts) {
          if (userPosts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image(
                      image: AssetImage('assets/icon/found.gif'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    '投稿した講義がありません',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: userPosts.length,
            itemBuilder: (context, index) {
              final post = userPosts[index];
              return ListTile(
                title: Text(post.zyugyoumei ?? ''),
                subtitle: Text(post.kousimei ?? ''),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditScreen(
                        review: post,
                      ),
                    ),
                  );
                  // 投稿後にデータを再取得
                  ref.refresh(fetchUserReviews);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          debugPrint('エラーが発生しました: $error');
          debugPrint('スタックトレース: $stackTrace');
          return Center(child: Text('エラーが発生しました: $error'));
        },
      ),
    );
  }
}
