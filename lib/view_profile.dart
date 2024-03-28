import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncc_it/profile.dart'; // MyProfile 클래스를 임포트합니다.
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 패키지를 임포트합니다.
import 'package:syncc_it/home_page.dart';

class ViewProfile extends StatelessWidget {
  final String name;
  final String intro;
  final String email;
  final String id;
  final String phoneNumber;
  final String contactTime;
  final String profileImage;

  const ViewProfile({
    Key? key,
    required this.name,
    required this.intro,
    required this.email,
    required this.id,
    required this.phoneNumber,
    required this.contactTime,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage:
                    profileImage.isNotEmpty && File(profileImage).existsSync()
                        ? Image.file(File(profileImage)).image
                        : AssetImage('images/profile.png'),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  intro,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            buildProfileInfo('ID', id),
            SizedBox(height: 20),
            buildProfileInfo('E-MAIL', email),
            SizedBox(height: 20),
            buildProfileInfo('Phone Number', phoneNumber),
            SizedBox(height: 50),
            buildProfileInfo('연락가능시간', contactTime),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences
                    .getInstance(); // SharedPreferences 인스턴스를 가져옵니다.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyProfile(
                      prefs: prefs, // 가져온 SharedPreferences 인스턴스를 전달합니다.
                    ),
                  ),
                );
              },
              child: Text(
                '프로필 수정',
                style: TextStyle(color: Color(0xFF27F39D)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(), // MyHomePage 위젯을 사용합니다.
                  ),
                  (route) => false, // 모든 이전 라우트를 제거하기 위해 false를 반환합니다.
                );
              },
              child: Text(
                '홈 페이지로 돌아가기',
                style: TextStyle(color: Color(0xFF27F39D)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileInfo(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
