class Tattoo{
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

  Tattoo({
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

  factory Tattoo.fromJson(Map<String, dynamic> json) {
    return Tattoo(
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