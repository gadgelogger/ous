// Flutter imports:
import 'package:flutter/material.dart';

void showFilterModal(
  BuildContext context,
  String selectedBumon,
  String selectedGakki,
  String selectedTanni,
  String selectedZyugyoukeisiki,
  String selectedSyusseki,
  void Function(String) setSelectedBumon,
  void Function(String) setSelectedGakki,
  void Function(String) setSelectedTanni,
  void Function(String) setSelectedZyugyoukeisiki,
  void Function(String) setSelectedSyusseki,
) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '絞り込み条件',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedBumon,
                  items: const [
                    DropdownMenuItem(value: '', child: Text('カテゴリー')),
                    DropdownMenuItem(value: 'ラク単', child: Text('ラク単')),
                    DropdownMenuItem(value: 'エグ単', child: Text('エグ単')),
                    DropdownMenuItem(value: '普通', child: Text('普通')),
                  ],
                  onChanged: (value) {
                    setModalState(() {
                      setSelectedBumon(value!);
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGakki,
                  items: const [
                    DropdownMenuItem(value: '', child: Text('開講学期')),
                    DropdownMenuItem(value: '春１', child: Text('春１')),
                    DropdownMenuItem(value: '春２', child: Text('春２')),
                    DropdownMenuItem(value: '秋１', child: Text('秋１')),
                    DropdownMenuItem(value: '秋２', child: Text('秋２')),
                    DropdownMenuItem(value: '春１と２', child: Text('春１と２')),
                    DropdownMenuItem(value: '秋１と２', child: Text('秋１と２')),
                  ],
                  onChanged: (value) {
                    setModalState(() {
                      setSelectedGakki(value!);
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedTanni,
                  items: const [
                    DropdownMenuItem(value: '', child: Text('単位数')),
                    DropdownMenuItem(value: '1', child: Text('1')),
                    DropdownMenuItem(value: '2', child: Text('2')),
                    DropdownMenuItem(value: '3', child: Text('3')),
                  ],
                  onChanged: (value) {
                    setModalState(() {
                      setSelectedTanni(value!);
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedZyugyoukeisiki,
                  items: const [
                    DropdownMenuItem(value: '', child: Text('授業形式')),
                    DropdownMenuItem(
                      value: 'オンライン(VOD)',
                      child: Text('オンライン(VOD)'),
                    ),
                    DropdownMenuItem(
                      value: 'オンライン(リアルタイム）',
                      child: Text('オンライン(リアルタイム）'),
                    ),
                    DropdownMenuItem(value: '対面', child: Text('対面')),
                    DropdownMenuItem(
                      value: '対面とオンライン',
                      child: Text('対面とオンライン'),
                    ),
                  ],
                  onChanged: (value) {
                    setModalState(() {
                      setSelectedZyugyoukeisiki(value!);
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedSyusseki,
                  items: const [
                    DropdownMenuItem(value: '', child: Text('出席確認の有無')),
                    DropdownMenuItem(
                      value: '毎日出席を取る',
                      child: Text('毎日出席を取る'),
                    ),
                    DropdownMenuItem(
                      value: 'ほぼ出席を取る',
                      child: Text('ほぼ出席を取る'),
                    ),
                    DropdownMenuItem(
                      value: 'たまに出席を取る',
                      child: Text('たまに出席を取る'),
                    ),
                    DropdownMenuItem(
                      value: '出席確認はなし',
                      child: Text('出席確認はなし'),
                    ),
                  ],
                  onChanged: (value) {
                    setModalState(() {
                      setSelectedSyusseki(value!);
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    },
  );
}
