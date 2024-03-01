// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

class Gpa extends StatefulWidget {
  const Gpa({Key? key}) : super(key: key);

  @override
  State<Gpa> createState() => _GpaState();
}

class _GpaState extends State<Gpa> {
  final url = Uri.parse('https://www.ous.ac.jp/outline/disclosure/evaluation/');

  final TextEditingController _totalUnitController = TextEditingController();
  final TextEditingController _sUnitController = TextEditingController();
  final TextEditingController _aUnitController = TextEditingController();
  final TextEditingController _bUnitController = TextEditingController();
  final TextEditingController _cUnitController = TextEditingController();

  int _totalUnit = 0;
  int _sUnit = 0;
  int _aUnit = 0;
  int _bUnit = 0;
  int _cUnit = 0;
  @override
  Widget build(BuildContext context) {
    double gpa = calculateGPA();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GPA計算機'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: SfRadialGauge(
                      axes: [
                        RadialAxis(
                          minimum: 0.00,
                          maximum: 4.00,
                          ranges: [
                            GaugeRange(
                              //相談を要す
                              startValue: 0.00,
                              endValue: 0.99,
                              color: Colors.red,
                            ),
                            GaugeRange(
                              //やや問題あり
                              startValue: 0.99,
                              endValue: 1.49,
                              color: Colors.yellow,
                            ),
                            GaugeRange(
                              //普通
                              startValue: 1.49,
                              endValue: 1.99,
                              color: Colors.blue,
                            ),
                            GaugeRange(
                              //良好
                              startValue: 1.99,
                              endValue: 2.99,
                              color: Colors.green[200],
                            ),
                            GaugeRange(
                              //優秀
                              startValue: 2.99,
                              endValue: 4.00,
                              color: Colors.green,
                            ),
                          ],
                          pointers: [
                            NeedlePointer(
                              value: gpa,
                              enableAnimation: true,
                            ),
                          ],
                          annotations: [
                            GaugeAnnotation(
                              positionFactor: 0.5, // 中心に配置
                              angle: 90, // 90度の角度で配置
                              widget: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    gpa.toStringAsFixed(2), // 小数点以下2桁まで表示
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    evaluateGPA(gpa),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                TextField(
                  controller: _totalUnitController,
                  onChanged: (value) {
                    setState(() {
                      _totalUnit = int.tryParse(value) ?? 0;
                    });
                  },
                  enabled: true,
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: '総単位数を入力',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _sUnitController,
                  onChanged: (value) {
                    setState(() {
                      _sUnit = int.tryParse(value) ?? 0;
                    });
                  },
                  enabled: true,
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: 'Sの単位数を入力',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _aUnitController,
                  onChanged: (value) {
                    setState(() {
                      _aUnit = int.tryParse(value) ?? 0;
                    });
                  },
                  enabled: true,
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: 'Aの単位数を入力',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _bUnitController,
                  onChanged: (value) {
                    setState(() {
                      _bUnit = int.tryParse(value) ?? 0;
                    });
                  },
                  enabled: true,
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: 'Bの単位数を入力',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _cUnitController,
                  onChanged: (value) {
                    setState(() {
                      _cUnit = int.tryParse(value) ?? 0;
                    });
                  },
                  enabled: true,
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: 'Cの単位数を入力',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          launchUrl(url),
        },
        icon: const Icon(Icons.search),
        label: const Text("詳しい評価基準はこちら"),
      ),
    );
  }

  //GPA計算
  double calculateGPA() {
    if (_totalUnit == 0) return 0; // 0除算を避ける
    return (_sUnit * 4 + _aUnit * 3 + _bUnit * 2 + _cUnit * 1) / _totalUnit;
  }

  @override
  void dispose() {
    _totalUnitController.dispose();
    _sUnitController.dispose();
    _aUnitController.dispose();
    _bUnitController.dispose();
    _cUnitController.dispose();
    super.dispose();
  }

  //結果表示
  String evaluateGPA(double gpa) {
    if (gpa < 0.99) {
      return '相談を要す';
    } else if (gpa < 1.49) {
      return 'やや問題あり';
    } else if (gpa < 1.99) {
      return '普通';
    } else if (gpa < 2.99) {
      return '良好';
    } else {
      return '優秀';
    }
  }
}
