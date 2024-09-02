import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    TattooDAO dao = TattooDAO(tokenProvider: tokenProvider);

    return Authenticate(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Novo agendamento'),
        ),
        drawer: const Menu(),
        body: FutureBuilder<List<Tattoo>>(
          future: dao.getAll(), // Chama a função que retorna o Future
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
                          if (tatoo != null) return TatooCard(tatoo: tatoo);
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
  });

  final Tattoo tatoo;

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
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
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
              )),
        ],
      ),
    );
  }
}
