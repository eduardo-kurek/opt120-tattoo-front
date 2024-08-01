import 'package:flutter/material.dart';
import 'package:tatuagem_front/services/Api.dart';
import 'package:tatuagem_front/utils/Messenger.dart';
import 'components/menu.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login() async{
    try {
      final data = await ApiService.post('auth/login', {
        'nome_usuario': _nameController.text,
        'senha': _passwordController.text
      });
      Messenger.snackBar(context, data["message"]);
    } catch (e) {
      Messenger.snackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Menu(),
      appBar: AppBar(
        title: const Text("Entrar no sistema"),
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
                  const Text("Entrar", style: TextStyle(fontSize: 25)),
                  const Divider(height: 50, indent: 10),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Usuário',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person)
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock)
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: login,
                      child: const Text("Entrar", style: TextStyle(fontSize: 17))
                  )
                ],
              ),
            ),
          )
        ),
      )
    );
  }
}
