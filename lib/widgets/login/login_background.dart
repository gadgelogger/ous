import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login_background.jpg'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
