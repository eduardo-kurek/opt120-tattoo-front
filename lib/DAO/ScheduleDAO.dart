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
    return [];
    final List<Map<String, dynamic>> data = await ApiService.getAll(
      'api/agendamentos', // Ajustar a rota TODO
      headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
    );

    final List<Schedule> schedules =
    data.map((map) => Schedule.fromJson(map)).toList();
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
