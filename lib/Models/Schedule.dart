// Classe contendo propriedades temporárias, apenas para teste... TODO
class Schedule {
  final String id;
  final double? preco;
  final String? imagem;
  final double? tamanho;
  final String? cor;
  final String? estilo;
  final String dataCriacao;
  final String dataAtualizacao;
  final String? dataExclusao; // Note que é opcional
  final String clienteId;
  final String agendamentoId;
  final String tatuadorId;
  final String criadoPor;

  Schedule({
    required this.id,
    this.preco,
    this.imagem,
    this.tamanho,
    this.cor,
    this.estilo,
    required this.dataCriacao,
    required this.dataAtualizacao,
    this.dataExclusao,
    required this.clienteId,
    required this.agendamentoId,
    required this.tatuadorId,
    required this.criadoPor,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] as String,
      preco: json['preco'] != null ? (json['preco'] as num).toDouble() : null,
      imagem: json['imagem'] as String?,
      tamanho: json['tamanho'] != null ? (json['tamanho'] as num).toDouble() : null,
      cor: json['cor'] as String?,
      estilo: json['estilo'] as String?,
      dataCriacao: json['data_criacao'] as String,
      dataAtualizacao: json['data_atualizacao'] as String,
      dataExclusao: json['data_exclusao'] as String,
      clienteId: json['cliente_id'] as String,
      agendamentoId: json['agendamento_id'] as String,
      tatuadorId: json['tatuador_id'] as String,
      criadoPor: json['criado_por'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'preco': preco,
      'imagem': imagem,
      'tamanho': tamanho,
      'cor': cor,
      'estilo': estilo,
      'data_criacao': dataCriacao,
      'data_atualizacao': dataAtualizacao,
      'data_exclusao': dataExclusao,
      'cliente_id': clienteId,
      'agendamento_id': agendamentoId,
      'tatuador_id': tatuadorId,
      'criado_por': criadoPor,
    };
  }
}