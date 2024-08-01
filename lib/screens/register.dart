import 'package:flutter/material.dart';
import 'components/menu.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void register(){
    print(_nameController.text);
    print(_passwordController.text);
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
        padding: const EdgeInsets.all(10),
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
                      prefixIcon: Icon(Icons.person)
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.password)
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: register,
                      child: const Text("Cadastrar", style: TextStyle(fontSize: 17))
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
