// lib/main.dart
import 'package:flutter/material.dart';
import 'login.dart';
//https://mohammad-ilham-setiawan.github.io/api/login.json
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
