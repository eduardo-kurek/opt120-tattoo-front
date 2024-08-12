import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tatuagem_front/screens/register.dart';
import 'package:tatuagem_front/utils/TokenProvider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Register(),
    );
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TokenProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
