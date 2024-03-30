// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelloOus extends StatelessWidget {
  const HelloOus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(15),
            top: ScreenUtil().setWidth(110),
          ),
          child: Text(
            'Hello',
            style: TextStyle(
              fontSize: 80.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(13),
            top: ScreenUtil().setWidth(180),
          ),
          child: Text(
            'OUS',
            style: TextStyle(
              fontSize: 80.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
