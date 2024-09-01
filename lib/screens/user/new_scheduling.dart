import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/DAO/TattooDAO.dart';
import 'package:tatuagem_front/screens/components/authenticate.dart';
import 'package:tatuagem_front/screens/components/menu.dart';

import '../../../Models/Tattoo.dart';
import '../../../utils/TokenProvider.dart';

class NewScheduling extends StatefulWidget {
  const NewScheduling({super.key});

  @override
  State<NewScheduling> createState() => _NewSchedulingState();
}

class _NewSchedulingState extends State<NewScheduling> {
  List<Tattoo> _tattoos = [];

  void _refreshData() async {
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
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // Número de colunas
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.7, // Proporção do card (largura/altura)
              ),
              itemCount: _tattoos.length,
              itemBuilder: (context, index) {
                final tatoo = _tattoos[index];
                return TatooCard(tatoo: tatoo);
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
  });

  final Tattoo tatoo;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              tatoo.imagem,
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover,
            ),
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
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    onPressed: () {
                      print('botão do card pressionado');
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
