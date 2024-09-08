import 'package:flutter/material.dart';
import 'package:tatuagem_front/Models/Utils.dart';
import 'package:intl/intl.dart';

class TattooInfoDialog extends StatelessWidget {
  final Utils schedule;
  final String Function(String date) formatDate;

  const TattooInfoDialog({
    Key? key,
    required this.schedule,
    required this.formatDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Informações da Tatuagem'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Descrição: ${schedule.estilo}'),
          Text('Data de Início: ${formatDate(schedule.data_inicio)}'),
          Text('Preço: R\$ ${schedule.preco.toString().replaceAll('.', ',')}'),
          Text('Duração: ${schedule.duracao} minutos'),
          Text('Tatuador: ${schedule.tatuador_name}'),
          Text('Cliente: ${schedule.client_name}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
