import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences를 사용하기 위한 라이브러리 임포트
import 'package:firebase_core/firebase_core.dart'; // Firebase 초기화를 위한 라이브러리 임포트
import 'package:provider/provider.dart'; // Provider 패턴을 위한 라이브러리 임포트
import 'package:syncc_it/data_model.dart'; // 데이터 모델 클래스 임포트
import 'package:syncc_it/auth_service.dart'; // 인증 서비스 클래스 임포트
import 'home_page.dart';
import 'login.dart'; // 로그인 페이지 임포트
import 'join.dart'; // 회원 가입 페이지 임포트

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 앱의 위젯 바인딩이 초기화되었는지 확인
  await Firebase.initializeApp(); // Firebase 앱 초기화
  SharedPreferences prefs =
      await SharedPreferences.getInstance(); // SharedPreferences 인스턴스 생성 및 초기화

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                AuthService()), // AuthService를 ChangeNotifierProvider로 제공
        Provider<SharedPreferences>.value(
            value: prefs), // SharedPreferences를 Provider로 제공
      ],
      child: DataProvider(
        dataModel: DataModel(),
        child: const MyApp(), // MyApp 위젯을 MultiProvider의 child로 설정
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
