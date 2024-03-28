import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncc_it/joinup.dart';

import 'auth_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  final String name; // JoinUpPage에서 전달된 이름을 저장할 변수
  const LoginPage({Key? key, required this.name, required this.isPassword})
      : super(key: key);
  final bool isPassword;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      User? user = authService.currentUser();
      return Scaffold(
        backgroundColor: Color(0xFF777777),
        appBar: AppBar(
          title: Text('로그인'),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    user == null ? '로그인 해주세요' : '안녕하세요',
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
                  SizedBox(height: 40), // 간격 조절
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '이메일',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // 이메일 입력란
                      TextFieldContainer(
                        controller: emailController,
                        onChanged: (value) {
                          // 입력값이 변경될 때 처리할 로직 추가
                        },
                        isPassword: false,
                      ),
                      SizedBox(height: 10), // 간격 조절
                      Row(
                        children: [
                          Text(
                            '비밀번호',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // 비밀번호 입력란
                      TextFieldContainer(
                        controller: passwordController,
                        isPassword: true,
                        onChanged: (value) {
                          // 입력값이 변경될 때 처리할 로직 추가
                        },
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
                                MaterialPageRoute(builder: (_) => HomePage(authService: authService,)),
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // 버튼 모서리 라운드 설정
                              side: BorderSide(
                                color: Color(0xFF27F39D),
                                width: 2, // 버튼 테두리 두께
                              ),
                            ),
                          ),
                          fixedSize: MaterialStateProperty.all<Size>(
                            Size(300, 50), // 버튼 고정 크기 설정
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
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class TextFieldContainer extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool isPassword;

  const TextFieldContainer({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.isPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey),
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '여기에 입력하세요',
          hintStyle: TextStyle(color: Colors.grey),
        ),
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
      ),
    );
  }
}
