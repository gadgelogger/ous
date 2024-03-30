// Flutter imports:
import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final String labelText;
  final double value;
  final void Function(double)? onChanged;

  const CustomSlider({
    Key? key,
    required this.labelText,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
