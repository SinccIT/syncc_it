import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data_model.dart';

class PreviewSMS extends StatefulWidget {
  final String message;
  final List<String> recipients;

  // 생성자 수정
  PreviewSMS({required this.message, required this.recipients});

  @override
  State<PreviewSMS> createState() => _PreviewSMSState();
}


// 상태 클래스
class _PreviewSMSState extends State<PreviewSMS> {
  late TextEditingController msgEditingController;

  @override
  void initState() {
    super.initState();
    msgEditingController = TextEditingController(text: widget.message);
  }

  @override
  void dispose() {
    msgEditingController.dispose();
    super.dispose();
  }

  void sendSMS() async {
    String body = Uri.encodeComponent(msgEditingController.text);

    for(var contact in widget.recipients) {
      String uriString = 'sms:';
      if(body.isNotEmpty) {
        uriString += '?body=${body}';
      }

      Uri uri = Uri.parse(uriString);

      // if (await LaunchUrl(uri)) {
      //   await launch(uri).then((success) {
      //     if (success) {
      //       print('SMS 전송 성공');
      //     } else {
      //       print('SMS 전송 실패');
      //     }
      //   });
      // } else {
      //   throw '$uri를 실행할 수 없습니다.';
      // }

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF27F39D),
        // title: Text(
        //   'SynccIT',
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // 이전 화면으로 이동
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(CupertinoIcons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.person),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '메시지 미리보기',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: msgEditingController,
              readOnly: true,
              maxLines: 10,
              decoration: InputDecoration(
                fillColor: Color(0xFFEEEEEE),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              '수신인',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 8),
            // 수신인 목록 표시
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.recipients.map((contact) {
                return Text(
                  contact,
                  style: TextStyle(fontSize: 16),
                );
              }).toList(),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child:
                    ElevatedButton(
                      onPressed: () {
                        // 메시지 전송 성공 알림창
                        showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                                child: Text("메시지가 성공적으로 전송되었습니다.")
                            ),
                            contentPadding: EdgeInsets.all(30.0),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // 알림창 닫기
                                },
                                child: Text(
                                  "확인",
                                  style: TextStyle(
                                    color: Color(0xFF27F39D),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF27F39D)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                      child: Text(
                          'SMS 전송',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
