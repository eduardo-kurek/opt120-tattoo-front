import 'dart:convert';
import 'dart:io';

import 'package:tatuagem_front/Models/Schedule.dart';
import 'package:tatuagem_front/services/Api.dart';

import '../Models/Tattoo.dart';
import '../utils/TokenProvider.dart';

class ScheduleDAO {
  TokenProvider tokenProvider;

  ScheduleDAO({required this.tokenProvider});

  // Obtém todos os agendamentos de um usuário
  Future<List<Schedule>> getAllLoggedUser() async {
    // return [
    //   Schedule(
    //     id: '1',
    //     preco: 150.00,
    //     imagem: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7pXAZGiCXpYCBRyKB_-EHWZOGL7VI6tjWRg&s',
    //     tamanho: 20,
    //     cor: 'Preto',
    //     estilo: 'Old School',
    //     data_criacao: '2024-09-01T12:00:00Z',
    //     data_atualizacao: '2024-09-02T12:00:00Z',
    //     data_exclusao: '',
    //     client_id: 'cliente1',
    //     agendamento_id: 'agendamento1',
    //     tatuador_id: 'tatuador1',
    //     criado_por: 'user1',
    //   ),
    //   Schedule(
    //     id: '2',
    //     preco: 200.00,
    //     imagem: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7pXAZGiCXpYCBRyKB_-EHWZOGL7VI6tjWRg&s',
    //     tamanho: 30,
    //     cor: 'Azul',
    //     estilo: 'Realismo',
    //     data_criacao: '2024-08-15T09:00:00Z',
    //     data_atualizacao: '2024-08-16T09:00:00Z',
    //     data_exclusao: '',
    //     client_id: 'cliente2',
    //     agendamento_id: 'agendamento2',
    //     tatuador_id: 'tatuador2',
    //     criado_por: 'user2',
    //   ),
    // ];
    final decodedToken = tokenProvider.decodedToken;

    final List<Map<String, dynamic>> data = await ApiService.getAll(
      'api/agendamentos-usuario',
      headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
    );

    final List<Schedule> schedules = data.map((map) => Schedule.fromJson(map))
        .toList();
    return schedules;
  }

  Future<List<Schedule>> getAllByArtistUser() async {
    // return [
    //   Schedule(
    //     id: '1',
    //     preco: 170.00,
    //     imagem: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7pXAZGiCXpYCBRyKB_-EHWZOGL7VI6tjWRg&s',
    //     tamanho: 20,
    //     cor: 'Preto',
    //     estilo: 'Old School',
    //     data_criacao: '2024-09-01T12:00:00Z',
    //     data_atualizacao: '2024-09-02T12:00:00Z',
    //     data_exclusao: '',
    //     client_id: 'cliente1',
    //     agendamento_id: 'agendamento1',
    //     tatuador_id: 'tatuador1',
    //     criado_por: 'user1',
    //   ),
    //   Schedule(
    //     id: '2',
    //     preco: 200.00,
    //     imagem: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7pXAZGiCXpYCBRyKB_-EHWZOGL7VI6tjWRg&s',
    //     tamanho: 30,
    //     cor: 'Azul',
    //     estilo: 'Realismo',
    //     data_criacao: '2024-08-15T09:00:00Z',
    //     data_atualizacao: '2024-08-16T09:00:00Z',
    //     data_exclusao: '',
    //     client_id: 'cliente2',
    //     agendamento_id: 'agendamento2',
    //     tatuador_id: 'tatuador2',
    //     criado_por: 'user2',
    //   ),
    // ];
    final decodedToken = tokenProvider.decodedToken;
    final String artistId = decodedToken['tatuador']['id'];

    final List<Map<String, dynamic>> data = await ApiService.getAll(
      'api/agendamentos-tatuador/$artistId',
      headers: {'Authorization': 'Bearer ${await tokenProvider.token}'},
    );

    final List<Schedule> schedules = data.map((map) => Schedule.fromJson(map))
        .toList();
    return schedules;
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

      // Converte a string para List<String>
      List<dynamic> jsonList = jsonDecode(data['message']);
      List<String> ret = jsonList.map((item) => item as String).toList();

      //print("rota usada: api/disponibilidade-tatuador/$artistId?dia_consulta=$formattedDate");
      //print("dados recebidos: $ret");

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

  Future<void> delete(String tattooId) async {
    // TODO
  }
}

