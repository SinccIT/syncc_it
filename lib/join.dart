import 'package:flutter/material.dart';
import 'package:syncc_it/widgets/check.dart';
import 'auth_service.dart';
import 'joinup.dart';
import 'login.dart'; // 위젯이 정의된 파일을 가져옴

// JoinPage 위젯을 StatelessWidget으로 정의.
class JoinPage extends StatelessWidget {
  final AuthService authService;
  JoinPage({required this.authService}); // authService를 초기화하는 생성자

  List<bool> isCheckedList = [
    false,
    false,
    false,
    false
  ]; // 각 체크박스의 상태를 저장하는 리스트

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Color(0xFF27F39D), // 형광 초록색 배경
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png', // 로고 이미지 파일 경로
              width: 400, // 로고 이미지 너비
              height: 200, // 로고 이미지 높이
            ),
            SizedBox(height: 5), // 로고와 버튼 사이 간격 조절
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // 가운데 정렬 및 버튼 간격 자동 조절
              children: [
                SizedBox(
                  width: 150, // 로그인 버튼 너비
                  height: 50, // 로그인 버튼 높이
                  child: TextButton(
                    onPressed: () {
                      // 로그인 버튼 클릭 시 동작할 내용 추가
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage(
                                  name: '',
                                )), // LoginPage로 이동
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.transparent), // 버튼 배경색 설정
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // 버튼 모서리 라운드 설정
                        ),
                      ),
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(
                            color: Colors.black,
                            width: 2), // 로그인 버튼 테두리 색상 및 두께 설정
                      ),
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.white, // 로그인 글자 색상 설정
                        fontWeight: FontWeight.bold, // 로그인 버튼 텍스트 굵기 설정
                        fontSize: 20, // 로그인 버튼 텍스트 크기 설정
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20), // 버튼 간격 조절

                SizedBox(
                  width: 150, // 버튼 너비
                  height: 50, // 버튼 높이
                  child: TextButton(
                    onPressed: () {
                      // 회원 가입 버튼 클릭 시 모달창 띄우기
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              bool isChecked = false; // 체크 박스 상태를 저장할 변수

                              return Container(
                                height: 300, // 모달 높이 크기
                                decoration: const BoxDecoration(
                                  color: Colors.white, // 모달 배경색
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(10), // 모달 좌상단 라운딩 처리
                                    topRight:
                                        Radius.circular(10), // 모달 우상단 라운딩 처리
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 20), //줄 간격 추가
                                    Row(
                                      children: [
                                        CustomCheckbox(
                                          value: isCheckedList[0],
                                          onChanged: (value) {
                                            setState(() {
                                              isCheckedList[0] = value!;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 20), //체크 박스와 문장 사이 간격
                                        Text(
                                          '모두 동의 합니다',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15), // 줄 간격 추가
                                    Row(
                                      children: [
                                        CustomCheckbox(
                                          value: isCheckedList[1],
                                          onChanged: (value) {
                                            setState(() {
                                              isCheckedList[1] = value!;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10), //체크 박스와 문장 사이 간격
                                        Text(
                                          '(필수) 만 14세 이상입니다',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15), // 줄 간격 추가
                                    Row(
                                      children: [
                                        CustomCheckbox(
                                          value: isCheckedList[2],
                                          onChanged: (value) {
                                            setState(() {
                                              isCheckedList[2] = value!;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10), //체크 박스와 문장 사이 간격
                                        Text(
                                          '(필수) 서비스 이용 약관',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15), // 줄 간격 추가
                                    Row(
                                      children: [
                                        CustomCheckbox(
                                          value: isCheckedList[3],
                                          onChanged: (value) {
                                            setState(() {
                                              isCheckedList[3] = value!;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          '(필수) 개인정보 수집 및 이용에 대한 안내',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 40), // 줄 간격 추가
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 350, // 다음 버튼 너비
                                          height: 50, // 다음 버튼 높이
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      JoinUpPage(
                                                    authService: authService,
                                                    name: '',
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.black),
                                              // 버튼 배경색 설정
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // 버튼 모서리 라운드 설정
                                                ),
                                              ),
                                              side: MaterialStateProperty.all<
                                                  BorderSide>(
                                                BorderSide(
                                                    color: Colors.black,
                                                    width:
                                                        2), // 다음 버튼 테두리 색상 및 두께 설정
                                              ),
                                            ),
                                            child: Text(
                                              '다음',
                                              style: TextStyle(
                                                color: Colors.white,
                                                // 다음 글자 색상 설정
                                                fontWeight: FontWeight.bold,
                                                // 다음 버튼 텍스트 굵기 설정
                                                fontSize: 20, // 다음 버튼 텍스트 크기 설정
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                    // SizedBox(height: 20),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.black, // 버튼 배경색
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // 버튼 모서리 라운드 설정
                          side: BorderSide(
                            color: Colors.black, // 버튼 테두리 색상
                            width: 2, // 버튼 테두리 두께
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      '회원 가입', // 버튼 텍스트
                      style: TextStyle(
                        color: Colors.white, // 버튼 텍스트 색상
                        fontWeight: FontWeight.bold, // 버튼 텍스트 굵기
                        fontSize: 20, // 버튼 텍스트 크기
                      ),
                    ),
                  ),
                ),
              ],
              // 필수 동의 사항 체크 박스 등의 위젯을 추가할 수 있습니다.
            ),
          ],
        ),
      ),
    ));
  }
}
