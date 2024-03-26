import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:syncc_it/data_model.dart';
import 'package:syncc_it/auth_service.dart';

import 'login.dart';

import 'join.dart';

void main() async {
  // main()에서 async 사용
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 앱 초기화
  await Firebase.initializeApp();

  // Shared Preference 인스턴스 생성
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        Provider<SharedPreferences>.value(value: prefs),
      ],
      child: DataProvider(
        dataModel: DataModel(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user == null ? LoginPage() : HomePage(),
    );
  }
}
