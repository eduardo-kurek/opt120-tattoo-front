import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/DAO/TattooDAO.dart';
import 'package:tatuagem_front/Models/Tattoo.dart';
import 'package:tatuagem_front/screens/components/authenticate.dart';
import 'package:tatuagem_front/screens/components/menu.dart';
import 'package:tatuagem_front/screens/components/user_menu.dart';
import 'package:tatuagem_front/utils/TokenProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Tattoo> _tattoos = [];

  void _refreshData() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    TattooDAO dao = TattooDAO(tokenProvider: tokenProvider);
    var decoded = tokenProvider.decodedToken;

    _tattoos = await dao.getAll();
    setState(() {});
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
          title: const Text('Home Page'),
        ),
        drawer: const Menu(),
        body: Container(
          color: Colors.black87,
          padding: const EdgeInsets.all(50),
          child: const Center(
              child: Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text("Conteudo aqui...")]),
            ),
          )),
        ),
      ),
    );
  }
}
