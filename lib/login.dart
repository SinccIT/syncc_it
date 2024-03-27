import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  final String name; // JoinUpPage에서 전달된 이름을 저장할 변수
  const LoginPage({Key? key, required this.name}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  get name => null;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      User? user = authService.currentUser();
      return Scaffold(
        backgroundColor: Color(0xFF777777),
        appBar: AppBar(
          title: Text('로그인'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      user == null ? '로그인 해주세요' : '${this.name}님 안녕하세요',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10), // 이메일과 비밀번호 안내문구와의 간격 조절
                    Text(
                      '이메일과 비밀번호를 입력해주세요',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // 간격 조절
              Text(
                '이메일',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // 입력 라인 색상 설정
                    borderRadius: BorderRadius.circular(10), // 입력 라인 모서리 라운드 설정
                  ),
                ),
              ),
              SizedBox(height: 10), // 간격 조절
              Text(
                '비밀번호',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              TextField(
                controller: passwordController,
                //비밀번호 숨기기
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // 입력 라인 색상 설정
                    borderRadius: BorderRadius.circular(10), // 입력 라인 모서리 라운드 설정
                  ),
                ),
              ),
              SizedBox(height: 100), // 간격 조절
              ElevatedButton(
                onPressed: () {
                  //로그인
                  authService.signIn(
                    email: emailController.text,
                    password: passwordController.text,
                    onSuccess: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('로그인 성공'),
                        ),
                      );
                      //로그인 성공시 홈페이지로 이동
                      // pushReplacement 새로운 페이지로 이동해서 뒤로버튼 X
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomePage(
                              name: user!.displayName ?? ''), // 사용자 이름 전달
                        ),
                      );
                    },
                    onError: (err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(err),
                        ),
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xFF27F39D), // 버튼 배경색
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 버튼 모서리 라운드 설정
                      side: BorderSide(
                        color: Color(0xFF27F39D), // 버튼 테두리 색상
                        width: 2, // 버튼 테두리 두께
                      ),
                    ),
                  ),
                ),
                child: Text(
                  '로그인', // 버튼 텍스트
                  style: TextStyle(
                    color: Colors.black, // 버튼 텍스트 색상
                    fontWeight: FontWeight.bold, // 버튼 텍스트 굵기
                    fontSize: 20, // 버튼 텍스트 크기
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
