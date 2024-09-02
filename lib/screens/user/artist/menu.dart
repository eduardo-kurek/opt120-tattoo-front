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

class ArtistHome extends StatefulWidget {
  const ArtistHome({super.key});

  @override
  State<ArtistHome> createState() => _ArtistHomeState();
}

class _ArtistHomeState extends State<ArtistHome> {
  List<Tattoo> _tattoos = [];

  Future<void> _cancelScheduling(String tattooId) async {
    /*TODO: Implementar cancelamento de agendamento*/
  }

  void _refreshData() async{
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    TattooDAO dao = TattooDAO(tokenProvider: tokenProvider);
    var decoded = tokenProvider.decodedToken;

    _tattoos = await dao.getAllByArtist('api/tatuagens/agendadas/artist');
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
          title: const Text('Meus Agendamentos'),
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
                itemCount: _tattoos.length,
                itemBuilder: (context, index) {
                  final tatoo = _tattoos[index];
                  return TatooCard(
                    tatoo: tatoo,
                    onCancel: (tattooId) => _cancelScheduling(tattooId),
                  );
                });
          }),
        ),
      ),
    );
  }
}

class TatooCard extends StatelessWidget {
  const TatooCard({
    super.key,
    required this.tatoo,
    required this.onCancel,
  });

  final Tattoo tatoo;
  final void Function(String tattooId) onCancel;

  @override
  Widget build(BuildContext context) {
    print('tatoo.imagem: ${tatoo.imagem}');
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
                      'Tamanho: ${tatoo.tamanho.toString()} cm',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
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
                  // const SizedBox(
                  //   height: 50,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                       IconButton(
                      icon: const Icon(Icons.event_busy),
                      color: Colors.red,
                      onPressed: () => onCancel(tatoo.id!),
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
