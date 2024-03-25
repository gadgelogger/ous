import 'package:flutter/material.dart';

class ColorConstants {
  static Color getLoginAppleButtonColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black;
  static Color getLoginTextLabelColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black;
}
