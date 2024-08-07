import 'package:flutter/cupertino.dart';

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
    return FutureBuilder<bool>(
      future: ApiService.isArtist(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return widget.artist;
        } else {
          return widget.user;
        }
      },
    );
  }
}
