import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class Mylog extends StatefulWidget {
  @override
  State<Mylog> createState() => _MylogState();
}

class _MylogState extends State<Mylog> {
  String? _upText;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPanelData();
  }

  Future<void> fetchPanelData() async {
    final dashboardUid = 'c6b912ae-b50a-476e-94dd-f6a2ab6ec19f';
    final panelId = 4;
    final url =
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
        title: Text('Mylog'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(_upText ?? 'No data'),
      ),
    );
  }
}
