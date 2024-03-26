import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncc_it/view_profile.dart';
import 'package:syncc_it/profile.dart'; // MyProfile을 import합니다.

class HomePage extends StatelessWidget {
  final SharedPreferences prefs;
  const HomePage({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF27F390),
        title: Text(
          'SynccIT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Icon(
          Icons.menu,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: ViewProfile(
        name: '이름',
        intro: '안녕하세요. 반갑습니다.',
        email: 'example@example.com',
        id: 'example_id',
        phoneNumber: '010-1234-5678',
        contactTime: '-',
        profileImage: '', // 프로필 이미지 파일 경로
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MyProfile(prefs: prefs), // 수정: MyProfile로 변경
            ),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
