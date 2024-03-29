import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncc_it/message_preview.dart';

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
  int totalRecipientsCount = 0;

  String message = "";
  String selectedTime = "즉시"; // 전송시간 default값
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

  void _addGroup(List<String> selectedContacts) {
    setState(() {
      recipients = selectedContacts;
    });
  }

  // 수신인 추가 버튼 클릭 시 호출되는 함수
  void addRecipients(BuildContext context) async {
    final dataModel = Provider.of<DataModel>(context, listen: false);
    List<String> selectedRecipients = [];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        List<String> combinedList = [];
        combinedList
            .addAll(dataModel.groupList.map((group) => group.groupName));
        combinedList
            .addAll(dataModel.contactList.map((contact) => contact.name));

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: combinedList.length + 2,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 8.0),
                            child: Text(
                              "그룹",
                              style: TextStyle(
                                color: Color(0xFFC8C8C8),
                              ),
                            ),
                          );
                        } else if (index < dataModel.groupList.length + 1) {
                          bool isSelected = selectedRecipients
                              .contains(combinedList[index - 1]);

                          return ListTile(
                            title: Text(
                              combinedList[index - 1],
                              style: TextStyle(
                                fontSize: 19,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedRecipients
                                      .remove(combinedList[index - 1]);
                                } else {
                                  selectedRecipients
                                      .add(combinedList[index - 1]);
                                }
                              });
                            },
                            trailing: Icon(
                              Icons.check_box_rounded,
                              color: isSelected
                                  ? Color(0xFF27F39D)
                                  : Color(0xFFC8C8C8),
                            ),
                          );
                        } else if (index == dataModel.groupList.length + 1) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 8.0),
                            child: Text(
                              "연락처",
                              style: TextStyle(
                                color: Color(0xFFC8C8C8),
                              ),
                            ),
                          );
                        } else {
                          bool isSelected = selectedRecipients
                              .contains(combinedList[index - 2]);

                          return ListTile(
                            title: Text(
                              combinedList[index - 2],
                              style: TextStyle(
                                fontSize: 19,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedRecipients
                                      .remove(combinedList[index - 2]);
                                } else {
                                  selectedRecipients
                                      .add(combinedList[index - 2]);
                                }
                              });
                            },
                            trailing: Icon(
                              Icons.check_box_rounded,
                              color: isSelected
                                  ? Color(0xFF27F39D)
                                  : Color(0xFFC8C8C8),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // 선택된 항목을 수신인 목록에 추가
                        for (String recipient in selectedRecipients) {
                          if (!recipients.contains(recipient)) {
                            recipients.add(recipient);
                          }
                        }
                        _addGroup(recipients);

                        // 선택된 항목이 추가된 후에 selectedRecipients 비움
                        selectedRecipients.clear();

                        // 변경된 상태를 반영하기 위해 setState 호출

                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF27F39D)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "확인",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  contentPadding: EdgeInsets.symmetric(vertical: -2),
                  title: Row(
                    children: [
                      IconButton(
                        onPressed: () => removeRecipient(index),
                        icon: Icon(
                          Icons.remove_circle,
                          color: Color(0xFFC8C8C8),
                        ),
                      ),
                      Text(
                        recipients[index],
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
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
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      "수신인 추가",
                      style: TextStyle(
                        fontSize: 14,
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

            SizedBox(height: 28),

            // 전송시간
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 14.0),
            //   child: Row(
            //     children: [
            //       Text(
            //         "전송 시간",
            //         style: TextStyle(
            //           fontSize: 16,
            //         ),
            //       ),
            //       SizedBox(width: 14),
            //       Radio<String>(
            //         value: "즉시",
            //         groupValue: selectedTime,
            //         onChanged: (value) {
            //           setState(() {
            //             selectedTime = value!;
            //           });
            //         },
            //       ),
            //       Text("즉시"),
            //       SizedBox(width: 14),
            //       Radio<String>(
            //         value: "예약",
            //         groupValue: selectedTime,
            //         onChanged: (value) {
            //           setState(() {
            //             selectedTime = value!;
            //           });
            //         },
            //       ),
            //       Text("예약"),
            //     ],
            //   ),
            // ),

            // 전송 메시지 입력
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: TextField(
                controller: msgEditingController,
                decoration: InputDecoration(
                  hintText: "메시지를 입력하세요.",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEEEEEE)),
                  ),
                  focusColor: Color(0xFF27F39D),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF27F39D)),
                  ),
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 입력 메시지 확인
                        String message = msgEditingController.text;

                        // 다음화면으로 이동 및 메시지 전달
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreviewSMS(
                                message: message, recipients: recipients),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF27F39D)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                        ),
                      ),
                      child: Text(
                        '전송할 메시지 미리보기',
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
