import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/screens/components/authenticate.dart';
import 'package:tatuagem_front/screens/user/logout.dart';

import '../../services/Api.dart';
import '../../utils/Messenger.dart';
import '../../utils/TokenProvider.dart';
import '../components/menu.dart';
import 'user_home.dart';

class BecomeArtist extends StatefulWidget {
  const BecomeArtist({super.key});

  @override
  State<BecomeArtist> createState() => _BecomeArtistState();
}

class _BecomeArtistState extends State<BecomeArtist> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienciaController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  String _tipoController = 'PROPRIETARIO';
  final List<String> _tipoOptions = ['PROPRIETARIO', 'AUTONOMO'];

  List<int>? _selectedFile;
  Uint8List? _bytesData;

  // startWebFilePicker()async{
  //   html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  //   uploadInput.draggable = true;
  //   uploadInput.click();
  //
  //   uploadInput.onChange.listen((event){
  //     final files = uploadInput.files;
  //     final file = files![0];
  //     final reader = html.FileReader();
  //
  //     reader.onLoadEnd.listen((event){
  //       setState(() {
  //         _bytesData = Base64Decoder().convert(reader.result.toString().split(',').last);
  //       });
  //     });
  //     reader.readAsDataUrl(file);
  //   });
  // }

  void createTatoador() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final String token = await tokenProvider.token;
    final decodedToken = tokenProvider.decodedToken;
    final String id = decodedToken['id'];
    final String xp = _experienciaController.text;

    try {

      String? imageBase64;
      if (_bytesData != null) {
        imageBase64 = base64Encode(_bytesData!);
      }

      final Map<String, dynamic> data = await ApiService.post(
        'api/tatuadores',
        {
          'usuario_id': id,
          'nome': _nameController.text,
          'experiencia': xp,
          'status': _statusController.text,
          'tipo': _tipoController,
          // 'imagem_perfil': imageBase64
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      if (data['statusCode'] == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Logout()),
        );
        Messenger.snackBar(context, "Você se tornou um tatuador, faça o login novamente");
      }
    } catch (e) {
      Map<String, dynamic> data =
      jsonDecode(e.toString().replaceFirst('Exception: ', ''));
      Messenger.snackBar(context, data['error']);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _experienciaController.dispose();
    _statusController.dispose();
    _tipoController = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Authenticate(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Virar Tatuador'),
        ),
        drawer: const Menu(),
        body: Container(
          color: Colors.black87,
          padding: const EdgeInsets.all(50),
          child: Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome completo',
                          ),
                        ),
                        TextFormField(
                          controller: _experienciaController,
                          decoration: const InputDecoration(
                            labelText: 'Experiencia',
                          ),
                        ),
                        TextFormField(
                          controller: _statusController,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                          ),
                        ),
                        DropdownButtonFormField(
                          value: _tipoController, // Valor atual do dropdown
                          decoration: const InputDecoration(
                            labelText: 'Tipo',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "PROPRIETARIO",
                              child: Text("PROPRIETARIO")
                            ),
                            DropdownMenuItem(
                                value: "AUTONOMO",
                                child: Text("AUTONOMO")
                            )
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              if(newValue != null){
                                _tipoController = newValue;
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        // IconButton(
                        //   icon: Icon(Icons.add_a_photo),
                        //   onPressed: (){
                        //     startWebFilePicker();
                        //   }, // Abra o seletor de imagem
                        // ),
                        _bytesData != null ? Image.memory(_bytesData!, width: 20, height: 20) : Container(),
                        ElevatedButton(
                          child: const Text("Enviar"),
                          onPressed: () {
                            createTatoador();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
        )
      ),
    );
  }
}
