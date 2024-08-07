import 'package:flutter/material.dart';
import 'package:tatuagem_front/screens/login.dart';
import 'package:tatuagem_front/services/Api.dart';

class Authenticate extends StatefulWidget {
  final Widget child;
  const Authenticate({super.key, required this.child});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: ApiService.isLogged(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao verificar login'));
        } else if (snapshot.hasData && snapshot.data == true) {
          return widget.child;
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Login()),
            );
          });
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}