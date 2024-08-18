import 'package:tatuagem_front/services/Api.dart';

import '../Models/Tattoo.dart';

class TattooDAO{

  static Future<List<Tattoo>> getAllByArtist(String artistId) async{
    /* final data = ApiService.get('') TODO */
    final tattoo1 = Tattoo(imagem: "tattoo1", preco: 100.00);
    final tattoo2 = Tattoo(imagem: "tattoo2", preco: 50.00);
    List<Tattoo> list = [tattoo1, tattoo2];
    return list;
  }

  static Future<void> create(Tattoo tattoo) async{
    /* TODO */
  }

  static Future<void> update(Tattoo tattoo) async{
    /* TODO */
  }

  static Future<void> delete(Tattoo tattoo) async{
    /* TODO */
  }
  
}