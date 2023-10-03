import 'package:flutter/material.dart';

class Sabori extends StatefulWidget {
  const Sabori({Key? key}) : super(key: key);

  @override
  State<Sabori> createState() => _SaboriState();
}

class _SaboriState extends State<Sabori> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サボリカウンター'),
      ),
      body: const Center(
        child: Text('サボリ'),
      ),
    );
  }
}
