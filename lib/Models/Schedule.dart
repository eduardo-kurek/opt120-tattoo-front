// classe para buscar agendamentos
class Schedule{
   String id;
  double preco;
  String imagem;
  int tamanho;
  String cor;
  String estilo;
  String data_criacao;
  String data_atualizacao;
  String data_exclusao;
  String client_id;
  String agendamento_id;
  String tatuador_id;
  String criado_por;


  Schedule({
    required this.imagem,
    required this.preco,
    this.id = '',
    this.tamanho = 0,
    this.cor = '',
    this.estilo = '',
    this.data_criacao = '',
    this.data_atualizacao = '',
    this.data_exclusao = '',
    this.client_id = '',
    this.agendamento_id = '',
    this.tatuador_id = '',
    this.criado_por = '',
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      imagem: json['imagem'] ?? '',
      preco: json['preco']?.toDouble() ?? 0.0,
      id: json['id'] ?? '',
      tamanho: json['tamanho'] ?? 0,
      cor: json['cor'] ?? '',
      estilo: json['estilo'] ?? '',
      data_criacao: json['data_criacao'] ?? '',
      data_atualizacao: json['data_atualizacao'] ?? '',
      data_exclusao: json['data_exclusao'] ?? '',
      client_id: json['client_id'] ?? '',
      agendamento_id: json['agendamento_id'] ?? '',
      tatuador_id: json['tatuador_id'] ?? '',
      criado_por: json['criado_por'] ?? '',
    );
  }
}

// usada para criar agendamentos
class CreateSchedule{
  String id;
  String client_id;
  String tatuador_id;
  String servico_id;
  DateTime data;
  String observacao;


  CreateSchedule({
    // required this.id,
    // required this.servico_id,
    this.id = '',
    this.servico_id = '',
    required this.client_id,
    required this.tatuador_id,
    required this.data,
    required this.observacao,
  });

  factory CreateSchedule.fromJson(Map<String, dynamic> json) {
    return CreateSchedule(
      // id: json['id'],
      id: json['id'] ?? '',
      client_id: json['client_id'] ?? '',
      tatuador_id: json['tatuador_id'],
      servico_id: json['servico_id'] ?? '',
      data: json['data'],
      observacao: json['observacao'],
    );
  }
}