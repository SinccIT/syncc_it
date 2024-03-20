import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {

  // main()에서 async 사용
  WidgetsFlutterBinding.ensureInitialized();

  // Shared Preference 인스턴스 생성
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
    );
  }
}