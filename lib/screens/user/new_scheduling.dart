import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/DAO/TattooDAO.dart';
import 'package:tatuagem_front/screens/components/authenticate.dart';
import 'package:tatuagem_front/screens/components/menu.dart';
import 'package:tatuagem_front/screens/components/user_menu.dart';
import 'package:tatuagem_front/utils/Messenger.dart';

import '../../../Models/Tattoo.dart';
import '../../../utils/TokenProvider.dart';

class NewScheduling extends StatefulWidget {
  const NewScheduling({super.key});

  @override
  State<NewScheduling> createState() => _NewSchedulingState();
}

class _NewSchedulingState extends State<NewScheduling> {
  List<Tattoo> _tattoos = [];

  void _refreshData() async{
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    TattooDAO dao = TattooDAO(tokenProvider: tokenProvider);
    var decoded = tokenProvider.decodedToken;

    _tattoos = await dao.getAll();
    setState(() {});
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
          title: const Text('Novo agendamento'),
        ),
        drawer: const Menu(),
        body: Container(
            color: Colors.black87,
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
                itemCount: _tattoos.length,
                itemBuilder: (context, i) => Card(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(_tattoos[i].estilo),
                            subtitle: Text(_tattoos[i].preco.toStringAsFixed(2)),
                          ),
                          const Divider(height: 10),
                          Text(_tattoos[i].imagem)
                        ],
                      )
                  ),
                )
            )
        ),
      ),
    );
  }

}
