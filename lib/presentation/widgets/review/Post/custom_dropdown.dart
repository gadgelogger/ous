import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final List<MapEntry<String, String>> items;
  final String value;
  final void Function(String?)? onChanged;
  final String? errorText; // 追加

  const CustomDropdown({
    Key? key,
    required this.labelText,
    required this.items,
    required this.value,
    this.onChanged,
    this.errorText, // 追加
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          errorText: errorText, // 追加
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        value: value,
        items: items.map((MapEntry<String, String> item) {
          return DropdownMenuItem<String>(
            value: item.key,
            child: Text(item.value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
