import 'package:flutter/material.dart';

import '../login.dart';
import '../register.dart';

class UnloggedMenu extends StatelessWidget {
  const UnloggedMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Cadastrar"),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Register())
                )
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text("Entrar"),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login())
                )
              },
            ),
          ],
        )
    );
  }
}
