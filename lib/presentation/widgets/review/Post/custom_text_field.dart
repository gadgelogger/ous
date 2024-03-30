// Flutter imports:
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final int? maxLines;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.hintText,
    this.maxLines = 1,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      maxLines: maxLines,
    );
  }
}
