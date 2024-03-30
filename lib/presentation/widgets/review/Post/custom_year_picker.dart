// Flutter imports:
import 'package:flutter/material.dart';

class CustomYearPicker extends StatelessWidget {
  final String labelText;
  final String value;
  final void Function(String)? onChanged;

  const CustomYearPicker({
    Key? key,
    required this.labelText,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDatePickerMode: DatePickerMode.year,
        );
        if (picked != null && onChanged != null) {
          onChanged!(picked.year.toString());
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value.isNotEmpty ? value : '年度を選択',
              style: TextStyle(
                fontSize: 16,
                color: value.isNotEmpty ? Colors.black : Colors.grey,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
