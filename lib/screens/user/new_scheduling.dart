import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/DAO/ScheduleDAO.dart';
import 'package:tatuagem_front/DAO/TattooDAO.dart';
import 'package:tatuagem_front/screens/components/authenticate.dart';
import 'package:tatuagem_front/screens/components/menu.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:tatuagem_front/utils/Messenger.dart';


import '../../../Models/Schedule.dart';
import '../../../Models/Tattoo.dart';
import '../../../utils/TokenProvider.dart';

class NewScheduling extends StatefulWidget {
  const NewScheduling({super.key});

  @override
  State<NewScheduling> createState() => _NewSchedulingState();
}

class _NewSchedulingState extends State<NewScheduling> {
  final TextEditingController _observacaoController = TextEditingController();
  DateTime? _selectedDate;
  late Future<List<Tattoo>> _tattoosFuture; // Chamada da func que obtém as tatuagens
  List<String> _horarios = []; // Lista de horarios disponiveis
  String? _selectedTime; // Horário selecionado pelo usuário

  void _clear(){
    _horarios.clear();
    _selectedTime = null;
    _selectedDate = null;
    _observacaoController.clear();
  }

  Future<void> _confirmSchedule(Tattoo tattoo) async {
    if(_selectedTime == null || _selectedDate == null){
      _clear();
      Navigator.of(context).pop();
      Messenger.snackBar(context, "Por favor, selecione um dia e o horário");
      return;
    }

    // Juntando o dia com o horário
    List<String> timeParts = _selectedTime!.split(':');
    int hours = int.parse(timeParts[0]);

    DateTime date = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        hours, 0
    );

    try {
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
      ScheduleDAO dao = ScheduleDAO(tokenProvider: tokenProvider);
      await dao.create(
          tattoo.tatuador_id, tattoo.id,
          date.toIso8601String(), _observacaoController.text
      );
      _clear();
      Navigator.of(context).pop();
      Messenger.snackBar(context, "Agendamento realizado com sucesso");
    }catch(e){
      print(e);
      _clear();
      Navigator.of(context).pop();
      Messenger.snackBar(context, "Erro ao realizar agendamento");
    }
  }

  // Função para exibir o seletor de data
  Future<void> _selectDate(BuildContext context, String artistId) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }

    // Obtendo os horarios disponiveis daquele dia
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    ScheduleDAO dao = ScheduleDAO(tokenProvider: tokenProvider);
    _horarios = await dao.getDisponibility(artistId, _selectedDate!);
  }

  void _schedule(Tattoo tattoo) {
    String title = "Realizar Agendamento";
    String exit = "Cancelar";

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 30,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    child: Text(
                      _selectedDate == null
                          ? 'Clique para selecionar a data'
                          : '${_selectedDate!.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () async{
                        await _selectDate(context, tattoo.tatuador_id);
                        setModalState(() {}); // Atualiza o estado do modal
                    }
                  ),
                  const SizedBox(height: 10),
                  if (_horarios.isNotEmpty) ...[
                    const Text(
                      'Escolha um horário:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    ..._horarios.map((horario) {
                      return ListTile(
                        title: Text(horario),
                        trailing: _selectedTime == horario
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          setModalState(() {
                            _selectedTime = horario;
                          });
                        },
                      );
                    }),
                  ] else ...[
                    const Text('Nenhum horário disponível'),
                  ],
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _observacaoController,
                    decoration: InputDecoration(hintText: "Observações"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _clear();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _confirmSchedule(tattoo);
                        },
                        child: const Text(
                          "Confimar",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    );

  }

  @override
  void initState() {
    super.initState();
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    TattooDAO dao = TattooDAO(tokenProvider: tokenProvider);
    _tattoosFuture = dao.getAll();
  }


  @override
  Widget build(BuildContext context) {
    return Authenticate(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Novo agendamento'),
        ),
        drawer: const Menu(),
        body: FutureBuilder<List<Tattoo>>(
          future: _tattoosFuture, // Chama a função que retorna o Future
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Exibe o loading enquanto espera a resposta
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Exibe uma mensagem de erro se ocorrer algum problema
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else {
              // Exibe os dados quando a requisição é completada com sucesso
              var tattoos = snapshot.data;
              return
                Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.all(15),
                  child: LayoutBuilder(builder: (context, constraints) {
                    int crossAxisCount = (constraints.maxWidth / 200).floor();
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount > 0 ? crossAxisCount : 1, // Número de colunas
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 20.0,
                          childAspectRatio: 0.6, // Proporção do card (largura/altura)
                        ),
                        itemCount: tattoos?.length,
                        itemBuilder: (context, index) {
                          final tatoo = tattoos?[index];
                          if (tatoo != null) return TatooCard(
                            tatoo: tatoo,
                            onSchedule: (tatoo) => _schedule(tatoo),
                            );
                          return const Text('Sem dados');
                        });
                  }),
                );
            }
          },
        ),
      ),
    );
  }
}

class TatooCard extends StatelessWidget {
  const TatooCard({
    super.key,
    required this.tatoo,
    required this.onSchedule,
  });

  final Tattoo tatoo;
  final void Function(Tattoo tattoo) onSchedule;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Image.network(
              tatoo.imagem,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Placeholder();
              },
            ),
          ),
          Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'R\$ ${tatoo.preco.toString().replaceAll('.', ',')}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Estilo: ${tatoo.estilo}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: TextButton(
                        onPressed: () {
                          onSchedule(tatoo);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Colors.blue[900], // Define a cor de fundo
                        ),
                        child: const Text(
                          "Agendar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
