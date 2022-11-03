import 'package:flutter/material.dart';
class Business extends StatelessWidget {
  const Business({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      elevation: 0,
      title: Text('就活'),
    ),
    body: Center(child: Text('business',style: TextStyle(fontSize: 60),),),
  );
}
