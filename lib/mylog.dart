import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Mylog extends StatefulWidget {
  const Mylog({Key? key}) : super(key: key);

  @override
  State<Mylog> createState() => _MylogState();
}

class _MylogState extends State<Mylog> {
  String? _upText;
  final bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPanelData();
  }

  Future<void> fetchPanelData() async {
    const dashboardUid = 'c6b912ae-b50a-476e-94dd-f6a2ab6ec19f';
    const panelId = 4;
    const url =
        'https://grafana-mine-pop.ciphergrus.com/api/dashboards/uid/$dashboardUid';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    final panelData = data['dashboard']['panels']
        .firstWhere((panel) => panel['id'] == panelId)['gridPos'];
    print(panelData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mylog'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(_upText ?? 'No data'),
      ),
    );
  }
}
