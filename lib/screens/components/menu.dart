import 'package:flutter/material.dart';
import 'package:tatuagem_front/screens/components/artist_menu.dart';
import 'package:tatuagem_front/screens/components/unlogged_menu.dart';
import 'package:tatuagem_front/screens/components/user_menu.dart';
import 'package:tatuagem_front/screens/components/user_or_artist.dart';
import 'package:tatuagem_front/screens/login.dart';

import '../../services/Api.dart';
import '../register.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: ApiService.isLogged(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao verificar login'));
        } else if (snapshot.hasData && snapshot.data == true) {
          return const UserOrArtist(
              user: UserMenu(),
              artist: ArtistMenu()
          );
        } else {
          return const UnloggedMenu();
        }
      },
    );
  }
}