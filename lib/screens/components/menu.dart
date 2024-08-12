import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/screens/components/artist_menu.dart';
import 'package:tatuagem_front/screens/components/unlogged_menu.dart';
import 'package:tatuagem_front/screens/components/user_menu.dart';
import 'package:tatuagem_front/screens/components/user_or_artist.dart';
import 'package:tatuagem_front/screens/login.dart';
import 'package:tatuagem_front/utils/TokenProvider.dart';

import '../../services/Api.dart';
import '../register.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenProvider = Provider.of<TokenProvider>(context);

    if (tokenProvider.isLogged()) {
      return const UserOrArtist(
          user: UserMenu(),
          artist: ArtistMenu()
      );
    }
    return const UnloggedMenu();
  }
}