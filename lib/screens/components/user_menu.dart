import 'package:flutter/material.dart';
import 'package:tatuagem_front/screens/user/home.dart';
import 'package:tatuagem_front/screens/user/my_account.dart';

class UserMenu extends StatelessWidget {
  const UserMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage())
                )
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Minha conta"),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyAccount())
                )
              },
            ),
          ],
        )
    );
  }
}
