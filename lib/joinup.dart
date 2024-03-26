import 'package:flutter/material.dart';

class JoinUpPage extends StatelessWidget {
  // 이름, 소속, 직무, 연령, 성별을 저장할 변수 선언
  String name = '';
  String affiliation = '';
  String position = '';
  String age = '';
  String gender = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF777777),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
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
                    TextFieldContainer(),
                  ],
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
                    TextFieldContainer(),
                  ],
                ),
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
                    TextFieldContainer(),
                  ],
                ),
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
                    TextFieldContainer(),
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
                    TextFieldContainer(),
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
                    TextFieldContainer(),
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
                    TextFieldContainer(),
                  ],
                ),
                SizedBox(height: 100), // 각 입력 필드와 회원가입 버튼 사이의 간격 조절
                SizedBox(
                  width: 150, // 버튼 너비
                  height: 50, // 버튼 높이
                  child: ElevatedButton(
                    onPressed: () {
                      // 회원가입 버튼 클릭 시 동작
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
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const TextFieldContainer({Key? key, this.onChanged}) : super(key: key);

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
