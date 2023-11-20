import 'package:flutter/material.dart';
import 'package:clima_app/widgets/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App del Clima',
      debugShowCheckedModeBanner: false,
      home: MiPaginaPrincipal(),
    );
  }
}
