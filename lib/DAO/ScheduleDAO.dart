import 'dart:convert';
import 'dart:io';

import 'package:tatuagem_front/Models/Schedule.dart';
import 'package:tatuagem_front/services/Api.dart';

import '../Models/Tattoo.dart';
import '../Models/Utils.dart';
import '../utils/TokenProvider.dart';

class ScheduleDAO {
  TokenProvider tokenProvider;

  ScheduleDAO({required this.tokenProvider});

Future<List<Schedule>> _getSchedules(String endpoint) async {
  final List<Map<String, dynamic>> data = await ApiService.getAll(
    endpoint,
    headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
  );

  return data.map((map) => Schedule.fromJson(map)).toList();
}

Future<Tattoo> _getTattoo(String tattooId) async {
  final tattooData = await ApiService.get(
    'api/tatuagens/$tattooId',
    headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
  );

  return Tattoo.fromJson(tattooData);
}

Future<Map<String, dynamic>> _getUser(String userId) async {

  final decodedToken = tokenProvider.decodedToken;
  final String id = decodedToken['id'];
  print('api/usuarios/perfil/$id');

  return await ApiService.get(
    'api/usuarios/perfil/$id',
    headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
  );
}

Future<Map<String, dynamic>> _getTatuador(String tatuadorId) async {
  return await ApiService.get(
    'api/tatuadores/$tatuadorId',
    headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
  );
}

Future<Utils> _createUtils(Schedule schedule) async {
  final tattoo = await _getTattoo(schedule.tatuagem_id);

  final user = await _getUser(schedule.client_id);
  final tatuador = await _getTatuador(schedule.tatuador_id);

  return Utils(
    agendamento_id: schedule.id,
    client_id: schedule.client_id,
    client_name: user['nome'],
    tatuador_id: schedule.tatuador_id,
    tatuador_name: tatuador['nome'],
    tatuagem_id: schedule.tatuagem_id,
    observacao: schedule.observacao,
    imagem: tattoo.imagem,
    estilo: tattoo.estilo,
    data_inicio: schedule.data_inicio,
    preco: tattoo.preco,
    duracao: schedule.duracao,
  );
}

  Future<List<Utils>> getAllLoggedUser() async {
    final List<Schedule> schedules = await _getSchedules('api/agendamentos-usuario');

    List<Utils> utils = [];

    for (var schedule in schedules) {
      utils.add(await _createUtils(schedule));
    }

    return utils;
  }

  Future<List<Utils>> getAllByArtistUser() async {
    final decodedToken = tokenProvider.decodedToken;
    final String artistId = decodedToken['tatuador']['id'];

    final List<Schedule> schedules = await _getSchedules('api/agendamentos-tatuador/$artistId');
    
    List<Utils> utils = [];

    for (var schedule in schedules) {
      utils.add(await _createUtils(schedule));
    }

    return utils;
  }

  Future<String> create(String tatuadorId, String tatuagemId, String dataInicio, String observacao) async {
    final token = await tokenProvider.token;
    final decodedToken = tokenProvider.decodedToken;

    final response = await ApiService.post('api/agendamento-usuario', {
      'tatuador_id': tatuadorId,
      'tatuagem_id': tatuagemId,
      'data_inicio': dataInicio,
      'duracao': 60,
      'observacao': observacao,
    },
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (response['statusCode'] == 201) {
      return "Agendamento concluido com sucesso";
    }

    throw Exception(response);
  }

  Future<List<String>> getDisponibility(String artistId, DateTime date) async{
    final token = await tokenProvider.token;
    final decodedToken = tokenProvider.decodedToken;
    String formattedDate = "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";


    try{
      final data = await ApiService.get(
        'api/disponibilidade-tatuador/$artistId?dia_consulta=$formattedDate',
        headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
      );

      List<dynamic> jsonList = jsonDecode(data['message']);
      List<String> ret = jsonList.map((item) => item as String).toList();

      return ret;
    }catch(e){
      print(e);
      throw Exception("Erro ao consultar a data");
    }

    return [];

  }

  Future<void> delete(String scheduleId) async{
    await ApiService.delete(
      'api/agendamento-usuario/$scheduleId',
      headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
    );
  }
}

class CreateScheduleDAO {
  TokenProvider tokenProvider;

  CreateScheduleDAO({required this.tokenProvider});

  Future<String> create(CreateSchedule schedule) async {
    try {
      final response = await ApiService.post(
        'api/agendamento-usuario', {
          'client_id': schedule.client_id,
          'tatuador_id': schedule.tatuador_id,
          'data': schedule.data,
          'observacao': schedule.observacao,
          'duracao': 120
        },
        headers: {
          'Authorization': 'Bearer ${await tokenProvider.token}',
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      if (response['statusCode'] != 201) {
        return response['body']['message'];
      }
      return response['body'];
    } on SocketException {
      return 'Erro ao se conectar com o servidor';
    } catch (e) {
      return 'Erro ao criar agendamento';
    }

  }

  Future<void> update(tattoo, tattoId) async {
    // TODO
  }
}

