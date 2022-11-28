import 'package:flutter/material.dart';

class game extends StatefulWidget {
  const game({Key? key}) : super(key: key);

  @override
  State<game> createState() => _gameState();
}

class _gameState extends State<game> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      elevation: 0,
      title: Text('？？？？'),
    ),
    body: Center(child: Text('game',style: TextStyle(fontSize: 60),),),
  );
}
