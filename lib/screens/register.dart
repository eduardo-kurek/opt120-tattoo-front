import 'package:flutter/material.dart';

import 'components/menu.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Menu(),
      appBar: AppBar(
        title: const Text("Cadastrar"),
      ),
      body: Container(
        color: Colors.black87,
        child: const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Text("OLÁ MUNDO"),
            ),
          )
        ),
      )
    );
  }
}
