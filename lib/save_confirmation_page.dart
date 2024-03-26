import 'package:flutter/material.dart';
import 'package:syncc_it/view_profile.dart'; // ViewProfile 클래스를 import 합니다.

class SaveConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('저장 완료'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '프로필이 성공적으로 저장되었습니다!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // viewprofile 페이지로 이동
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
