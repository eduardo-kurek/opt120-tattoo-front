// import 'dart:ffi';

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

class MyTattoos extends StatefulWidget {
  const MyTattoos({super.key});

  @override
  State<MyTattoos> createState() => _MyTattoosState();
}

class _MyTattoosState extends State<MyTattoos> {
  List<Tattoo> _tattoos = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(); 
  

  Future<void> _create() async{
    String msg = "Tatuagem cadastrada com sucesso";
    try{
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);

      TattooDAO dao = TattooDAO(tokenProvider: tokenProvider);
      Tattoo tattoo = Tattoo(
        preco: double.parse(_priceController.text),
        imagem: _imageController.text,
        estilo: _titleController.text
      );
      dao.create(tattoo, tokenProvider.decodedToken['id']);
      _refreshData();
    }catch(e){
      msg = e.toString();
    }
    Messenger.snackBar(context, msg);
  }

  Future<void> _update(String estilo, String preco, String img, String tattoId) async{
    String msg = "Tatuagem atualizada com sucesso";
    try{
        final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
        TattooDAO dao = TattooDAO(tokenProvider: tokenProvider);
        Tattoo tattoo = Tattoo(
          preco: double.parse(preco),
          imagem: img,
          estilo: estilo
        );
        dao.update(tattoo, tattoId);
      _refreshData();
    }catch(e){
      msg = e.toString();
    }
    Messenger.snackBar(context, msg);
  }

  Future<void> _delete(String tattooId) async{
    String msg = "Tatuagem deletada com sucesso";
    try{
      TattooDAO dao = TattooDAO(tokenProvider: Provider.of<TokenProvider>(context, listen: false));
      dao.delete(tattooId);
      _refreshData();
    }catch(e){
      msg = e.toString();
    }
    Messenger.snackBar(context, msg);
  }

  void _refreshData() async{
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    TattooDAO dao = TattooDAO(tokenProvider: tokenProvider);
    var decoded = tokenProvider.decodedToken;

    _tattoos = await dao.getAllByArtist();
    setState(() {});
  }

  void _showModal(String? tattooId){
    String title = "Adicionar tatuagem";
    String exit = "Adicionar";

    if(tattooId != null){
      final existingData = _tattoos.firstWhere((element) => element.id == tattooId);
      _titleController.text = existingData.estilo;
      _imageController.text = existingData.imagem;
      _priceController.text = existingData.preco.toStringAsFixed(2);
      title = "Atualizar tatuagem";
      exit = "Salvar";
    }else{
      _titleController.clear();
      _imageController.clear();
      _priceController.clear();
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            top: 30, left: 15, right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 50
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  hintText: "Título"
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _imageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  hintText: "Imagem"
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: "Preço",
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async{
                  if(tattooId == null) await _create();
                  else await _update(_titleController.text, _priceController.text, _imageController.text, tattooId);

                  _titleController.clear();
                  _imageController.clear();
                  _priceController.clear();
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(exit, style: const TextStyle(fontSize: 18)),
                ),
              ),
            )
          ],
        ),
      )
    );

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
          title: const Text('Minhas Tatuagens'),
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
                    onEdit: (tattooId) => _showModal(tattooId),
                    onDelete: (tattooId) => _delete(tattooId),
                  );
                });
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){_showModal(null);},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class TatooCard extends StatelessWidget {
  const TatooCard({
    super.key,
    required this.tatoo,
    required this.onEdit,
    required this.onDelete, 
  });

  final Tattoo tatoo;
  final void Function(String tattooId) onEdit;
  final void Function(String tattooId) onDelete;

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
                      icon: const Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () => onEdit(tatoo.id!),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () => onDelete(tatoo.id!),
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

//  Future<bool> isTatuador() async {
//     final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
//     if(tokenProvider.decodedToken['tatuador'] != null){
//       return true;
//     }
//     return false;
//   }
                    // FutureBuilder<bool>(
                    //   future: isTatuador,
                    //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    //     if (snapshot.hasData && snapshot.data == false) {
                    //       return Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //         child: TextButton(
                    //           onPressed: () {
                    //             print('botão do card pressionado');
                    //           },
                    //           style: TextButton.styleFrom(
                    //             backgroundColor: Colors.blue[900],
                    //           ),
                    //           child: const Text(
                    //             "Agendar",
                    //             style: TextStyle(color: Colors.white),
                    //           ),
                    //         ),
                    //       );
                    //     }
                    //     return Container(); 
                    //   },
                    // ),