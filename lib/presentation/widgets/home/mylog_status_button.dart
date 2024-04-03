// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Project imports:
import 'package:ous/infrastructure/mylog_monitor_api.dart';
import 'package:url_launcher/url_launcher_string.dart';

final myLogStatusProvider =
    StateNotifierProvider<MyLogStatusNotifier, AsyncValue<Map<String, String>>>(
        (ref) {
  return MyLogStatusNotifier()..fetchMyLogStatus();
});

class MyLogStatusButton extends ConsumerWidget {
  const MyLogStatusButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myLogStatusState = ref.watch(myLogStatusProvider);

    return SizedBox(
      width: 500.w,
      height: 200.h,
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () =>
            launchUrlString('https://stats.uptimerobot.com/4KzW2hJvY6'),
        child: myLogStatusState.when(
          data: (data) {
            final statusMessage = data['statusMessage'] ?? 'エラー';
            final formattedDate = data['formattedDate'] ?? '';
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  statusMessage.contains('正常') ? Icons.check : Icons.error,
                  size: 50,
                ),
                FittedBox(
                  child: Text(
                    statusMessage,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(formattedDate),
              ],
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const Text('エラー'),
        ),
      ),
    );
  }
}

class MyLogStatusNotifier
    extends StateNotifier<AsyncValue<Map<String, String>>> {
  MyLogStatusNotifier() : super(const AsyncValue.loading());

  Future<void> fetchMyLogStatus() async {
    state = const AsyncValue.loading();
    try {
      final data = await MylogMonitorApi().mylogMonitor();
      state = AsyncValue.data(data);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
