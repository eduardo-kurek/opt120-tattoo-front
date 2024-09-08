import 'package:flutter/material.dart';
import 'package:tatuagem_front/Models/Utils.dart';
import 'package:intl/intl.dart';

class Tattoinfodialog extends StatelessWidget {
  final Utils tatto;

  const Tattoinfodialog({
    Key? key,
    required this.tatto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Informações da Tatuagem'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Descrição: ${tatto.estilo}'),
          Text('Preço: R\$ ${tatto.preco.toString().replaceAll('.', ',')}'),
          Text('Duração: ${tatto.duracao} minutos'),
          Text('Tatuador: ${tatto.tatuador_name}'),
          Text('Endereço: ${tatto.endereco_atendimento}'),
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
