import 'package:flutter/material.dart';

class ViewProfile extends StatelessWidget {
  final String name;
  final String intro;
  final String email;
  final String id;
  final String phoneNumber;
  final String contactTime;

  const ViewProfile({
    required this.name,
    required this.intro,
    required this.email,
    required this.id,
    required this.phoneNumber,
    required this.contactTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Profile'), // 수정: 헤더 추가
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage:
                    AssetImage('images/profile.png'), // 수정: 프로필 사진 표시
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
