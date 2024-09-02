import 'dart:io';

import 'package:tatuagem_front/Models/Schedule.dart';
import 'package:tatuagem_front/services/Api.dart';

import '../Models/Tattoo.dart';
import '../utils/TokenProvider.dart';

class ScheduleDAO {
  TokenProvider tokenProvider;

  ScheduleDAO({required this.tokenProvider});

  // Obtém todos os agendamentos de um usuário
  Future<List<Schedule>> getAllByUserId(String userId) async {
    final decodedToken = tokenProvider.decodedToken;
    final String userId = decodedToken['id'];
    final List<Map<String, dynamic>> data = await ApiService.getAll(
      'api/agendamentos-usuario/$userId',
      headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
    );

    final List<Schedule> schedules = data.map((map) => Schedule.fromJson(map)).toList();
    return schedules;
  }

  Future<List<Schedule>> getAllByArtistUser() async {
    final decodedToken = tokenProvider.decodedToken;
    final String artistId = decodedToken['tatuador']['id'];

    final List<Map<String, dynamic>> data = await ApiService.getAll(
      'api/agendamentos-tatuador/$artistId', 
      headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
    );

    final List<Schedule> schedules = data.map((map) => Schedule.fromJson(map)).toList();
    return schedules;
  }

  Future<String> create(Schedule schedule) async {
    // TODO
    return '';
  }

  Future<void> update(tattoo, tattoId) async {
    // TODO
  }

  Future<void> delete(String tattooId) async {
    // TODO
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

  Future<void> delete(String tattooId) async {
    // TODO
  }
}

