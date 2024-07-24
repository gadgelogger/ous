// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Project imports:
import 'package:ous/presentation/pages/home/home_screen.dart';
import 'package:ous/presentation/pages/info/info_screen.dart';
import 'package:ous/presentation/pages/review/review_screen.dart';

final baseTabViewProvider = StateProvider<ViewType>((ref) => ViewType.home);

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  final List<Widget> _widgets = const [
    Home(),
    Info(),
    ReviewTopScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(baseTabViewProvider);
    return Scaffold(
      body: Center(
        child: _widgets[viewState.index],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: viewState.index,
        onDestinationSelected: (int index) {
          HapticFeedback.mediumImpact();
          ref.read(baseTabViewProvider.notifier).state = ViewType.values[index];
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'ホーム',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            label: 'お知らせ',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            label: '講義評価',
          ),
        ],
      ),
    );
  }
}

enum ViewType { home, info, review }
