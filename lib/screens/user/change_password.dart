import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/screens/components/authenticate.dart';

import '../../services/Api.dart';
import '../../utils/Messenger.dart';
import '../../utils/TokenProvider.dart';
import '../components/menu.dart';
import '../register.dart';
import 'logout.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmNewController = TextEditingController();

  late final String _userId;
  late final String _token;

  void _initializeTokenAndUserId() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    _token = await tokenProvider.token;
    final decodedToken = tokenProvider.decodedToken;
    print(decodedToken);
    _userId = decodedToken['id'];
  }

  void _save() async {
    if(_currentController.text == ''){
      Messenger.snackBar(context, "A senha atual não pode ser vazia");
      return;
    }

    if(_newController.text == ''){
      Messenger.snackBar(context, "A senha nova não pode ser vazia");
      return;
    }

    if(_confirmNewController.text == ''){
      Messenger.snackBar(context, "Confirme a senha");
      return;
    }

    if(_confirmNewController.text != _newController.text){
      Messenger.snackBar(context, "As senhas não correspondem");
      return;
    }

    try {
      final Map<String, dynamic> data = await ApiService.patch(
        'api/usuarios/atualizar-perfil/$_userId?senha=${_currentController.text}',
        {
          'senha': _confirmNewController.text,
        },
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      if (data.isNotEmpty) {
        print(data);
        setState(() {
          _currentController.clear();
          _newController.clear();
          _confirmNewController.clear();
        });
        Messenger.snackBar(context, "Senha alterada com sucesso");
      }
    } catch (error) {
      print(error);
      Messenger.snackBar(context, "Senha incorreta");
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeTokenAndUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Authenticate(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Alterar senha'),
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
                          const Text("Alterar senha",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                          TextFormField(
                            controller: _currentController,
                            decoration: const InputDecoration(
                              labelText: 'Senha atual',
                            ),
                          ),
                          TextFormField(
                            controller: _newController,
                            decoration: const InputDecoration(
                                labelText: 'Nova senha',
                            ),
                          ),
                          TextFormField(
                            controller: _confirmNewController,
                            decoration: const InputDecoration(
                                labelText: 'Confirmar nova senha'
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            child: const Text("Confirmar"),
                            onPressed: () {
                              _save();
                            },
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            )
        ),
      ),
    );
  }

}
