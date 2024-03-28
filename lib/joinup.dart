import 'package:flutter/material.dart';
import 'package:syncc_it/home_page.dart';
import 'package:syncc_it/login.dart';

import 'auth_service.dart';

class JoinUpPage extends StatelessWidget {
  final AuthService authService; // authService를 매개변수로 선언
  JoinUpPage(
      {required this.authService,
      required this.name}); // authService를 초기화하는 생성자

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController affiliationController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

// 이름, 소속, 직무, 연령, 성별을 저장할 변수 선언
  String name = '';
  String affiliation = '';
  String position = '';
  String age = '';
  String gender = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF777777),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 25), // 간격 조절
                  Text(
                    '반갑습니다.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '가입 정보를 입력 해주세요',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20), // 각 입력 라인 사이의 간격 조절
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '이름',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextFieldContainer(
                        controller: nameController,
                        child: TextField(
                          controller: nameController,
                          onChanged: (value) {
// 이름이 변경될 때 실행되는 콜백
// 변경된 이름을 저장하는 작업 가능
                            name = value;
                          },
                        ),
                      ),
                      SizedBox(height: 10), // 각 입력 라인 사이의 간격 조절
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '이메일',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextFieldContainer(
                              controller:
                                  emailController, // 수정된 부분: controller 전달
                              onChanged: (value) {
                                // 입력값이 변경될 때 처리할 로직 추가
                              },
                              child: TextField(),
                            ),
                          ]),
                      SizedBox(height: 10), // 각 입력 라인 사이의 간격 조절
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '비밀번호',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextFieldContainer(
                              controller:
                                  passwordController, // 수정된 부분: controller 전달
                              onChanged: (value) {
                                // 입력값이 변경될 때 처리할 로직 추가
                              },
                              child: TextField(),
                            ),
                          ]),
                      SizedBox(height: 10), // 각 입력 라인 사이의 간격 조절
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '소속',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextFieldContainer(
                            controller: affiliationController,
                            child: TextField(
                              controller: affiliationController,
                              onChanged: (value) {
                                // 이름이 변경될 때 실행되는 콜백
                                // 변경된 이름을 저장하는 작업 가능
                                affiliation = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10), // 각 입력 라인 사이의 간격 조절
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '직무',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextFieldContainer(
                            controller: positionController,
                            child: TextField(
                              controller: positionController,
                              onChanged: (value) {
                                // 이름이 변경될 때 실행되는 콜백
                                // 변경된 이름을 저장하는 작업 가능
                                position = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10), // 각 입력 라인 사이의 간격 조절
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '연령',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextFieldContainer(
                            controller: ageController,
                            child: TextField(
                              controller: ageController,
                              onChanged: (value) {
                                // 이름이 변경될 때 실행되는 콜백
                                // 변경된 이름을 저장하는 작업 가능
                                age = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10), // 각 입력 라인 사이의 간격 조절
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '성별',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextFieldContainer(
                            controller: genderController,
                            child: TextField(
                              controller: genderController,
                              onChanged: (value) {
                                // 이름이 변경될 때 실행되는 콜백
                                // 변경된 이름을 저장하는 작업 가능
                                gender = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50), // 각 입력 필드와 회원가입 버튼 사이의 간격 조절
                      Center(
                        child: SizedBox(
                          width: 300, // 버튼 너비
                          height: 50, // 버튼 높이
                          child: ElevatedButton(
                            onPressed: () {
                              // 회원가입 버튼 클릭 시 동작
                              authService.signUp(
                                email: emailController.text,
                                password: passwordController.text,
                                onSuccess: () {
                                  //회원가입 성공
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('회원가입 성공'),
                                    ),
                                  );
                                  // print('회원가입 성공');
                                  // 다음 페이지로 이동
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(
                                        name: '',
                                      ), // LoginPage 연결
                                    ),
                                  );
                                },
                                onError: (err) {
                                  //에러발생
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(err),
                                    ),
                                  );
                                  // print('회원가입 실패 : $err');
                                },
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF27F39D), // 버튼 배경색
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // 버튼 모서리 라운드 설정
                                  side: BorderSide(
                                    color: Color(0xFF27F39D), // 버튼 테두리 색상
                                    width: 2, // 버튼 테두리 두께
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              '회원 가입', // 버튼 텍스트
                              style: TextStyle(
                                color: Colors.black, // 버튼 텍스트 색상
                                fontWeight: FontWeight.bold, // 버튼 텍스트 굵기
                                fontSize: 20, // 버튼 텍스트 크기
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class TextFieldContainer extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const TextFieldContainer(
      {Key? key,
      this.onChanged,
      required this.controller,
      required TextField child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey), // 입력칸 밑에 라인 추가
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged, // 입력값이 변경될 때 콜백 함수 호출
        decoration: InputDecoration(
          border: InputBorder.none, // 입력칸 테두리 제거
          hintText: '여기에 입력하세요', // 입력 필드에 대한 안내 문구
          hintStyle: TextStyle(color: Colors.grey),
        ),
        style: TextStyle(color: Colors.white), // 입력 필드의 글자색을 하얀색으로 설정
        cursorColor: Colors.white, // 입력 커서의 색상을 하얀색으로 설정
      ),
    );
  }
}
