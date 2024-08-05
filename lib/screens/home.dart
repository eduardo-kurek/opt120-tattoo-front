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
      body: Container(
        color: Colors.black87,
        padding: const EdgeInsets.all(50),
        child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Conteudo aqui...")
                  ]
                ),
              ),
            )
        ),
      ),
    );
  }
}
