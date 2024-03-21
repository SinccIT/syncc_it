import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("새로운 그룹 추가"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(labelText: '항목 이름'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 입력된 항목을 전달하고 창 닫기
                Navigator.pop(context, _textEditingController.text);
              },
              child: Text('추가'),
            ),
          ],
        ),
      ),
    );
  }
}

// 예시 데이터 배열
List<String> sharedItemDescriptions = [
  "One 아이템 설명",
  "LG전자 아이템 설명",
  "Two 아이템 설명",
  "Hymedia 아이템 설명",
  "SAMSUNG전자 아이템 설명",
  // 추가적인 아이템들에 대한 설명을 배열에 추가하세요
];

// 예시 데이터 배열
List<String> contactItems = [
  "박채연",
  "유윤경",
  "김성종",
  "이한조",
  "백승용",
  "송가람",
  // 추가적인 아이템들을 배열에 추가하세요
];

// 각 아이템에 대한 설명 배열
List<String> contactItemDescriptions = [
  "박채연 설명",
  "유윤경 설명",
  "김성종 설명",
  "이한조 설명",
  "백승용 설명",
  "송가람 설명",
  // 추가적인 아이템들에 대한 설명을 배열에 추가하세요
];
