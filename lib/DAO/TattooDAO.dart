import 'dart:io';

import 'package:tatuagem_front/services/Api.dart';

import '../Models/Tattoo.dart';
import '../utils/TokenProvider.dart';

class TattooDAO {
  TokenProvider tokenProvider;

  TattooDAO({required this.tokenProvider});

  Future<List<Tattoo>> getAll() async {
    final decodedToken = tokenProvider.decodedToken;

    final List<Map<String, dynamic>> data = await ApiService.getAll(
      'api/tatuagens',
      headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
    );

    final List<Tattoo> tattoos =
        data.map((map) => Tattoo.fromJson(map)).toList();
    return tattoos;
  }

  Future<List<Tattoo>> getAllByArtist(String url) async {
    final decodedToken = tokenProvider.decodedToken;
    final String artistId = decodedToken['tatuador']['id'];

    String finalUrl = url + '/' + artistId;

    final List<Map<String, dynamic>> data = await ApiService.getAll(
      finalUrl,
      headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
    );

    final List<Tattoo> tattoos = data.map((map) => Tattoo.fromJson(map)).toList();
    return tattoos;
  }

  Future<String> create(tattoo, userId) async {
    final token = await tokenProvider.token;
    final decodedToken = tokenProvider.decodedToken;
    final tatuadorId = decodedToken['tatuador']['id'];
    final response = await ApiService.post(
      'api/tatuagens', {
        'user_id': userId,
        'tatuador_id': tatuadorId,
        'estilo': tattoo.estilo,
        'preco': tattoo.preco,
        'imagem': tattoo.imagem,
      },
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (response['statusCode'] != 201) {
      return response['body']['message'];
    }
    return response['body'];
  }

  Future<void> update(tattoo, tattoId) async {
    final token = await tokenProvider.token;
    final response = await ApiService.patch(
      'api/tatuagens/$tattoId', {
        'estilo': tattoo.estilo,
        'preco': tattoo.preco,
        'imagem': tattoo.imagem,
      },
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    // if (response['statusCode'] != 201) {
    //   return response['body']['message'];
    // }
    // return response['body'];
  }

  Future<void> delete(String tattooId) async {
    final token = await tokenProvider.token;
    await ApiService.delete(
      'api/tatuagens/$tattooId',
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
