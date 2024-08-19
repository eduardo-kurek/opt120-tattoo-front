import 'package:tatuagem_front/services/Api.dart';

import '../Models/Tattoo.dart';
import '../utils/TokenProvider.dart';

class TattooDAO{

  TokenProvider tokenProvider;

  TattooDAO({
   required this.tokenProvider
  });

  Future<List<Tattoo>> getAllByArtist(String artistId) async{
    final decodedToken = tokenProvider.decodedToken;
    final String id = decodedToken['id'];

    final List<Map<String, dynamic>> data = await ApiService.getAll(
      'api/tatuagens',
      headers: {
        'Authorization': 'Bearer ${await tokenProvider.token}'
      },
    );

    final List<Tattoo> tattoos = data.map((map) => Tattoo.fromJson(map)).toList();
    return tattoos;
  }

  Future<void> create(Tattoo tattoo) async{
    /* TODO */
  }

  Future<void> update(Tattoo tattoo) async{
    /* TODO */
  }

  static Future<void> delete(Tattoo tattoo) async{
    /* TODO */
  }
  
}