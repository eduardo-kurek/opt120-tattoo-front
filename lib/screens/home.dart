import 'package:flutter/material.dart';
import 'package:tatuagem_front/screens/components/user_menu.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: const UserMenu(),
    );
  }
}
