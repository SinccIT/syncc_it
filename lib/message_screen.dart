import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data_model.dart';

// bool _checkSmsPermission() {
//   // SMS 전송 권한 확인 로직
// }

// void _requestSmsPermission() {
//   // SMS 전송 권한 요청 로직
// }

class SendSMS extends StatefulWidget {
  const SendSMS({super.key});

  @override
  State<SendSMS> createState() => _SendSMSState();
}

// 상태 클래스
class _SendSMSState extends State<SendSMS> {

  List<String> recipients = [];
  String message = "";
  String selectedTime = "즉시";   // 전송시간 default값
  late TextEditingController msgEditingController;


  @override
  void initState() {
    super.initState();
    msgEditingController = TextEditingController();
  }

  @override
  // 해당 상태가 더이상 피룡하지 않을 때 호출. 리소스 해제 혹은 사용종료 객체 정리
  void dispose() {
    msgEditingController.dispose();
    super.dispose();
  }


  // 수신인 추가 버튼 클릭 시 호출되는 함수
  void addRecipients(BuildContext context) async {
    // 저장된 그룹 및 연락처 목록을 가져옴
    final dataModel = Provider.of<DataModel>(context, listen: false);

    // 선택된 그룹과 연락처를 담을 리스트
    List<String> selectedRecipients = [];

    // 모달창
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,   // 화면 아래에서부터 위로 슬라이딩하는 모달
      builder: (BuildContext context) {

        // 그룹과 연락처 목록을 합친 리스트
        List<String> combinedList = [];
        combinedList.addAll(dataModel.groupList.map((group) => group.groupName));
        combinedList.addAll(dataModel.contactList.map((contact) => contact.name));

        return Container(
          height: MediaQuery.of(context).size.height * 0.9, // 화면 높이의 90%
          color: Colors.white, // 배경색을 흰색으로 변경
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 모달 타이틀
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "그룹/연락처 추가",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // close 버튼
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),

              // 그룹과 연락처 목록을 한 ListView에 표시
              Expanded(
                child: ListView.builder(
                  itemCount: combinedList.length + 2,
                  itemBuilder: (context, index) {
                    // 그룹 목록
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                        child: Text(
                          "그룹",
                          style: TextStyle(
                            color: Color(0xFFC8C8C8),
                          ),
                        ),
                      );
                    }
                    // ****그룹 목록
                    else if (index < dataModel.groupList.length+1) {

                      bool isSelected = recipients.contains(combinedList[index-1]);

                      return ListTile(
                        title: Text(
                          combinedList[index-1],
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedRecipients.remove(combinedList[index-1]);
                              recipients.remove(combinedList[index-1]);
                            } else {
                              if(!recipients.contains(combinedList[index-1])) {
                                selectedRecipients.add(combinedList[index-1]);
                              }
                            }
                          });
                          isSelected = !isSelected;
                          print(selectedRecipients);
                        },
                        // 선택된 항목인 경우 색상 변경
                        trailing: Icon(
                          Icons.check,
                          color: isSelected ? Color(0xFF27F39D) : Color(0xFFC8C8C8),
                        ),
                      );
                    }
                    // 연락처 라벨
                    else if (index == dataModel.groupList.length+1) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                        child: Text(
                          "연락처",
                          style: TextStyle(
                            color: Color(0xFFC8C8C8),
                          ),
                        ),
                      );
                    }
                    // 연락처 목록
                    else {
                      return ListTile(
                        title: Text(
                          combinedList[index-2],
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          // 선택된 항목 처리
                        },
                      );
                    }
                  },
                ),
              ),
              // 추가하기 버튼
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // 추가하기 버튼 눌렀을 때 동작
                    setState(() {
                      recipients.addAll(selectedRecipients);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("확인"),
                ),
              ),
            ],
          ),
        );
      },
    );




  }

  // 수신인 삭제 버튼 클릭 시 호출되는 함수
  void removeRecipient(int index) {
    // dialog를 통해 수신인 삭제
    setState(() {
      recipients.removeAt(index);
    });
  }

  // 메시지 전송 함수
  void sendSMS() async {
    String uri = 'sms:${recipients.join(",")}?body=안녕하세요. 테스트 메시지 입니다.';
    if(await canLaunchUrl(uri as Uri)) {
      await launchUrl(uri as Uri);
    } else {
      throw 'Could not launch ${uri}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true
      ,
      appBar: AppBar(
        backgroundColor: Color(0xFF27F39D),
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
            icon: Icon(CupertinoIcons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.person),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                "수신인 목록",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        
            // 수신인 목록
            ListView.builder(
              shrinkWrap: true,
              itemCount: recipients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  title: Row(
                    children: [
                      IconButton(
                        onPressed: () => removeRecipient(index),
                        icon: Icon(
                          Icons.remove_circle,
                          color: Color(0xFFC8C8C8),
                        ),
                      ),
                      Text(recipients[index]),
                    ],
                  ),
                );
              },
            ),
        
            // 수신인 추가 버튼
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      addRecipients(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                        "그룹/연락처 추가",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            SizedBox(height: 20),
        
            // 전송대상
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  Text(
                    "전송 대상",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 28),
                  Text(
                    "${recipients.length}명",
                    style: TextStyle(
                      fontSize: 16,
                      color: recipients.length > 0 ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
        
            SizedBox(height: 20),
        
            // 전송방법
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  Text(
                    "전송 방법",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 28),
                  Text(
                    "문자 메시지(SMS)",
                    style: TextStyle(
                      fontSize: 16,
                      color: recipients.length > 0 ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
        
            SizedBox(height: 20),
        
            // 전송시간
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  Text(
                    "전송 시간",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 14),
                  Radio<String>(
                    value: "즉시",
                    groupValue: selectedTime,
                    onChanged: (value) {
                      setState(() {
                        selectedTime = value!;
                      });
                    },
                  ),
                  Text("즉시"),
                  SizedBox(width: 14),
                  Radio<String>(
                    value: "예약",
                    groupValue: selectedTime,
                    onChanged: (value) {
                      setState(() {
                        selectedTime = value!;
                      });
                    },
                  ),
                  Text("예약"),
                ],
              ),
            ),
        
            // 전송 메시지 입력
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: TextField(
                controller: msgEditingController,
                decoration: InputDecoration(
                  hintText: "메시지를 입력하세요.",
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                onChanged: (value) {
                  setState(() {
                    message = value;
                  });
                },
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:() {
                        // 입력 메시지 확인
                        print('${message}');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF27F39D)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)
                          ),
                        ),
                      ),
                      child: Text(
                        '미리보기',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

        
          ],
        ),
      ),
    );

  }
}
