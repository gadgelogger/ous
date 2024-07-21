import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final int? maxLines;
  final TextEditingController controller;
  final String? errorText; // 追加

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.hintText,
    this.maxLines = 1,
    required this.controller,
    this.errorText, // 追加
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          errorText: errorText, // 追加
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        maxLines: maxLines,
      ),
    );
  }
}
