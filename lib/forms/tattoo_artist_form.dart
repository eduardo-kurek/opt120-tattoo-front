import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/services/Api.dart';
import 'package:tatuagem_front/utils/Messenger.dart';
import 'package:tatuagem_front/utils/TokenProvider.dart';
import '../screens/user/home.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';


class TattooArtistForm extends StatefulWidget {
  const TattooArtistForm({super.key});

  @override
  _TattooArtistFormState createState() => _TattooArtistFormState();
}

class _TattooArtistFormState extends State<TattooArtistForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienciaController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();

  List<int>? _selectedFile;
  Uint8List? _bytesData;
  
  startWebFilePicker()async{
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((event){
      final files = uploadInput.files;
      final file = files![0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((event){
        setState(() {
          _bytesData = Base64Decoder().convert(reader.result.toString().split(',').last);
        });
      });
      reader.readAsDataUrl(file);
    });
  }

  void createTatoador() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final String token = await tokenProvider.token;
    final decodedToken = tokenProvider.decodedToken;
    final String id = decodedToken['id'];
    int xp = int.parse(_experienciaController.text);

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
          'tipo': _tipoController.text,
          'imagem_perfil': imageBase64
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      if (data['statusCode'] == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
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
    _tipoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Virar tatuador"),
      content: Form(
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
            TextFormField(
              controller: _tipoController,
              decoration: const InputDecoration(
                labelText: 'Tipo',
              ),
            ),
            SizedBox(height: 20,),
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: (){
                startWebFilePicker();
              }, // Abra o seletor de imagem
            ),
            _bytesData != null ? Image.memory(_bytesData!, width: 20, height: 20) : Container()

          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text("Enviar"),
          onPressed: () {
            createTatoador();
          },
        ),
      ],
    );
  }
}
