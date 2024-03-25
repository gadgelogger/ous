// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Project imports:
import 'package:ous/presentation/pages/home/home_screen.dart';
import 'package:ous/presentation/pages/info/info.dart';
import 'package:ous/presentation/pages/review/review_screen.dart';

final baseTabViewProvider = StateProvider<ViewType>((ref) => ViewType.home);

class MainScreen extends ConsumerWidget {
  final widgets = [
    const Home(),
    const Info(),
    const Review(),
  ];
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(baseTabViewProvider);
    return Scaffold(
      body: Center(
        child: widgets[viewState.index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: viewState.index,
        onTap: (int index) {
          ref.read(baseTabViewProvider.notifier).state = ViewType.values[index];
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'お知らせ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: '講義評価',
          ),
        ],
      ),
    );
  }
}

enum ViewType { home, info, review }
