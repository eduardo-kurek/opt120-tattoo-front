import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:validators/validators.dart';
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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final TextEditingController _rgController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  void register() async {
    try {
      final data = await ApiService.post('auth/register', {
        'nome': _userController.text,
        'senha': _passwordController.text,
        'nome_completo': _nameController.text,
        'email': _emailController.text,
        'rg': _rgController.text,
        'cpf': _cpfController.text,
        'telefone_celular': _telefoneController.text,
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      Messenger.snackBar(context, "Usuário cadastrado com sucesso");
    } catch (e) {
      print(e.toString());
      String? data = e.toString().replaceFirst('Exception: ', '');
      Messenger.snackBar(context, data as String);
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
            // width: double.nan,
            padding: const EdgeInsets.all(50),
            child: Center(
              child: (ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400, // Define a largura máxima
                  maxHeight: 800, // Define a altura máxima
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Cadastro",
                                style: TextStyle(fontSize: 24)),
                            const Divider(height: 50, indent: 10),
                            TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nome completo *',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu nome completo';
                                  }
                                  return null;
                                }),
                            TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'E-mail *',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira um email';
                                  }
                                  if (!isEmail(value)) {
                                    return 'Por favor, insira um email válido';
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _userController,
                              decoration: const InputDecoration(
                                labelText: 'Usuário',
                              ),
                            ),
                            TextFormField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Senha *',
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira uma senha';
                                  }
                                  return null;
                                }),
                            TextFormField(
                                controller: _passwordConfirmationController,
                                decoration: const InputDecoration(
                                  labelText: 'Confirmar senha *',
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira uma senha';
                                  }
                                  if (value != _passwordController.value.text) {
                                    return 'valor não coincide com a senha';
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _rgController,
                              decoration: const InputDecoration(
                                  labelText: 'RG', hintText: '000000000'),
                            ),
                            TextFormField(
                                controller: _cpfController,
                                decoration: const InputDecoration(
                                    labelText: 'CPF *',
                                    hintText: '00000000000'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu CPF';
                                  }
                                  return null;
                                }),
                            TextFormField(
                                controller: _telefoneController,
                                decoration: const InputDecoration(
                                    labelText: 'Telefone *',
                                    hintText: '+5544999999999'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira seu telefone';
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 30),
                            ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    register();
                                  }
                                },
                                child: const Text("Cadastrar",
                                    style: TextStyle(fontSize: 17))),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
            )));
  }
}
