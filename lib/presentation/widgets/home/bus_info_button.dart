// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ous/domain/bus_service_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BusInfoButton extends ConsumerWidget {
  final String label;
  final String url;

  const BusInfoButton({
    Key? key,
    required this.label,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busInfoState = ref.watch(busServiceProvider);

    return SizedBox(
      width: 170.w,
      height: 70.h,
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => launchUrlString(url),
        child: busInfoState.when(
          data: (busInfo) {
            final info = busInfo[url] ?? '情報なし';
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  info,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const Text('エラー'),
        ),
      ),
    );
  }
}
