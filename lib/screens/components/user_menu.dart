import 'package:flutter/material.dart';
import 'package:tatuagem_front/screens/user/home.dart';
import 'package:tatuagem_front/screens/user/my_account.dart';
import 'package:tatuagem_front/forms/tattoo_artist_form.dart';
import 'package:tatuagem_front/forms/my_account_form.dart';

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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()))
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("Minha conta"),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const MyAccountForm(); // Use o widget criado
              },
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.palette),
          title: const Text("Virar tatuador"),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const TattooArtistForm(); // Use o widget criado
              },
            );
          },
        ),
      ],
    ));
  }
}
