// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Project imports:
import 'package:ous/domain/user_providers.dart';
import 'package:ous/gen/assets.gen.dart';
import 'package:ous/presentation/pages/account/account_screen_edit.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsyncValue = ref.watch(userStreamProvider);
    return userDataAsyncValue.when(
      data: (userData) => Scaffold(
        appBar: AppBar(
          title: const Text('マイページ'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 100,
                backgroundImage: userData?.photoURL != ''
                    ? NetworkImage(userData?.photoURL ?? '')
                    : null,
                child: userData?.photoURL == ''
                    ? const Icon(Icons.person, size: 100)
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                userData?.displayName ?? 'Null',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => MyPageEdit(),
                    ),
                  );
                },
                child: const Text(
                  '編集',
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.icon.error.path,
              width: 150.0,
            ),
            Text('エラー: $error'),
          ],
        ),
      ),
    );
  }
}
