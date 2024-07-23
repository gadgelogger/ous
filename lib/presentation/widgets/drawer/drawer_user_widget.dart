// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Project imports:
import 'package:ous/domain/user_providers.dart';
import 'package:ous/gen/assets.gen.dart';
import 'package:ous/presentation/pages/account/account_screen.dart';

class DrawerUserHeader extends ConsumerWidget {
  const DrawerUserHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsyncValue = ref.watch(userStreamProvider);
    return userDataAsyncValue.when(
      data: (userData) => _UserAccountsDrawerHeader(
        displayName: userData?.displayName ?? 'Guest',
        email: userData?.email ?? 'guest@example.com',
        photoUrl: userData?.photoURL,
        onTap: () => _navigateToAccountScreen(context),
      ),
      loading: () => const _LoadingView(),
      error: (error, _) => _ErrorView(error: error.toString()),
    );
  }

  void _navigateToAccountScreen(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AccountScreen(),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;

  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.icon.error.path,
            width: 150.0,
          ),
          Text('エラーが発生しました: $error'),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: const Text('読み込み中'),
      accountEmail: const Text(
        '読み込み中',
        style: TextStyle(color: Colors.white),
      ),
      currentAccountPicture: const CircleAvatar(
        child: Icon(
          Icons.person,
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _UserAccountsDrawerHeader extends StatelessWidget {
  final String displayName;
  final String email;
  final String? photoUrl;
  final VoidCallback onTap;

  const _UserAccountsDrawerHeader({
    required this.displayName,
    required this.email,
    this.photoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: UserAccountsDrawerHeader(
        accountName: Text(displayName),
        accountEmail: Text(
          email,
          style: const TextStyle(color: Colors.white),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage: photoUrl != ''
              ? CachedNetworkImageProvider(photoUrl ?? '')
              : null,
          child: photoUrl == ''
              ? const Icon(
                  Icons.person,
                )
              : null,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
