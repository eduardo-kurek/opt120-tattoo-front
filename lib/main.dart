import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/screens/login.dart';
import 'package:tatuagem_front/screens/user/user_home.dart';
import 'package:tatuagem_front/utils/TokenProvider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenProvider = Provider.of<TokenProvider>(context);
    final isLogged = tokenProvider.isLogged();
  
    if (isLogged) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: UserHome(),
      );
    }

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TokenProvider()),
      ],
      child: Container(
        color: Colors.black87,
        child: const MyApp()
      ),
    ),
  );
}
