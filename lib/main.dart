import 'package:app_carrinho_de_compras/injections/app_injection.dart';
import 'package:app_carrinho_de_compras/presentation/widgets/home.dart';
import 'package:flutter/material.dart';

void main() {
  AppInjection.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carrinho de Compras',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
