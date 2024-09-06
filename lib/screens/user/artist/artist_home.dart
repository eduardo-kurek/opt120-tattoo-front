import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/DAO/ScheduleDAO.dart';
import 'package:tatuagem_front/DAO/TattooDAO.dart';
import 'package:tatuagem_front/Models/Schedule.dart';
import 'package:tatuagem_front/Models/Tattoo.dart';
import 'package:tatuagem_front/Models/Utils.dart';
import 'package:tatuagem_front/screens/components/authenticate.dart';
import 'package:tatuagem_front/screens/components/menu.dart';
import 'package:tatuagem_front/screens/components/user_menu.dart';
import 'package:tatuagem_front/utils/TokenProvider.dart';
import 'package:intl/intl.dart';

class ArtistHome extends StatefulWidget {
  const ArtistHome({super.key});

  @override
  State<ArtistHome> createState() => _ArtistHomeState();
}

class _ArtistHomeState extends State<ArtistHome> {
  List<Utils> _schedules = [];

  void _refreshData() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    ScheduleDAO dao = ScheduleDAO(tokenProvider: tokenProvider);

    _schedules = await dao.getAllByArtistUser();
    setState(() {});
  }

  void _cancelar(String agendamentoId) async{
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    ScheduleDAO dao = ScheduleDAO(tokenProvider: tokenProvider);
    await dao.delete(agendamentoId);
    _refreshData();
  }

  String _formatDate(String date) {
    // converter para TimeZone local (Brasília)
    final DateTime dateTime = DateTime.parse(date).toLocal();
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Authenticate(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agendamentos Realizados'),
        ),
        drawer: const Menu(),
        body: Container(
          color: Colors.black87,
          padding: const EdgeInsets.all(15),
          child: LayoutBuilder(builder: (context, constraints) {
            // Calcula o número de colunas com base na largura da tela
            int crossAxisCount = (constraints.maxWidth / 200).floor();
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, // Número de colunas
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 0.6, // Proporção do card (largura/altura)
                ),
                itemCount: _schedules.length,
                itemBuilder: (context, index) {
                  final schedule = _schedules[index];
                  return TatooCard(
                    schedule: schedule,
                    onDelete: (agendamento_id) => _cancelar(agendamento_id),
                    formatDate: _formatDate,
                  );
                });
          }),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: (){_showModal(null);},
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}

class TatooCard extends StatelessWidget {
  const TatooCard({
    super.key,
    required this.schedule,
    required this.onDelete, 
    required this.formatDate,
  });

  final Utils schedule;
  final void Function(String tattooId) onDelete;
  final String Function(String date) formatDate;

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
              schedule.imagem,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Placeholder();
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
                      'R\$ ${schedule.preco.toString().replaceAll('.', ',')}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Data: ${formatDate(schedule.data_inicio)}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '${schedule.duracao.toString()} minutos',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //   child: Text(
                  //     'Estilo: ${schedule.estilo}',
                  //     style: TextStyle(
                  //       fontSize: 14.0,
                  //       color: Colors.grey[600],
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 50,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    TextButton.icon(
                      onPressed: () => onDelete(schedule.agendamento_id),
                      icon: Icon(
                        Icons.event_busy_outlined,
                        color: Colors.red,
                      ),
                      label: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}


  // @override
  // Widget build(BuildContext context) {
  //   return Authenticate(
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Agendamentos realizados'),
  //       ),
  //       drawer: const Menu(),
  //       body: Container(
  //         color: Colors.black87,
  //         padding: const EdgeInsets.all(50),
  //         child: ListView.builder(
  //           itemCount: _schedules.length,
  //           itemBuilder: (context, i) => Card(
  //               child: Padding(
  //                   padding: const EdgeInsets.all(10),
  //                   child: Column(
  //                     children: [
  //                       ListTile(
  //                         title: Text(_schedules[i].estilo ?? 'Estilo'),
  //                         subtitle: Text(_schedules[i].preco?.toStringAsFixed(2) ?? 'Preço'),
  //                       ),
  //                       ListTile(
  //                         title: Text(_schedules[i].data_inicio ?? 'Data de início'),
  //                         subtitle: Text(_schedules[i].duracao != ''?
  //                         '${_schedules[i].duracao.toString()} minutos' : 'Data de término') ,
  //                       ),
  //                       const Divider(height: 10),
  //                       Image.network(
  //                         _schedules[i].imagem ?? '',
  //                         width: double.infinity,
  //                         height: 400,
  //                         fit: BoxFit.cover,
  //                         errorBuilder: (BuildContext context, Object exception,
  //                             StackTrace? stackTrace) {
  //                           return Text("Erro ao buscar imagem");
  //                         },
  //                       ),
  //                       const Divider(height: 10),
  //                       TextButton(
  //                           onPressed: () {
  //                             _cancelar(_schedules[i].agendamento_id);
  //                           },
  //                           child: Text('Cancelar agendamento')
  //                       )
  //                     ],
  //                   )
  //               )
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }