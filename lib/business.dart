import 'package:flutter/material.dart';
import 'package:ous/NavBar.dart';
class Business extends StatelessWidget {
  const Business({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: NavBar(),
    appBar: AppBar(
      title: Text('就活'),
    ),
    body: Center(child: Text('business',style: TextStyle(fontSize: 60),),),
  );
}
