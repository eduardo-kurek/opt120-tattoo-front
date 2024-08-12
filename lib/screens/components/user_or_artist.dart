import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/utils/TokenProvider.dart';

import '../../services/Api.dart';

class UserOrArtist extends StatefulWidget {
  final Widget user;
  final Widget artist;

  const UserOrArtist({
    super.key,
    required this.user,
    required this.artist
  });

  @override
  State<UserOrArtist> createState() => _UserOrArtistState();
}

class _UserOrArtistState extends State<UserOrArtist> {

  @override
  Widget build(BuildContext context) {
    final tokenProvider = Provider.of<TokenProvider>(context);

    if (tokenProvider.isArtist()) {
      return widget.artist;
    }

    return widget.user;
    
}
}
