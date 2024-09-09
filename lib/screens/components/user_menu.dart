import 'package:flutter/material.dart';
import 'package:tatuagem_front/screens/user/become_artist.dart';
import 'package:tatuagem_front/screens/user/user_home.dart';
import 'package:tatuagem_front/screens/user/logout.dart';
import 'package:tatuagem_front/screens/user/my_account.dart';
import 'package:tatuagem_front/forms/tattoo_artist_form.dart';
import 'package:tatuagem_front/forms/my_account_form.dart';
import 'package:tatuagem_front/screens/user/new_scheduling.dart';

import '../user/change_password.dart';

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
                MaterialPageRoute(builder: (context) => const UserHome()))
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("Minha conta"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyAccount()));
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
          leading: const Icon(Icons.palette),
          title: const Text("Virar tatuador"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BecomeArtist()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.schedule),
          title: const Text("Novo agendamento"),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const NewScheduling(); // Use o widget criado
              },
            );
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
    ));
  }
}
