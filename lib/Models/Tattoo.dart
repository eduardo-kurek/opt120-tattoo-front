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
}