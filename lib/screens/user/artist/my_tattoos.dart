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
      dao.create(tattoo);
      _refreshData();
    }catch(e){
      msg = e.toString();
    }
    Messenger.snackBar(context, msg);
  }

  Future<void> _update() async{
    String msg = "Tatuagem atualizada com sucesso";
    try{

      _refreshData();
    }catch(e){
      msg = e.toString();
    }
    Messenger.snackBar(context, msg);
  }

  Future<void> _delete(String tattooId) async{
    String msg = "Tatuagem deletada com sucesso";
    try{

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

    _tattoos = await dao.getAllByArtist(decoded['id']);
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
                  else await _update();

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
          title: const Text('Minhas Tattoos'),
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: (){_showModal(_tattoos[i].id);},
                            icon: const Icon(Icons.edit)
                          ),
                          IconButton(
                            onPressed: (){_delete(_tattoos[i].id);},
                            icon: const Icon(Icons.delete)
                          )
                        ],
                      ),
                    ),
                    const Divider(height: 10),
                    Text(_tattoos[i].imagem)
                  ],
                )
              ),
            )
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){_showModal(null);},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

}
