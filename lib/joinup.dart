import 'package:flutter/material.dart';

class JoinUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Color(0xFF777777), // 연한 회색 배경
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFieldContainer(label: '이름'),
              TextFieldContainer(label: '소속'),
              TextFieldContainer(label: '직무'),
              TextFieldContainer(label: '연령'),
              TextFieldContainer(label: '성별'),
              SizedBox(height: 20), // 각 입력 필드 사이의 간격 조절
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
    ));
  }
}

class TextFieldContainer extends StatelessWidget {
  final String label;

  const TextFieldContainer({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          SizedBox(
            width: 100, // 레이블 영역의 너비
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 20), // 레이블과 입력 필드 사이의 간격 조절
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '여기에 입력하세요', // 입력 필드에 대한 안내 문구
              ),
            ),
          ),
        ],
      ),
    );
  }
}
