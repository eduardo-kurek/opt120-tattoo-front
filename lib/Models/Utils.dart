class Utils{
  String agendamento_id;
  String client_id;
  String tatuador_id;
  String tatuagem_id;
  String observacao;
  String imagem;
  String estilo;
  String data_inicio;
  double preco;
  // int tamanho;
  int duracao;
 

  Utils({
    required this.agendamento_id,
    required this.client_id,
    required this.tatuador_id,
    required this.tatuagem_id,
    required this.observacao,
    required this.imagem,
    required this.estilo,
    required this.data_inicio,
    required this.preco,
    // required this.tamanho,
    required this.duracao,
  });

  factory Utils.fromJson(Map<String, dynamic> json) {
    return Utils(
      agendamento_id: json['agendamento_id'] ?? '',
      client_id: json['client_id'] ?? '',
      tatuador_id: json['tatuador_id'] ?? '',
      tatuagem_id: json['tatuagem_id'] ?? '',
      observacao: json['observacao'] ?? '',
      imagem: json['imagem'] ?? '',
      estilo: json['estilo'] ?? '',
      data_inicio: json['data_inicio'] ?? '',
      preco: json['preco'] ?? 0.0,
      // tamanho: json['tamanho'] ?? 0,
      duracao: json['duracao'] ?? 0,
    );
  }
}