import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tatuagem_front/services/Api.dart';
import 'package:tatuagem_front/utils/Messenger.dart';
import 'components/menu.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isArtist = false;

  void register() async {
    try {
      final data = await ApiService.post('auth/register', {
        'nome_usuario': _nameController.text,
        'senha': _passwordController.text
      });

      if(_isArtist){
        // Cadastra como artista
      }

      if (data['statusCode'] == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } catch (e) {
      Map<String, dynamic> data = jsonDecode(e.toString().replaceFirst('Exception: ', ''));
      Messenger.snackBar(context, data['error']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Menu(),
        appBar: AppBar(
          title: const Text("Cadastrar"),
        ),
        body: Container(
          color: Colors.black87,
          padding: const EdgeInsets.all(50),
          child: Center(
              child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Cadastrar", style: TextStyle(fontSize: 25)),
                        const Divider(height: 50, indent: 10),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              labelText: 'Usuário',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person)),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                              labelText: 'Senha',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock)),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _isArtist,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isArtist = value ?? false;
                                });
                              }
                            ),
                            const Text("Cadastrar como tatuador")
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: register,
                            child: const Text("Cadastrar",
                                style: TextStyle(fontSize: 17)))
                      ],
                    ),
                  ),
              )
          ),
        )
    );
  }
}
