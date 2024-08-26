import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ous/infrastructure/admobHelper.dart';
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50, // バナー広告の高さを指定
            child: AdWidget(
              ad: AdmobHelper.getLargeBannerAd()..load(),
            ),
          ),
          NavigationBar(
            selectedIndex: viewState.index,
            onDestinationSelected: (int index) {
              HapticFeedback.mediumImpact();
              ref.read(baseTabViewProvider.notifier).state =
                  ViewType.values[index];
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
        ],
      ),
    );
  }
}

enum ViewType { home, info, review }
