import 'package:flutter/material.dart';
import 'join.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JoinPage(), // JoinPage로 이동
    );
  }
}
