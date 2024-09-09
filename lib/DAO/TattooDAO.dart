import 'dart:io';

import 'package:tatuagem_front/services/Api.dart';

import '../Models/Tattoo.dart';
import '../Models/Utils.dart';
import '../utils/TokenProvider.dart';

class TattooDAO {
  TokenProvider tokenProvider;

  TattooDAO({required this.tokenProvider});

  Future<Map<String, dynamic>> _getTatuador(String tatuadorId) async {
  return await ApiService.get(
    'api/tatuadores/$tatuadorId',
    headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
  );
}

Future<Map<String, dynamic>> _getUser(String userId) async {
  final decodedToken = tokenProvider.decodedToken;
  final String id = decodedToken['id'];

  return await ApiService.get(
    'api/usuarios/perfil/$userId',
    headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
  );
}

  Future<List<Utils>> getAll() async {
    final decodedToken = tokenProvider.decodedToken;

    final List<Map<String, dynamic>> data = await ApiService.getAll(
      'api/tatuagens',
      headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
    );

    final List<Tattoo> tattoos = data.map((map) => Tattoo.fromJson(map)).toList();

    List<Utils> utils = [];

    for (var tattoo in tattoos) {
      var tatuador = await _getTatuador(tattoo.tatuador_id);
      String user_id = tatuador['usuario_id'];
      var user = await _getUser(user_id);

      Utils util = Utils(
        agendamento_id: '',
        client_id: '',
        client_name: '',
        client_phone: '',
        tatuador_id: tatuador['id'],
        tatuador_name: tatuador['nome'],
        tatuador_phone: user['telefone_celular'] ?? '',
        tatuagem_id: tattoo.id,
        observacao: '',
        imagem: tattoo.imagem,
        estilo: tattoo.estilo,
        data_inicio: '',
        endereco_atendimento: tatuador['endereco_atendimento'] ?? '',
        preco: tattoo.preco,
        duracao: 0,
      );

      utils.add(util);
    }


    return utils;
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
