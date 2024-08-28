import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/screens/login.dart';

import '../../utils/TokenProvider.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  void _logout(){
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    tokenProvider.clear();

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator()
      ),
    );
  }
}
