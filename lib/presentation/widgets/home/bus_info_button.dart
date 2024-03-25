// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Project imports:
import 'package:ous/infrastructure/bus_api.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BusInfoButton extends StatelessWidget {
  final String label;
  final String url;

  const BusInfoButton({
    Key? key,
    required this.label,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final busService = BusService();

    return SizedBox(
      width: 164.w, //横幅
      height: 50.h, //高さ
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => launchUrlString(url),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<String>(
              future: busService.fetchBusApproachCaption(url),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!);
                } else if (snapshot.hasError) {
                  return const Text("エラー");
                }
                return const LinearProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
