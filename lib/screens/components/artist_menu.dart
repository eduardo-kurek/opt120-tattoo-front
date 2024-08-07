import 'package:flutter/material.dart';
import 'package:tatuagem_front/screens/user/my_account.dart';

class ArtistMenu extends StatelessWidget {
  const ArtistMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
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
