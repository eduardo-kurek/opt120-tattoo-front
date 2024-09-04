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

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  List<Utils> _schedules = [];

  void _refreshData() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    ScheduleDAO dao = ScheduleDAO(tokenProvider: tokenProvider);
    var decoded = tokenProvider.decodedToken;
    _schedules = await dao.getAllLoggedUser();
    setState(() {});
  }

  void _cancelar(String agendamentoId) async{
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    ScheduleDAO dao = ScheduleDAO(tokenProvider: tokenProvider);

    await dao.delete(agendamentoId);

    _refreshData();
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
          title: const Text('Agendamentos realizados'),
        ),
        drawer: const Menu(),
        body: Container(
          color: Colors.black87,
          padding: const EdgeInsets.all(50),
          child: ListView.builder(
            itemCount: _schedules.length,
            itemBuilder: (context, i) => Card(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(_schedules[i].estilo ?? 'Estilo'),
                          subtitle: Text(_schedules[i].preco?.toStringAsFixed(2) ?? 'Preço'),
                        ),
                        ListTile(
                          title: Text(_schedules[i].data_inicio ?? 'Data de início'),
                          subtitle: Text(_schedules[i].duracao != ''?
                          '${_schedules[i].duracao.toString()} minutos' : 'Data de término') ,
                        ),
                        const Divider(height: 10),
                        Image.network(
                          _schedules[i].imagem ?? '',
                          width: double.infinity,
                          height: 400,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Text("Erro ao buscar imagem");
                          },
                        ),
                        const Divider(height: 10),
                        TextButton(
                            onPressed: () {
                              _cancelar(_schedules[i].agendamento_id);
                            },
                            child: Text('Cancelar agendamento')
                        )
                      ],
                    )
                )
            ),
          ),
        ),
      ),
    );
  }
}
