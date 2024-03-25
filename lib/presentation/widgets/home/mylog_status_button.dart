// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Project imports:
import 'package:ous/infrastructure/mylog_monitor_api.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MyLogStatusButton extends StatefulWidget {
  const MyLogStatusButton({Key? key}) : super(key: key);

  @override
  State<MyLogStatusButton> createState() => _MyLogStatusButtonState();
}

class _MyLogStatusButtonState extends State<MyLogStatusButton> {
  bool isLoading = true;
  String statusMessage = "";
  String formattedDate = "";

  @override
  Widget build(BuildContext context) {
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
        child: isLoading
            ? const LinearProgressIndicator()
            : Column(
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
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadMyLogStatus();
  }

  Future<void> _loadMyLogStatus() async {
    try {
      var data = await MylogMonitorApi().mylogMonitor();
      if (mounted) {
        setState(() {
          statusMessage = data['statusMessage']!;
          formattedDate = data['formattedDate']!;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          statusMessage = "エラー";
          formattedDate = "";
          isLoading = false;
        });
      }
    }
  }
}
