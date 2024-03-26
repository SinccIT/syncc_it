// view_profile.dart 파일
import 'dart:io';
import 'package:flutter/material.dart';

class ViewProfile extends StatelessWidget {
  final String name;
  final String intro;
  final String email;
  final String id;
  final String phoneNumber;
  final String contactTime;
  final String profileImage;

  const ViewProfile({
    required this.name,
    required this.intro,
    required this.email,
    required this.id,
    required this.phoneNumber,
    required this.contactTime,
    required this.profileImage,
    Key? key,
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
                backgroundImage: profileImage.isNotEmpty &&
                        File(profileImage).existsSync() // 수정: File 사용
                    ? Image.file(File(profileImage)).image // 수정: Image.file 사용
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
