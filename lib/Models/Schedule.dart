// classe para buscar agendamentos
class Schedule{
  String client_id;
  int duracao;
  String status;
  String observacao;  
  String data_inicio;
  String data_criacao;
  String data_atualizacao;
  String data_cancelamento;
  String id;
  String tatuador_id;
  String servico_id;
  String data_termino;
  String estudio_id;
  String tatuagem_id;
  // double preco;
  // String imagem;
  // int tamanho;
  // String cor;
  // String estilo;
  // String agendamento_id;
  // String criado_por;


  Schedule({
    required this.client_id,
    required this.duracao,
    required this.status,
    required this.observacao,
    required this.data_inicio,
    required this.data_criacao,
    required this.data_atualizacao,
    required this.data_cancelamento,
    required this.id,
    required this.tatuador_id,
    required this.servico_id,
    required this.data_termino,
    required this.estudio_id,
    required this.tatuagem_id,
    // required this.preco,
    // required this.imagem,
    // required this.tamanho,
    // required this.cor,
    // required this.estilo,
    // required this.agendamento_id,
    // required this.criado_por,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      client_id: json['client_id'] ?? '',
      duracao: json['duracao'] ?? 0,
      status: json['status'] ?? '',
      observacao: json['observacao'] ?? '',
      data_inicio: json['data_inicio'] ?? '',
      data_criacao: json['data_criacao'] ?? '',
      data_atualizacao: json['data_atualizacao'] ?? '',
      data_cancelamento: json['data_cancelamento'] ?? '',
      id: json['id'] ?? '',
      tatuador_id: json['tatuador_id'] ?? '',
      servico_id: json['servico_id'] ?? '',
      data_termino: json['data_termino']  ?? '',
      estudio_id: json['estudio_id'] ?? '',
      tatuagem_id: json['tatuagem_id'] ?? '',
      // preco: json['preco'],
      // imagem: json['imagem'],
      // tamanho: json['tamanho'],
      // cor: json['cor'],
      // estilo: json['estilo'],
      // agendamento_id: json['agendamento_id'],
      // criado_por: json['criado_por'],
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