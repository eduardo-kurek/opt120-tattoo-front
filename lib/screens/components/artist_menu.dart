import 'package:flutter/material.dart';
import 'package:tatuagem_front/screens/user/artist/artist_home.dart';
import 'package:tatuagem_front/screens/user/artist/my_tattoos.dart';
import 'package:tatuagem_front/screens/user/change_password.dart';
import 'package:tatuagem_front/screens/user/user_home.dart';
import 'package:tatuagem_front/screens/user/my_account.dart';

import '../user/logout.dart';

class ArtistMenu extends StatelessWidget {
  const ArtistMenu({super.key});

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
                    MaterialPageRoute(builder: (context) => const ArtistHome())
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
            ListTile(
              leading: const Icon(Icons.password),
              title: const Text("Alterar Senha"),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePassword())
                )
              },
            ),
            ListTile(
              leading: const Icon(Icons.art_track),
              title: const Text("Minhas Tattoos"),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyTattoos())
                )
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sair"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Logout()));
              },
            ),
          ],
        )
    );
  }
}
