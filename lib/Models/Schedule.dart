// Classe contendo propriedades temporárias, apenas para teste... TODO
class Schedule{
  String id;
  String horario;
  String nome_tatuagem;

  Schedule({
    required this.id,
    required this.horario,
    this.nome_tatuagem = '',
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] ?? '',
      horario: json['horario'] ?? '',
      nome_tatuagem: json['nome_tatuagem'] ?? ''
    );
  }
}