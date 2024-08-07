import 'package:flutter/material.dart';
import 'package:tatuagem_front/screens/components/authenticate.dart';
import 'package:tatuagem_front/screens/components/user_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticate(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        drawer: const UserMenu(),
        body: Container(
          color: Colors.black87,
          padding: const EdgeInsets.all(50),
          child: const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Conteudo aqui...")
                    ]
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }
}
