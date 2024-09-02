import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/services/Api.dart';
import 'package:tatuagem_front/utils/Messenger.dart';
import 'package:tatuagem_front/utils/TokenProvider.dart';
import '../screens/user/user_home.dart';
import '../screens/register.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
//import 'dart:html' as html;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';


class MyAccountForm extends StatefulWidget {
  const MyAccountForm({super.key});

  @override
  _MyAccountFormState createState() => _MyAccountFormState();
}

class _MyAccountFormState extends State<MyAccountForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rgController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  late final String _token;
  late final String _userId;

  void dispose() {
    _nameController.dispose();
    _rgController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  
  @override
  void initState() {
    super.initState();
    _initializeTokenAndUserId();
    _fetchUserData();
  }

  void _initializeTokenAndUserId() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    _token = await tokenProvider.token;
    final decodedToken = tokenProvider.decodedToken;
    _userId = decodedToken['id'];
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      final response = await ApiService.get('api/usuarios/perfil/$_userId',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        );

        if (response != null) {
          setState(() {
            _nameController.text = response['nome'] ?? '';
            _cpfController.text = response['cpf'] ?? '';
            _rgController.text = response['rg'] ?? '';
            _emailController.text = response['email'] ?? '';
            _telefoneController.text = response['telefone_celular'] ?? '';
        });
       }
      } catch (error) {
        print('erro');
      }
    }

    void updateUser() async {
      try {
        final Map<String, dynamic> data = await ApiService.patch( 
          'api/usuarios/atualizar-perfil/$_userId',
          {
            'nome': _nameController.text,
            'cpf': _cpfController.text,
            'rg': _rgController.text,
            'email': _emailController.text,
            'telefone_celular': _telefoneController.text
          },
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );

        if (data['statusCode'] == 200) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        Map<String, dynamic> data =
            jsonDecode(e.toString().replaceFirst('Exception: ', ''));
        Messenger.snackBar(context, data['error']);
      }
    }

    void deleteUser() async {
      try {
        final Map<String, dynamic> data = await ApiService.delete( 
          'api/usuarios/excluir-perfil/$_userId',
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json; charset=UTF-8'
          },
        );

        if (data['statusCode'] == 204) {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Register()),
        );
        }
      } catch (e) {
        Map<String, dynamic> data =
            jsonDecode(e.toString().replaceFirst('Exception: ', ''));
        Messenger.snackBar(context, data['error']);
      }
    }

  @override
  Widget build(BuildContext context) {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final decodedToken = tokenProvider.decodedToken;
    final String id = decodedToken['id'];
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
              controller: _rgController,
              decoration: const InputDecoration(
                labelText: 'RG',
                hintText: '000000000'
              ),
            ),
            TextFormField(
              controller: _cpfController,
              decoration: const InputDecoration(
                labelText: 'CPF',
                hintText: '00000000000'
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            TextFormField(
              controller: _telefoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                hintText: '+5544999999999'
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Apagar conta"),
          onPressed: () {
            deleteUser();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red, // Define a cor de fundo
          ),
        ),
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text("Atualizar"),
          onPressed: () {
            updateUser();
          },
        ),
      ],
    );
  }
}
