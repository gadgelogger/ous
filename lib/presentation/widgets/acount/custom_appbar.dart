import 'package:flutter/material.dart';

class AppBarPainter extends CustomPainter {
  final BuildContext context;

  AppBarPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_1 = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..style = PaintingStyle.fill;

    Path path_1 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * .08, 0.0)
      ..cubicTo(
        size.width * 0.04,
        0.0, //x1,y1
        0.0,
        0.04, //x2,y2
        0.0,
        0.1 * size.width, //x3,y3
      );

    Path path_2 = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * .92, 0.0)
      ..cubicTo(
        size.width * .96,
        0.0, //x1,y1
        size.width,
        0.96, //x2,y2
        size.width,
        0.1 * size.width, //x3,y3
      );

    Paint paint_2 = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    Path path_3 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path_1, paint_1);
    canvas.drawPath(path_2, paint_1);
    canvas.drawPath(path_3, paint_2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
