import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/screens/components/unlogged_menu.dart';
import 'package:tatuagem_front/screens/login.dart';
import 'package:tatuagem_front/services/Api.dart';
import 'package:tatuagem_front/utils/TokenProvider.dart';

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
    final tokenProvider = Provider.of<TokenProvider>(context);

    if (tokenProvider.isLogged()) return widget.child;

    return const Login();
  }
}