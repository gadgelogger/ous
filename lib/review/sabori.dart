// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sabori extends StatefulWidget {
  const Sabori({Key? key}) : super(key: key);

  @override
  State<Sabori> createState() => _SaboriState();
}

class _SaboriState extends State<Sabori> {
  final List<Map<String, dynamic>> _lectureList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サボリカウンター'),
      ),
      body: _lectureList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image(
                      image: AssetImage('assets/icon/found.gif'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'サボった講義がありません',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : GestureDetector(
              child: ListView.builder(
                itemCount: _lectureList.length,
                itemBuilder: (BuildContext context, int index) {
                  final lecture = _lectureList[index];
                  return Dismissible(
                    key: Key(lecture['name']),
                    onDismissed: (direction) {
                      setState(() {
                        _lectureList.removeAt(index);
                      });
                      _saveLectureList();
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        '${lecture['name']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: lecture['saveCount'] > 0
                          ? Text(
                              'あと${lecture['saveCount']}回サボれます。\nサボった回数は${lecture['exitCount']}回です。',
                            )
                          : const Text("もうサボれないよ！"),
                      trailing: Wrap(
                        spacing: 8, // アイコンの間の幅を調整
                        children: [
                          IconButton(
                            onPressed: () {
                              if (lecture['exitCount'] != null &&
                                  lecture['exitCount'] > 0) {
                                setState(() {
                                  lecture['saveCount']++;
                                  lecture['exitCount']--;
                                });
                                _saveLectureList();
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          IconButton(
                            onPressed: () {
                              if (lecture['saveCount'] != null &&
                                  lecture['saveCount'] > 0) {
                                setState(() {
                                  lecture['saveCount']--;
                                  lecture['exitCount']++;
                                });
                                _saveLectureList();
                              }
                            },
                            icon: const Icon(Icons.directions_run_outlined),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLectureDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadLectureList();
  }

  Future<void> _loadLectureList() async {
    final prefs = await SharedPreferences.getInstance();
    final lectureListJson = prefs.getString('lectureList');
    if (lectureListJson != null) {
      final lectureList =
          List<Map<String, dynamic>>.from(jsonDecode(lectureListJson));
      setState(() {
        _lectureList.addAll(lectureList);
      });
    }
  }

  Future<void> _saveLectureList() async {
    final prefs = await SharedPreferences.getInstance();
    final lectureListJson = jsonEncode(_lectureList);
    await prefs.setString('lectureList', lectureListJson);
  }

  void _showAddLectureDialog() {
    final TextEditingController kougiName = TextEditingController();
    int kougiCount = 16;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('講義を追加'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: '講義名',
                ),
                onChanged: (value) {
                  setState(() {
                    kougiName.text = value;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('講義回数を選択'),
              ),
              DropdownButton<int>(
                value: kougiCount,
                items: const [
                  DropdownMenuItem(
                    value: 16,
                    child: Text('16回'),
                  ),
                  DropdownMenuItem(
                    value: 15,
                    child: Text('15回'),
                  ),
                  DropdownMenuItem(
                    value: 8,
                    child: Text('8回'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    kougiCount = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: kougiName.text.isEmpty
                  ? null
                  : () {
                      final name = kougiName.text;
                      final count = kougiCount;
                      var saveCount = 0;
                      const exitCount = 0;

                      if (count == 16) {
                        saveCount = 4;
                      } else if (count == 15) {
                        saveCount = 3;
                      } else if (count == 8) {
                        saveCount = 2;
                      }

                      setState(() {
                        _lectureList.add({
                          'name': name, //講義名
                          'count': count, //講義の回数
                          'saveCount': saveCount, //サボれる回数
                          'exitCount': exitCount, //サボった回数
                        });
                      });
                      _saveLectureList();
                      Navigator.pop(context);
                    },
              child: const Text('追加'),
            ),
          ],
        );
      },
    );
  }
}
