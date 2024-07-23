import 'package:flutter/material.dart';

class CustomYearPicker extends StatelessWidget {
  final String labelText;
  final String value;
  final void Function(String)? onChanged;

  CustomYearPicker({
    Key? key,
    required this.labelText,
    String? value,
    this.onChanged,
  })  : value = value ?? DateTime.now().year.toString(), // 初期値を現在の年に設定
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
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
                  color: value.isNotEmpty
                      ? (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      : Colors.grey,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
